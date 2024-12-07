package com.QoRders.client.client.domain.service;

import com.QoRders.client.client.domain.entity.ClientEntity;

import java.util.Optional;

public interface ClientService {
    ClientEntity getProfile(String email, String token);
    ClientEntity updateProfile(ClientEntity client, String token);
    ClientEntity registerClient(ClientEntity client);
    Optional<ClientEntity> findClientByEmail(String email);
    boolean validatePassword(String rawPassword, String hashedPassword);
    void deleteClientById(Integer id);
    ClientEntity getCurrentClient();
}