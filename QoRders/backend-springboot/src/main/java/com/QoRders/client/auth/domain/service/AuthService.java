package com.QoRders.client.auth.domain.service;

import com.QoRders.client.auth.api.request.LoginRequest;
import com.QoRders.client.auth.api.request.RegisterRequest;
import com.QoRders.client.auth.api.response.AuthResponse;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.auth.domain.repository.BlacklistTokenRepository;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;
import com.QoRders.client.redis.RedisService;

import io.jsonwebtoken.ExpiredJwtException;

import com.QoRders.client.auth.api.assembler.AuthAssembler;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final ClientRepository clientRepository;
    private final BlacklistTokenRepository blacklistTokenRepository;
    private final JwtProvider jwtProvider;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthAssembler authAssembler;
    private final RedisService redisService; // Inyectar RedisService

    @Transactional
    public AuthResponse register(RegisterRequest registerRequest) {
        // Validar que las contraseñas coincidan
        if (!registerRequest.getPassword().equals(registerRequest.getRepeatPassword())) {
            throw new IllegalArgumentException("Passwords do not match");
        }

        // Comprobar si el email ya existe
        if (clientRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email already in use");
        }

        // Crear usuario con los campos permitidos
        var client = new ClientEntity();
        client.setCustomerUuid(UUID.randomUUID().toString()); // Generar UUID único
        client.setEmail(registerRequest.getEmail());
        client.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        client.setFirstName(registerRequest.getFirstName());
        client.setLastName(registerRequest.getLastName());

        // Guardar datos adicionales
        client.setBio(null);
        client.setPhoneNumber(null);
        client.setAvatarUrl("https://i.pravatar.cc/150?u=" + registerRequest.getFirstName());
        client.setAge(null);
        client.setAddress(null);
        client.setIsActive(true);

        var savedClient = clientRepository.save(client);

        // Guardar en Redis las credenciales
        String redisKey = "email:password:" + savedClient.getEmail();
        redisService.save(redisKey, savedClient.getPassword(), 0); // Sin expiración

        // Generar tokens
        var accessToken = jwtProvider.generateAccessToken(savedClient.getEmail());
        var refreshToken = jwtProvider.generateRefreshToken(savedClient.getEmail());

        // Guardar el refresh token en el usuario
        savedClient.setRefreshToken(refreshToken);
        clientRepository.save(savedClient);

        // Retornar respuesta
        return authAssembler.toAuthResponse(savedClient, accessToken, refreshToken);
    }

    @Transactional
    public AuthResponse login(LoginRequest loginRequest) {
        // Buscar en Redis las credenciales
        String redisKey = "email:password:" + loginRequest.getEmail();
        String hashedPassword = (String) redisService.get(redisKey);

        if (hashedPassword == null) {
            // Si no está en Redis, buscar en la base de datos
            var client = clientRepository.findByEmail(loginRequest.getEmail())
                    .orElseThrow(() -> new IllegalArgumentException("Invalid email or password"));

            // Validar contraseña
            if (!passwordEncoder.matches(loginRequest.getPassword(), client.getPassword())) {
                throw new IllegalArgumentException("Invalid email or password");
            }

            // Guardar en Redis para futuros logins
            redisService.save(redisKey, client.getPassword(), 0); // Sin expiración
            hashedPassword = client.getPassword(); // Actualizar la referencia
        } else {
            // Validar contraseña directamente desde Redis
            if (!passwordEncoder.matches(loginRequest.getPassword(), hashedPassword)) {
                throw new IllegalArgumentException("Invalid email or password");
            }
        }

        // Generar tokens
        var accessToken = jwtProvider.generateAccessToken(loginRequest.getEmail());
        var refreshToken = jwtProvider.generateRefreshToken(loginRequest.getEmail());

        // Guardar el refresh token en la base de datos
        var client = clientRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Invalid email or password"));
        client.setRefreshToken(refreshToken);
        clientRepository.save(client);

        // Guardar el accessToken en Redis con TTL
        String accessTokenKey = "access:token:" + loginRequest.getEmail();
        redisService.save(accessTokenKey, accessToken, jwtProvider.getAccessTokenExpiration() / 1000);

        // Retornar respuesta
        return authAssembler.toAuthResponse(client, accessToken, refreshToken);
    }

    @Transactional
    public void logout(String accessToken) {
        try {
            if (accessToken.startsWith("Bearer ")) {
                accessToken = accessToken.substring(7); // Quitar el prefijo "Bearer "
            }

            if (jwtProvider.isTokenBlacklisted(accessToken)) {
                throw new IllegalArgumentException("Token ya está en la blacklist");
            }

            // Invalidate token y agregarlo a la blacklist
            var tokenEntity = jwtProvider.invalidateRefreshToken(accessToken);
            blacklistTokenRepository.save(tokenEntity);

            // Eliminar el token de Redis
            String accessTokenKey = "access:token:" + jwtProvider.parseAccessToken(accessToken);
            redisService.delete(accessTokenKey);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid token", e);
        }
    }

    @Transactional
    public AuthResponse refreshAccessToken(String accessToken) {
        accessToken = accessToken.replace("Bearer ", "");

        String email;
        try {
            email = jwtProvider.parseAccessToken(accessToken);
        } catch (ExpiredJwtException e) {
            email = e.getClaims().getSubject();
        }

        var client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Client not found"));

        String refreshToken = client.getRefreshToken();
        if (!jwtProvider.isValid(refreshToken)) {
            logout(refreshToken);
            throw new IllegalArgumentException("Refresh token expired or invalid");
        }

        String refreshEmail = jwtProvider.parseAccessToken(refreshToken);
        if (!email.equals(refreshEmail)) {
            throw new IllegalArgumentException("Access and Refresh tokens do not match");
        }

        // Generar un nuevo access token
        String newAccessToken = jwtProvider.generateAccessToken(email);

        // Actualizar el accessToken en Redis
        String accessTokenKey = "access:token:" + email;
        redisService.save(accessTokenKey, newAccessToken, jwtProvider.getAccessTokenExpiration() / 1000);

        return authAssembler.toAuthResponse(client, newAccessToken, refreshToken);
    }
}