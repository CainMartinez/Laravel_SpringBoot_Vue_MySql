package com.QoRders.client.auth.domain.service;

import com.QoRders.client.auth.api.request.LoginRequest;
import com.QoRders.client.auth.api.request.RegisterRequest;
import com.QoRders.client.auth.api.response.AuthResponse;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.auth.domain.repository.BlacklistTokenRepository;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;

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

    // Establecer valores predeterminados para otros campos
    client.setBio(null);
    client.setPhoneNumber(null);
    client.setAvatarUrl("https://i.pravatar.cc/150?u=" + registerRequest.getFirstName());
    client.setAge(null);
    client.setAddress(null);
    client.setIsActive(true);

    var savedClient = clientRepository.save(client);

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
        // Validate client
        var client = clientRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Invalid email or password"));

        if (!passwordEncoder.matches(loginRequest.getPassword(), client.getPassword())) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        // Generate tokens
        var accessToken = jwtProvider.generateAccessToken(client.getEmail());
        var refreshToken = jwtProvider.generateRefreshToken(client.getEmail());

        // Update refresh token in the database
        client.setRefreshToken(refreshToken);
        clientRepository.save(client);

        // Return response
        return authAssembler.toAuthResponse(client, accessToken, refreshToken);
    }

    @Transactional
    public void logout(String accessToken) {
        try {
            // System.out.println("Token recibido para logout: " + accessToken);
            
            if (accessToken.startsWith("Bearer ")) {
                accessToken = accessToken.substring(7); // Quitar el prefijo "Bearer "
            }

            // var email = jwtProvider.parseAccessToken(accessToken);
            // System.out.println("Email parseado del token: " + email);

            if (jwtProvider.isTokenBlacklisted(accessToken)) {
                throw new IllegalArgumentException("Token ya está en la blacklist");
            }

            // Invalidate token
            var tokenEntity = jwtProvider.invalidateRefreshToken(accessToken);

            // Add token to blacklist
            blacklistTokenRepository.save(tokenEntity);
            System.out.println("Token agregado a la blacklist: " + tokenEntity.getToken());
        } catch (Exception e) {
            System.err.println("Error durante el logout: " + e.getMessage());
            throw new IllegalArgumentException("Invalid token");
        }
    }

    @Transactional
    public AuthResponse refreshAccessToken(String accessToken) {
        // Eliminar "Bearer " del token si está presente
        accessToken = accessToken.replace("Bearer ", "");

        String email;
        try {
            // Intentar parsear el access token (puede fallar si ha expirado)
            email = jwtProvider.parseAccessToken(accessToken);
        } catch (ExpiredJwtException e) {
            // Si el token expiró, intentar manejarlo con el refresh token
            email = e.getClaims().getSubject();
        }

        // Buscar el cliente en la base de datos
        var client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalArgumentException("Client not found"));

        // Verificar el refresh token en la base de datos
        String refreshToken = client.getRefreshToken();
        if (!jwtProvider.isValid(refreshToken)) {
            // Si el refresh token no es válido, llamar al logout
            logout(refreshToken);
            throw new IllegalArgumentException("Refresh token expired or invalid");
        }

        // Verificar que el email del access token coincide con el refresh token
        String refreshEmail = jwtProvider.parseAccessToken(refreshToken);
        if (!email.equals(refreshEmail)) {
            throw new IllegalArgumentException("Access and Refresh tokens do not match");
        }

        // Generar un nuevo access token
        String newAccessToken = jwtProvider.generateAccessToken(email);

        // Retornar la respuesta con el nuevo access token
        return authAssembler.toAuthResponse(client, newAccessToken, refreshToken);
    }
}