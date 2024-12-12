package com.QoRders.client.auth.domain.service;

import com.QoRders.client.auth.api.request.LoginRequest;
import com.QoRders.client.auth.api.request.RegisterRequest;
import com.QoRders.client.auth.api.response.AuthResponse;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.auth.api.assembler.AuthAssembler;
import com.QoRders.client.auth.domain.repository.BlacklistTokenRepository;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;
import com.QoRders.client.redis.RedisService;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final ClientRepository clientRepository;
    private final BlacklistTokenRepository blacklistTokenRepository;
    private final JwtProvider jwtProvider;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthAssembler authAssembler;
    private final RedisService redisService;

    @Override
    @Transactional
    public void register(RegisterRequest registerRequest) {
        // Validar contraseñas y guardar cliente
        if (!registerRequest.getPassword().equals(registerRequest.getRepeatPassword())) {
            throw new IllegalArgumentException("Passwords do not match");
        }
        if (clientRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email already in use");
        }

        var client = new ClientEntity();
        client.setClient_uuid(UUID.randomUUID().toString());
        client.setEmail(registerRequest.getEmail());
        client.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        client.setFirstName(registerRequest.getFirstName());
        client.setLastName(registerRequest.getLastName());
        client.setAvatar_url("https://i.pravatar.cc/150?u=" + registerRequest.getFirstName());
        client.setIs_active(true);

        clientRepository.save(client);
    }

    @Override
    @Transactional
    public String login(LoginRequest loginRequest) {
        // Buscar el cliente en la base de datos
        var client = clientRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Invalid email or password"));

        // Comprobar si la contraseña es incorrecta
        if (!passwordEncoder.matches(loginRequest.getPassword(), client.getPassword())) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        // Generar tokens
        var accessToken = jwtProvider.generateAccessToken(loginRequest.getEmail());
        var refreshToken = jwtProvider.generateRefreshToken(loginRequest.getEmail());

        // Guardar el refresh token en el cliente
        client.setRefresh_token(refreshToken);
        clientRepository.save(client);

        // Crear la clave de Redis
        String redisKey = "springboot_logged_client_" + loginRequest.getEmail();

        // Crear los datos para guardar en Redis
        Map<String, Object> redisData = new HashMap<>();
        redisData.put("client", client);
        redisData.put("token", accessToken);

        // Calcular el TTL del token en segundos
        long ttl = jwtProvider.getAccessTokenExpiration() / 1000;

        // Guardar en Redis con TTL
        redisService.save(redisKey, redisData, ttl);

        // Retornar la respuesta de autenticación
        return authAssembler.toTokenResponse(accessToken);
    }

    @Override
    @Transactional
    public void logout(String accessToken) {
        try {
            // Verificar si el token es del tipo Bearer y limpiarlo
            if (accessToken.startsWith("Bearer ")) {
                accessToken = accessToken.substring(7);
            }

            // Verificar si el token ya está en la blacklist
            if (jwtProvider.isTokenBlacklisted(accessToken)) {
                throw new IllegalArgumentException("Token ya está en la blacklist");
            }

            // Añadir el token a la blacklist
            var tokenEntity = jwtProvider.invalidateRefreshToken(accessToken);
            blacklistTokenRepository.save(tokenEntity);

            // Obtener el email del cliente desde el token
            String email = jwtProvider.parseAccessToken(accessToken);

            // Clave para Redis
            String redisKey = "springboot_logged_client_" + email;

            // Eliminar el registro completo en Redis
            redisService.delete(redisKey);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid token during logout", e);
        }
    }

    @Override
    @Transactional
    public AuthResponse refreshAccessToken(String accessToken) {
        accessToken = accessToken.replace("Bearer ", "");
        String email = jwtProvider.parseAccessToken(accessToken);

        var client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Client not found"));

        String refreshToken = client.getRefresh_token();
        if (!jwtProvider.isValid(refreshToken)) {
            logout(refreshToken);
            throw new IllegalArgumentException("Refresh token expired or invalid");
        }
        String refreshEmail = jwtProvider.parseAccessToken(refreshToken);
        if (!email.equals(refreshEmail)) {
            throw new IllegalArgumentException("Access and Refresh tokens do not match");
        }

        String newAccessToken = jwtProvider.generateAccessToken(email);
        String accessTokenKey = "access:token:" + email;
        redisService.save(accessTokenKey, newAccessToken, jwtProvider.getAccessTokenExpiration() / 1000);

        return authAssembler.toAuthResponse(client, newAccessToken);
    }
}