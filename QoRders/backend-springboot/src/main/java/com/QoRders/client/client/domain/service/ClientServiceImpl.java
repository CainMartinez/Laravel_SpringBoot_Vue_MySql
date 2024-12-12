package com.QoRders.client.client.domain.service;

import com.QoRders.client.auth.api.security.utils.AuthUtils;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.exceptions.ClientNotAuthenticatedException;
import com.QoRders.client.client.domain.exceptions.ClientNotFoundException;
import com.QoRders.client.client.domain.repository.ClientRepository;
import com.QoRders.client.redis.RedisService;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClientServiceImpl implements ClientService {

    private final ClientRepository clientRepository;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthUtils authUtils;
    private final RedisService redisService;
    private final JwtProvider jwtProvider;

    @Override
    public Map<String, Object> getProfile(String token) {
        // Extraer el email desde el token
        String email = extractEmailFromToken(token);

        // Generar la clave de Redis
        String redisKey = "springboot_logged_client_" + email;

        // Obtener los datos de Redis
        @SuppressWarnings("unchecked")
        Map<String, Object> redisData = (Map<String, Object>) redisService.get(redisKey);

        if (redisData == null) {
            throw new ClientNotFoundException("Client data not found in Redis for email: " + email);
        }

        // Retornar los datos sin @class
        return cleanRedisData(redisData);
    }

    /**
     * Elimina las referencias a @class del mapa de Redis.
     *
     * @param redisData Datos obtenidos desde Redis.
     * @return Datos limpios sin referencias a @class.
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> cleanRedisData(Map<String, Object> redisData) {
        // Crear un mapa limpio
        Map<String, Object> cleanData = new HashMap<>();

        redisData.forEach((key, value) -> {
            if (value instanceof Map) {
                cleanData.put(key, cleanRedisData((Map<String, Object>) value)); // Limpiar mapas anidados
            } else {
                cleanData.put(key, value);
            }
        });

        return cleanData;
    }

    /**
     * Extrae el email del token JWT.
     *
     * @param token El token JWT.
     * @return El email extraído del token.
     */
    private String extractEmailFromToken(String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        return jwtProvider.parseAccessToken(token);
    }

    @Override
    @Transactional
    public Map<String, Object> updateProfile(ClientEntity client, String token) {
        // Actualizar el cliente en la base de datos
        var updatedClient = clientRepository.save(client);

        // Sobrescribir los datos en Redis
        String redisKey = "springboot_logged_client_" + client.getEmail();
        Map<String, Object> redisData = new HashMap<>();
        redisData.put("client", updatedClient);
        redisData.put("token", token);
        long ttl = jwtProvider.getAccessTokenExpirationInSeconds();

        redisService.save(redisKey, redisData, ttl);

        // Retornar los datos actualizados
        return redisData;
    }

    @Override
    public ClientEntity registerClient(ClientEntity client) {
        String hashedPassword = passwordEncoder.encode(client.getPassword());
        client.setPassword(hashedPassword);
        return clientRepository.save(client);
    }

    @Override
    public Optional<ClientEntity> findClientByEmail(String email) {
        return clientRepository.findByEmail(email);
    }

    @Override
    public boolean validatePassword(String rawPassword, String hashedPassword) {
        return passwordEncoder.matches(rawPassword, hashedPassword);
    }

    @Override
    @Transactional
    public void deleteClientById(Integer id) {
        clientRepository.deleteById(id);
    }

    @Override
    public ClientEntity getCurrentClient() {
        String email = authUtils.getCurrentClientEmail();

        if ("anonymousUser".equals(email)) {
            throw new ClientNotAuthenticatedException("No client authenticated");
        }

        return clientRepository.findByEmail(email)
                .orElseThrow(() -> new ClientNotFoundException("Client not found with email: " + email));
    }
}