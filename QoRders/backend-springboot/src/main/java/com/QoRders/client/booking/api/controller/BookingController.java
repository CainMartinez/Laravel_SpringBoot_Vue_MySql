package com.QoRders.client.booking.api.controller;

import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.response.BookingResponse;
import com.QoRders.client.booking.domain.service.BookingService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/booking")
@CrossOrigin(origins = "http://localhost:8085")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    /**
     * Endpoint para crear una nueva reserva.
     * 
     * @param request Los datos de la reserva.
     * @return La respuesta con los datos de la reserva creada.
     */
    @PostMapping
    public ResponseEntity<?> createBooking(@RequestBody @Valid BookingRequest request) {
        try {
            // Llama al servicio para crear la reserva
            BookingResponse bookingResponse = bookingService.createBooking(request);

            // Construye la respuesta
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Reserva creada con éxito. Pendiente de confirmación.");
            response.put("data", bookingResponse);

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (ResponseStatusException e) {
            // Devuelve el error lanzado por el servicio
            return ResponseEntity.status(e.getStatusCode()).body(Map.of("error", e.getReason()));
        }
    }
}