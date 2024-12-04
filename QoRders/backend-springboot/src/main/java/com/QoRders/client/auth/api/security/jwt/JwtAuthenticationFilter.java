package com.QoRders.client.auth.api.security.jwt;

import com.QoRders.client.auth.domain.service.AuthService;
import com.QoRders.client.client.domain.repository.ClientRepository;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtProvider jwtProvider;
    private final AuthService authService;
    private final ClientRepository clientRepository;

    @Override
    protected void doFilterInternal(
        @SuppressWarnings("null") HttpServletRequest request,
        @SuppressWarnings("null") HttpServletResponse response,
        @SuppressWarnings("null") FilterChain filterChain
    ) throws ServletException, IOException {
        String accessToken = resolveToken(request);

        if (accessToken != null) {
            try {
                // Decodificar el email desde el token
                String email = jwtProvider.parseAccessToken(accessToken);

                // Validar y extraer claims del token
                var claims = jwtProvider.getClaims(accessToken);
                String role = claims.get("role", String.class);

                if (!"client".equals(role)) {
                    throw new IllegalArgumentException("Invalid role in Access Token");
                }

                // Establecer el contexto de seguridad
                var authentication = jwtProvider.getAuthentication(email, role);
                SecurityContextHolder.getContext().setAuthentication(authentication);

            } catch (ExpiredJwtException e) {
                handleRefreshToken(request, response, accessToken, filterChain);
                return;
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Unauthorized: Invalid Access Token");
                return;
            }
        }
        filterChain.doFilter(request, response);
    }

    private void handleRefreshToken(
            HttpServletRequest request,
            HttpServletResponse response,
            String expiredAccessToken,
            FilterChain filterChain
    ) throws IOException {
        try {
            // Extraer email del Access Token expirado
            String emailFromAccess = jwtProvider.parseAccessToken(expiredAccessToken);

            // Obtener Refresh Token desde la base de datos
            var client = clientRepository.findByEmail(emailFromAccess)
                    .orElseThrow(() -> new IllegalArgumentException("Client not found"));
            String refreshToken = client.getRefreshToken();

            // Validar Refresh Token
            if (!jwtProvider.isValid(refreshToken)) {
                authService.logout(refreshToken); // Logout si Refresh Token es inválido
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("Unauthorized: Refresh Token expired");
                return;
            }

            // Crear nuevo Access Token
            String newAccessToken = jwtProvider.generateAccessToken(emailFromAccess);

            // Configurar nuevo contexto de seguridad
            var claims = jwtProvider.getClaims(refreshToken);
            String role = claims.get("role", String.class);

            SecurityContextHolder.getContext().setAuthentication(jwtProvider.getAuthentication(emailFromAccess, role));

            // Enviar el nuevo token al cliente
            response.setHeader("New-Access-Token", newAccessToken);
            filterChain.doFilter(request, response);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Unauthorized: Unable to refresh token");
        }
    }

    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}