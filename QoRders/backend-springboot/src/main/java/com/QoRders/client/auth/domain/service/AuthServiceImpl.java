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
    public AuthResponse register(RegisterRequest registerRequest) {
        // Validar contraseñas y guardar cliente
        if (!registerRequest.getPassword().equals(registerRequest.getRepeatPassword())) {
            throw new IllegalArgumentException("Passwords do not match");
        }
        if (clientRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email already in use");
        }

        var client = new ClientEntity();
        client.setCustomerUuid(UUID.randomUUID().toString());
        client.setEmail(registerRequest.getEmail());
        client.setPassword(passwordEncoder.encode(registerRequest.getPassword()));
        client.setFirstName(registerRequest.getFirstName());
        client.setLastName(registerRequest.getLastName());
        client.setAvatarUrl("https://i.pravatar.cc/150?u=" + registerRequest.getFirstName());
        client.setIsActive(true);

        var savedClient = clientRepository.save(client);

        // Generar tokens
        var accessToken = jwtProvider.generateAccessToken(savedClient.getEmail());
        var refreshToken = jwtProvider.generateRefreshToken(savedClient.getEmail());

        savedClient.setRefreshToken(refreshToken);
        clientRepository.save(savedClient);

        return authAssembler.toAuthResponse(savedClient, accessToken, refreshToken);
    }

    @Override
    @Transactional
        public AuthResponse login(LoginRequest loginRequest) {
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
        client.setRefreshToken(refreshToken);
        clientRepository.save(client);
    
        // Guardar el access token en Redis
        String accessTokenKey = "access:token:" + loginRequest.getEmail();
        redisService.save(accessTokenKey, accessToken, jwtProvider.getAccessTokenExpiration() / 1000);
    
        // Retornar la respuesta de autenticación
        return authAssembler.toAuthResponse(client, accessToken, refreshToken);
    }

    @Override
    @Transactional
    public void logout(String accessToken) {
        try {
            if (accessToken.startsWith("Bearer ")) {
                accessToken = accessToken.substring(7);
            }
            if (jwtProvider.isTokenBlacklisted(accessToken)) {
                throw new IllegalArgumentException("Token ya está en la blacklist");
            }

            var tokenEntity = jwtProvider.invalidateRefreshToken(accessToken);
            blacklistTokenRepository.save(tokenEntity);

            String accessTokenKey = "access:token:" + jwtProvider.parseAccessToken(accessToken);
            redisService.delete(accessTokenKey);
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid token", e);
        }
    }

    @Override
    @Transactional
    public AuthResponse refreshAccessToken(String accessToken) {
        accessToken = accessToken.replace("Bearer ", "");
        String email = jwtProvider.parseAccessToken(accessToken);

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

        String newAccessToken = jwtProvider.generateAccessToken(email);
        String accessTokenKey = "access:token:" + email;
        redisService.save(accessTokenKey, newAccessToken, jwtProvider.getAccessTokenExpiration() / 1000);

        return authAssembler.toAuthResponse(client, newAccessToken, refreshToken);
    }
}