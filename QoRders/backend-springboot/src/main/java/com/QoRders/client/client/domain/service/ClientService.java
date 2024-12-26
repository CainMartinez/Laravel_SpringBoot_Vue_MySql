package com.QoRders.client.client.domain.service;

import com.QoRders.client.booking.api.response.BookingWithTicketsResponse;
import com.QoRders.client.client.domain.entity.ClientEntity;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public interface ClientService {
    Map<String, Object> getProfile(String token);
    Map<String, Object> updateProfile(ClientEntity client, String token);
    ClientEntity registerClient(ClientEntity client);
    Optional<ClientEntity> findClientByEmail(String email);
    boolean validatePassword(String rawPassword, String hashedPassword);
    void deleteClientById(Integer id);
    ClientEntity getCurrentClient();
    List<BookingWithTicketsResponse> getBookingsWithTickets(String clientEmail);
}