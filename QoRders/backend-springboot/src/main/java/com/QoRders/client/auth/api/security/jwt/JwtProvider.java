package com.QoRders.client.auth.api.security.jwt;

import com.QoRders.client.auth.domain.entity.BlacklistTokenEntity;
import com.QoRders.client.auth.domain.repository.BlacklistTokenRepository;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class JwtProvider {

    private static final String ROLE_KEY = "role"; // Constante para la clave del rol
    private static final String TOKEN_PREFIX = "Bearer ";

    private final BlacklistTokenRepository blacklistTokenRepository;

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.access-expiration}")
    private long accessTokenExpiration;

    @Value("${jwt.refresh-expiration}")
    private long refreshTokenExpiration;

    private SecretKey getKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    /**
     * Genera un Access Token para un usuario con un email específico.
     */
    public String generateAccessToken(String email) {
        return generateToken(email, accessTokenExpiration);
    }

    /**
     * Genera un Access Token temporal para un usuario con un email específico.
     */
    public String generateTemporalAccessToken(String email, long expirationTime) {
        return generateToken(email, expirationTime);
    }

    /**
     * Genera un Refresh Token para un usuario con un email específico.
     */
    public String generateRefreshToken(String email) {
        return generateToken(email, refreshTokenExpiration);
    }

    /**
     * Método genérico para generar un token JWT.
     */
    private String generateToken(String email, long expirationTime) {
        Map<String, Object> claims = new HashMap<>();
        claims.put(ROLE_KEY, "client");

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(getKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Extrae y valida el token de acceso, retornando el email.
     */
    public String parseAccessToken(String token) {
        try {
            if (token.startsWith(TOKEN_PREFIX)) {
                token = token.substring(TOKEN_PREFIX.length());
            }
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            log.info("Token claims decoded: {}", claims);
            return claims.getSubject();
        } catch (ExpiredJwtException e) {
            log.warn("Token has expired: {}", e.getMessage());
            throw new IllegalArgumentException("Token has expired", e);
        } catch (JwtException e) {
            log.error("Error parsing token: {}", e.getMessage());
            throw new IllegalArgumentException("Invalid token", e);
        }
    }

    /**
     * Invalida un Refresh Token añadiéndolo a la lista negra.
     */
    public BlacklistTokenEntity invalidateRefreshToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            BlacklistTokenEntity tokenEntity = new BlacklistTokenEntity();
            tokenEntity.setToken(token);
            tokenEntity.setEmail(claims.getSubject());
            tokenEntity.setExpirationDate(claims.getExpiration());

            return blacklistTokenRepository.save(tokenEntity);
        } catch (ExpiredJwtException e) {
            log.warn("Token already expired: {}", e.getMessage());
            throw new IllegalArgumentException("Token already expired", e);
        } catch (JwtException e) {
            log.error("Error parsing token for invalidation: {}", e.getMessage());
            throw new IllegalArgumentException("Invalid token", e);
        }
    }

    /**
     * Verifica si un token está en la lista negra.
     */
    public boolean isTokenBlacklisted(String token) {
        boolean isBlacklisted = blacklistTokenRepository.existsByToken(token);
        log.debug("Token {} blacklisted: {}", token, isBlacklisted);
        return isBlacklisted;
    }

    /**
     * Obtiene los claims de un token.
     */
    public Claims getClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (JwtException e) {
            log.error("Error parsing claims: {}", e.getMessage());
            throw new IllegalArgumentException("Invalid token", e);
        }
    }

    /**
     * Verifica si un token es válido.
     */
    public boolean isValid(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (JwtException e) {
            log.warn("Invalid token: {}", e.getMessage());
            return false;
        }
    }

    /**
     * Retorna la autenticación basada en el email y rol extraídos del token.
     */
    public Authentication getAuthentication(String email, String role) {
        var authorities = List.of(new SimpleGrantedAuthority(role));
        return new UsernamePasswordAuthenticationToken(email, null, authorities);
    }

    /**
     * Devuelve el tiempo de expiración del Access Token en milisegundos.
     */
    public long getAccessTokenExpiration() {
        return accessTokenExpiration;
    }

    /**
     * Devuelve el tiempo de expiración del Access Token en segundos.
     */
    public long getAccessTokenExpirationInSeconds() {
        return accessTokenExpiration / 1000;
    }
}