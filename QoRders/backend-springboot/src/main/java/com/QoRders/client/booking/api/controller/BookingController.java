package com.QoRders.client.booking.api.controller;

import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.request.PaymentRequest;
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

    @PostMapping
    public ResponseEntity<?> createBooking(
            @RequestHeader("Authorization") String authorizationHeader,
            @RequestBody @Valid BookingRequest request) {
        try {
            // Extraer el token sin el prefijo "Bearer"
            String token = authorizationHeader.replace("Bearer ", "");

            // Llama al servicio para crear la reserva
            BookingResponse bookingResponse = bookingService.createBooking(request, token);

            // Construir la respuesta
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Reserva creada con éxito. Pendiente de confirmación.");
            response.put("data", bookingResponse);

            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (ResponseStatusException e) {
            return ResponseEntity.status(e.getStatusCode()).body(Map.of("error", e.getReason()));
        }
    }

    @PostMapping("/pay")
    public ResponseEntity<Map<String, String>> payBooking(
            @RequestBody @Valid PaymentRequest paymentRequest) {
        try {
            // Finalizar el pago usando el servicio
            String clientSecret = bookingService.finalizeBookingPayment(
                    paymentRequest.getBookingId(),
                    paymentRequest.getPaymentMethod()
            );

            Map<String, String> response = new HashMap<>();
            response.put("message", "Pago completado con éxito.");

            // Incluir el clientSecret en la respuesta solo si existe
            if (clientSecret != null) {
                response.put("clientSecret", clientSecret);
            }

            return ResponseEntity.ok(response);
        } catch (ResponseStatusException e) {
            return ResponseEntity.status(e.getStatusCode())
                    .body(Map.of("message", e.getReason()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("message", "Fallo al procesar el pago: " + e.getMessage()));
        }
    }
}