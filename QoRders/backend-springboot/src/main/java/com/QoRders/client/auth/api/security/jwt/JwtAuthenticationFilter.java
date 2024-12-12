package com.QoRders.client.auth.api.security.jwt;

import com.QoRders.client.auth.domain.service.AuthService;
import com.QoRders.client.client.domain.repository.ClientRepository;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private static final String AUTH_HEADER = "Authorization";
    private static final String TOKEN_PREFIX = "Bearer ";
    private static final String ROLE_CLIENT = "client";

    private final JwtProvider jwtProvider;
    private final AuthService authService;
    private final ClientRepository clientRepository;

    /**
     * Filtro para autenticar solicitudes basadas en el token JWT.
     */
    @Override
    protected void doFilterInternal(
        @SuppressWarnings("null") HttpServletRequest request,
        @SuppressWarnings("null") HttpServletResponse response,
        @SuppressWarnings("null") FilterChain filterChain
    ) throws ServletException, IOException {
        String accessToken = resolveToken(request);

        if (accessToken != null) {
            try {
                // Validar el token y establecer el contexto de seguridad
                authenticateAccessToken(accessToken);
            } catch (ExpiredJwtException e) {
                log.warn("Access Token expired: {}", e.getMessage());
                handleRefreshToken(request, response, accessToken, filterChain);
                return;
            } catch (Exception e) {
                log.error("Token validation failed: {}", e.getMessage());
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Unauthorized: Invalid Access Token");
                return;
            }
        }

        // Continuar con la cadena de filtros
        filterChain.doFilter(request, response);
    }

    /**
     * Autentica el token de acceso JWT.
     *
     * @param accessToken Token JWT a validar.
     */
    private void authenticateAccessToken(String accessToken) {
        // Extraer y validar email desde el token
        String email = jwtProvider.parseAccessToken(accessToken);

        // Validar y extraer los claims
        var claims = jwtProvider.getClaims(accessToken);
        String role = claims.get("role", String.class);

        if (!ROLE_CLIENT.equals(role)) {
            throw new IllegalArgumentException("Invalid role in Access Token");
        }

        // Establecer contexto de seguridad
        var authentication = jwtProvider.getAuthentication(email, role);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        log.debug("Successfully authenticated client with email: {}", email);
    }

    /**
     * Maneja la lógica del Refresh Token si el Access Token ha expirado.
     */
    private void handleRefreshToken(
            HttpServletRequest request,
            HttpServletResponse response,
            String expiredAccessToken,
            FilterChain filterChain
    ) throws IOException {
        try {
            // Extraer email del Access Token expirado
            String email = jwtProvider.parseAccessToken(expiredAccessToken);

            // Obtener el cliente desde el repositorio
            var client = clientRepository.findByEmail(email)
                    .orElseThrow(() -> new IllegalArgumentException("Client not found"));

            String refreshToken = client.getRefreshToken();

            // Validar Refresh Token
            if (!jwtProvider.isValid(refreshToken)) {
                log.warn("Invalid Refresh Token for client: {}", email);
                authService.logout(refreshToken);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Unauthorized: Refresh Token expired");
                return;
            }

            // Generar un nuevo Access Token
            String newAccessToken = jwtProvider.generateAccessToken(email);

            // Configurar el contexto de seguridad con el nuevo token
            var claims = jwtProvider.getClaims(refreshToken);
            String role = claims.get("role", String.class);

            SecurityContextHolder.getContext().setAuthentication(jwtProvider.getAuthentication(email, role));

            // Añadir el nuevo token en los headers de respuesta
            response.setHeader("New-Access-Token", newAccessToken);

            log.info("Successfully refreshed Access Token for client: {}", email);

            filterChain.doFilter(request, response);

        } catch (Exception e) {
            log.error("Failed to refresh token: {}", e.getMessage());
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized: Unable to refresh token");
        }
    }

    /**
     * Extrae el token desde el encabezado Authorization.
     *
     * @param request Solicitud HTTP.
     * @return Token JWT si está presente, de lo contrario, null.
     */
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader(AUTH_HEADER);
        if (bearerToken != null && bearerToken.startsWith(TOKEN_PREFIX)) {
            return bearerToken.substring(TOKEN_PREFIX.length());
        }
        return null;
    }
}