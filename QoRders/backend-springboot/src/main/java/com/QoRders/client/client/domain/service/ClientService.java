package com.QoRders.client.client.domain.service;

import lombok.RequiredArgsConstructor;

import java.util.Optional;

import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.QoRders.client.auth.api.security.utils.AuthUtils;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;
import com.QoRders.client.client.domain.exceptions.ClientNotAuthenticatedException;
import com.QoRders.client.client.domain.exceptions.ClientNotFoundException;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthUtils authUtils;

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
     * Saves or updates a client entity.
     *
     * @param client The client entity to save or update.
     * @return The saved client entity.
     */
    @Transactional
    public ClientEntity save(ClientEntity client) {
        return clientRepository.save(client);
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