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
public class ClientServiceImpl implements ClientService {

    private final ClientRepository clientRepository;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthUtils authUtils;
    private final RedisService redisService;
    private final JwtProvider jwtProvider;

    @Override
    public ClientEntity getProfile(String email, String token) {
        String redisKey = "client:" + email;
        ClientEntity client = (ClientEntity) redisService.get(redisKey);
        if (client != null) {
            return client;
        }

        client = clientRepository.findByEmail(email)
                .orElseThrow(() -> new ClientNotFoundException("Client not found with email: " + email));
        long ttlInSeconds = jwtProvider.getAccessTokenExpirationInSeconds();
        redisService.save(redisKey, client, ttlInSeconds);

        return client;
    }

    @Override
    @Transactional
    public ClientEntity updateProfile(ClientEntity client, String token) {
        ClientEntity updatedClient = clientRepository.save(client);
        String redisKey = "client:" + client.getEmail();
        long ttlInSeconds = jwtProvider.getAccessTokenExpirationInSeconds();
        redisService.save(redisKey, updatedClient, ttlInSeconds);

        return updatedClient;
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