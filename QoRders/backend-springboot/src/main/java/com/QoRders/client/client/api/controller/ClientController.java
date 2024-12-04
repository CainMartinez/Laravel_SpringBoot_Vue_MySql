package com.QoRders.client.client.api.controller;

import com.QoRders.client.auth.api.security.authorization.CheckSecurity;
import com.QoRders.client.client.api.assembler.ClientAssembler;
import com.QoRders.client.client.api.request.ClientUpdateRequest;
import com.QoRders.client.client.api.response.ClientResponse;
import com.QoRders.client.client.domain.service.ClientService;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/client")
@RequiredArgsConstructor
public class ClientController {

    private final ClientService clientService;
    private final ClientAssembler clientAssembler;

    @GetMapping
    @CheckSecurity.Protected.canManage
    public ClientResponse getCurrentClient() {
        var client = clientService.getCurrentClient();
        return clientAssembler.toResponse(client);
    }

    @PutMapping
    @CheckSecurity.Protected.canManage
    public ClientResponse updateCurrentClient(@RequestBody ClientUpdateRequest clientUpdateDto) {
        var currentClient = clientService.getCurrentClient();
        clientAssembler.copyToEntity(clientUpdateDto, currentClient);
        return clientAssembler.toResponse(clientService.save(currentClient));
    }
}