package com.QoRders.client.client.api.controller;

import com.QoRders.client.auth.api.security.authorization.CheckSecurity;
import com.QoRders.client.client.api.assembler.ClientAssembler;
import com.QoRders.client.client.api.request.ClientUpdateRequest;
import com.QoRders.client.client.api.response.ClientResponse;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.service.ClientService;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/client")
@CrossOrigin(origins = "http://localhost:8085")
@RequiredArgsConstructor
public class ClientController {

    private final ClientService clientService;
    private final ClientAssembler clientAssembler;

    /**
     * Get the currently authenticated client's profile.
     * 
     * @param authorization The Bearer token from the Authorization header.
     * @return The authenticated client's details.
     */
    @GetMapping
    @CheckSecurity.Protected.canManage
    public ClientResponse getCurrentClient(@RequestHeader("Authorization") String authorization) {
        try {
            // Extract email from token and retrieve the client profile
            String token = authorization.replace("Bearer ", "");
            String email = clientService.getCurrentClient().getEmail();

            ClientEntity client = clientService.getProfile(email, token);
            return clientAssembler.toResponse(client);
        } catch (IllegalArgumentException e) {
            // Handle the case where no client is authenticated or found
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "No client authenticated");
        }
    }

    /**
     * Update the currently authenticated client's details.
     * 
     * @param authorization   The Bearer token from the Authorization header.
     * @param clientUpdateDto The update request containing client details to be updated.
     * @return The updated client details.
     */
    @PutMapping
    @CheckSecurity.Protected.canManage
    public ClientResponse updateCurrentClient(
            @RequestHeader("Authorization") String authorization,
            @RequestBody ClientUpdateRequest clientUpdateDto) {
        try {
            // Extract email from token and retrieve the current client
            String token = authorization.replace("Bearer ", "");
            ClientEntity currentClient = clientService.getCurrentClient();

            // Update the current client's details
            clientAssembler.copyToEntity(clientUpdateDto, currentClient);
            ClientEntity updatedClient = clientService.updateProfile(currentClient, token);

            return clientAssembler.toResponse(updatedClient);
        } catch (IllegalArgumentException e) {
            // Handle the case where no client is authenticated or found
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "No client authenticated");
        }
    }
}