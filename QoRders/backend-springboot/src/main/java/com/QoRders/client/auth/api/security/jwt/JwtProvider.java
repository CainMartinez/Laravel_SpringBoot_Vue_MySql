package com.QoRders.client.auth.api.security.jwt;

import com.QoRders.client.auth.domain.entity.BlacklistTokenEntity;
import com.QoRders.client.auth.domain.repository.BlacklistTokenRepository;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;

import org.springframework.security.core.Authentication;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Component
@RequiredArgsConstructor
public class JwtProvider {

    private static final Logger logger = LoggerFactory.getLogger(JwtProvider.class);

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

    public String generateAccessToken(String email) {
        return generateToken(email, accessTokenExpiration);
    }

    public String generateRefreshToken(String email) {
        return generateToken(email, refreshTokenExpiration);
    }

    private String generateToken(String email, long expirationTime) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("role", "client");

        return Jwts.builder()
                .setClaims(claims)
                .setSubject(email)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + expirationTime))
                .signWith(getKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    public String parseAccessToken(String token) {
        try {
            if (token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();

            logger.info("Claims decodificados: {}" + claims);
            return claims.getSubject(); // Asegúrate de que 'subject' contiene el email
        } catch (ExpiredJwtException e) {
            logger.warn("El token ha expirado: {}" + e.getMessage(), e);
            throw new IllegalArgumentException("Token ha expirado");
        } catch (JwtException e) {
            logger.error("Error al parsear el token: {}" + e.getMessage(), e);
            throw new IllegalArgumentException("Token inválido");
        }
    }

    public BlacklistTokenEntity invalidateRefreshToken(String token) {
        try {
            // System.out.println("Token recibido en invalidateRefreshToken: " + token);
    
            var claims = Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
    
            // System.out.println("Claims parseados: " + claims);
    
            var tokenEntity = new BlacklistTokenEntity();
            tokenEntity.setToken(token);
            tokenEntity.setEmail(claims.getSubject());
            tokenEntity.setExpirationDate(claims.getExpiration());
            return tokenEntity;
        } catch (ExpiredJwtException e) {
            // System.err.println("El token ha expirado: " + e.getMessage());
            throw new IllegalArgumentException("Token ha expirado");
        } catch (JwtException e) {
            // System.err.println("Error al parsear el token en invalidateRefreshToken: " + e.getMessage());
            throw new IllegalArgumentException("Invalid token");
        }
    }

    public boolean isTokenBlacklisted(String token) {
        return blacklistTokenRepository.existsByToken(token);
    }

    public Claims getClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (JwtException e) {
            throw new IllegalArgumentException("Invalid token");
        }
    }
    
    public boolean isValid(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (JwtException e) {
            return false;
        }
    }

    public Authentication getAuthentication(String email, String role) {
        var authorities = List.of(new SimpleGrantedAuthority(role)); // Crear autoridad con el rol
        return new UsernamePasswordAuthenticationToken(email, null, authorities); // Retornar Authentication
    }
}