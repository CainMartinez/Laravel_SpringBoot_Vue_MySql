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

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthUtils authUtils;
    private final RedisService redisService;
    private final JwtProvider jwtProvider;

    /**
     * Retrieves the profile of a client by their email.
     * First checks Redis, then falls back to the database if necessary.
     *
     * @param email The email of the client.
     * @param token The access token for TTL management.
     * @return The client entity.
     */
    public ClientEntity getProfile(String email, String token) {
        // Key in Redis
        String redisKey = "client:" + email;

        // Try to get the profile from Redis
        ClientEntity client = (ClientEntity) redisService.get(redisKey);
        if (client != null) {
            return client;
        }

        // If not in Redis, fetch from the database
        client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new ClientNotFoundException("Client not found with email: " + email));

        // Save to Redis with TTL based on the token expiration
        long ttlInSeconds = jwtProvider.getAccessTokenExpirationInSeconds();
        redisService.save(redisKey, client, ttlInSeconds);

        return client;
    }

    /**
     * Updates a client's profile and syncs with Redis.
     *
     * @param client The updated client entity.
     * @param token  The access token for TTL management.
     * @return The updated client entity.
     */
    @Transactional
    public ClientEntity updateProfile(ClientEntity client, String token) {
        // Save to the database
        ClientEntity updatedClient = clientRepository.save(client);

        // Update Redis with the new profile data
        String redisKey = "client:" + client.getEmail();
        long ttlInSeconds = jwtProvider.getAccessTokenExpirationInSeconds();
        redisService.save(redisKey, updatedClient, ttlInSeconds);

        return updatedClient;
    }

    /**
     * Registers a new client by hashing their password and saving them in the database.
     *
     * @param client The client to be registered.
     * @return The saved client entity.
     */
    public ClientEntity registerClient(ClientEntity client) {
        String hashedPassword = passwordEncoder.encode(client.getPassword());
        client.setPassword(hashedPassword);
        return clientRepository.save(client);
    }

    /**
     * Finds a client by their email address.
     *
     * @param email The email to search for.
     * @return An Optional containing the client if found, or empty if not.
     */
    public Optional<ClientEntity> findClientByEmail(String email) {
        return clientRepository.findByEmail(email);
    }

    /**
     * Validates if a raw password matches the hashed password.
     *
     * @param rawPassword    The plain-text password.
     * @param hashedPassword The hashed password.
     * @return True if the passwords match, false otherwise.
     */
    public boolean validatePassword(String rawPassword, String hashedPassword) {
        return passwordEncoder.matches(rawPassword, hashedPassword);
    }

    /**
     * Deletes a client by their ID.
     *
     * @param id The ID of the client to delete.
     */
    @Transactional
    public void deleteClientById(Integer id) {
        clientRepository.deleteById(id);
    }

    /**
     * Gets the currently authenticated client.
     *
     * @return The authenticated client entity.
     * @throws ClientNotAuthenticatedException If no client is authenticated.
     * @throws ClientNotFoundException         If the client is not found.
     */
    public ClientEntity getCurrentClient() {
        String email = authUtils.getCurrentClientEmail();

        if ("anonymousUser".equals(email)) {
            throw new ClientNotAuthenticatedException("No client authenticated");
        }

        return clientRepository.findByEmail(email)
                .orElseThrow(() -> new ClientNotFoundException("Client not found with email: " + email));
    }
}