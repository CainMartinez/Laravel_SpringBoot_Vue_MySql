package com.QoRders.client.order.api.controller;

import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.order.api.assembler.OrderAssembler;
import com.QoRders.client.order.api.request.OrderProductRequest;
import com.QoRders.client.order.api.request.OrderRequest;
import com.QoRders.client.order.api.request.PaymentRequest;
import com.QoRders.client.order.api.response.OrderResponse;
import com.QoRders.client.order.domain.entity.OrderEntity;
import com.QoRders.client.order.domain.entity.OrderProductsEntity;
import com.QoRders.client.order.domain.service.OrderService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;
    private final OrderAssembler orderAssembler;
    private final JwtProvider jwtProvider;

    /**
     * Crea una nueva orden asociada a una reserva.
     *
     * @param bookingId ID de la reserva asociada.
     * @return La orden creada.
     */
    @PostMapping
    public ResponseEntity<OrderResponse> createOrder(@RequestBody @Valid OrderRequest orderRequest) {
        OrderEntity order = orderService.createOrder(orderRequest.getBookingId(), orderRequest.getNotes());
        OrderResponse response = orderAssembler.toResponse(order);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Añade un producto a una orden existente.
     *
     * @param orderId ID de la orden.
     * @param product Producto a añadir a la orden.
     * @return La orden actualizada.
     */
    @PostMapping("/products")
    public ResponseEntity<Map<String, String>> addProductsToOrder(
            @RequestBody @Valid OrderProductRequest request,
            @RequestHeader("Authorization") String authorization) {
        try {
            // Extraer el email desde el token
            String email = jwtProvider.parseAccessToken(authorization.replace("Bearer ", ""));

            // Añadir cada producto al pedido
            for (OrderProductRequest.ProductQuantityRequest productRequest : request.getProducts()) {
                OrderProductsEntity orderProduct = new OrderProductsEntity();
                orderProduct.setQuantity(productRequest.getQuantity());

                orderService.addProductToOrder(
                    request.getOrderId(),
                    orderProduct,
                    productRequest.getProductId(),
                    email
                );
            }

            // Respuesta simplificada al cliente
            Map<String, String> response = Map.of(
                "message", "Comanda realizada con éxito, en breve te servirán nuestros camareros."
            );
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(
                Map.of("message", "Error al realizar la comanda.")
            );
        }
    }

    @PostMapping("/{orderId}/pay")
    public ResponseEntity<Map<String, String>> payOrder(
            @PathVariable Integer orderId,
            @RequestBody @Valid PaymentRequest paymentRequest) {
        try {
            // Finalizar el pedido usando el servicio
            String clientSecret = orderService.finalizeOrder(orderId, paymentRequest.getPaymentMethod());

            Map<String, String> response = new HashMap<>();
            response.put("message", "Order payment processed successfully");

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
                    .body(Map.of("message", "Error processing payment: " + e.getMessage()));
        }
    }
}