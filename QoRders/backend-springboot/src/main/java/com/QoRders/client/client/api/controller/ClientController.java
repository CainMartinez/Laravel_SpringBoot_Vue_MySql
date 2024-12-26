package com.QoRders.client.client.api.controller;

import com.QoRders.client.auth.api.security.authorization.CheckSecurity;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.booking.api.response.BookingWithTicketsResponse;
import com.QoRders.client.client.api.assembler.ClientAssembler;
import com.QoRders.client.client.api.request.ClientUpdateRequest;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.service.ClientService;

import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/client")
@CrossOrigin(origins = "http://localhost:8085")
@RequiredArgsConstructor
public class ClientController {

    private final ClientService clientService;
    private final ClientAssembler clientAssembler;
    protected final JwtProvider jwtProvider;

    /**
     * Get the currently authenticated client's profile.
     * 
     * @param authorization The Bearer token from the Authorization header.
     * @return The authenticated client's details.
     */
    @GetMapping
    @CheckSecurity.Protected.canManage
    public ResponseEntity<Map<String, Object>> getCurrentClient(@RequestHeader("Authorization") String authorization) {
        String token = authorization.replace("Bearer ", "");
        Map<String, Object> redisData = clientService.getProfile(token);
        return ResponseEntity.ok(clientAssembler.toResponse(redisData));
    }

    @GetMapping("/bookings")
    @CheckSecurity.Protected.canManage
    public ResponseEntity<List<BookingWithTicketsResponse>> getBookingsWithTickets(
        @RequestHeader("Authorization") String authorization
    ) {
        String clientEmail = jwtProvider.parseAccessToken(authorization.replace("Bearer ", ""));
        List<BookingWithTicketsResponse> response = clientService.getBookingsWithTickets(clientEmail);
        return ResponseEntity.ok(response);
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
    public ResponseEntity<Map<String, Object>> updateCurrentClient(
            @RequestHeader("Authorization") String authorization,
            @RequestBody ClientUpdateRequest clientUpdateDto) {
        try {
            // Extraer el token del encabezado
            String token = authorization.replace("Bearer ", "");

            // Obtener el cliente actual
            ClientEntity currentClient = clientService.getCurrentClient();

            // Actualizar los detalles del cliente
            clientAssembler.copyToEntity(clientUpdateDto, currentClient);
            Map<String, Object> updatedData = clientService.updateProfile(currentClient, token);

            // Construir la respuesta en el formato deseado
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Client updated successfully");
            response.put("client", updatedData.get("client"));
            response.put("token", updatedData.get("token"));

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            // Manejar el caso donde no haya cliente autenticado o encontrado
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "No client authenticated");
        }
    }
}