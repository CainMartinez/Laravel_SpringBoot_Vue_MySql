package com.QoRders.client.client.domain.service;

import lombok.RequiredArgsConstructor;

import java.util.Optional;

import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.QoRders.client.auth.api.security.utils.AuthUtils;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthUtils authUtils;

    public ClientEntity registerClient(ClientEntity client) {
        String hashedPassword = passwordEncoder.encode(client.getPassword());
        client.setPassword(hashedPassword);
        return clientRepository.save(client);
    }

    public Optional<ClientEntity> findClientByEmail(String email) {
        return clientRepository.findByEmail(email);
    }

    public boolean validatePassword(String rawPassword, String hashedPassword) {
        return passwordEncoder.matches(rawPassword, hashedPassword);
    }

    @Transactional
    public ClientEntity save(ClientEntity client) {
        return clientRepository.save(client); // Guardar o actualizar el cliente
    }

    @Transactional
    public void deleteClientById(Integer id) {
        clientRepository.deleteById(id);
    }

    public ClientEntity getCurrentClient() {
        String email = authUtils.getCurrentClientEmail();
        if ("anonymousUser".equals(email)) {
            throw new IllegalArgumentException("No client authenticated");
        }
    
        return clientRepository.findByEmail(email)
            .orElseThrow(() -> new IllegalArgumentException("Client not found with email: " + email));
    }
}