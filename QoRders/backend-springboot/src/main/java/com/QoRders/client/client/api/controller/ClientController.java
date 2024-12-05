package com.QoRders.client.client.api.controller;

import com.QoRders.client.auth.api.security.authorization.CheckSecurity;
import com.QoRders.client.client.api.assembler.ClientAssembler;
import com.QoRders.client.client.api.request.ClientUpdateRequest;
import com.QoRders.client.client.api.response.ClientResponse;
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
     * Get the currently authenticated client.
     * 
     * @return The authenticated client's details.
     */
    @GetMapping
    @CheckSecurity.Protected.canManage
    public ClientResponse getCurrentClient() {
        try {
            var client = clientService.getCurrentClient();
            return clientAssembler.toResponse(client);
        } catch (IllegalArgumentException e) {
            // Handle the case where no client is authenticated or found
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "No client authenticated");
        }
    }

    /**
     * Update the currently authenticated client's details.
     * 
     * @param clientUpdateDto The update request containing client details to be updated.
     * @return The updated client details.
     */
    @PutMapping
    @CheckSecurity.Protected.canManage
    public ClientResponse updateCurrentClient(@RequestBody ClientUpdateRequest clientUpdateDto) {
        try {
            var currentClient = clientService.getCurrentClient();
            clientAssembler.copyToEntity(clientUpdateDto, currentClient);
            return clientAssembler.toResponse(clientService.save(currentClient));
        } catch (IllegalArgumentException e) {
            // Handle the case where no client is authenticated or found
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "No client authenticated");
        }
    }
}