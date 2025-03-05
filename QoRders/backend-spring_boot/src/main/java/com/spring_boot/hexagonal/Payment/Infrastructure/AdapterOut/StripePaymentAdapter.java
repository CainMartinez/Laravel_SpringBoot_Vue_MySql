package com.spring_boot.hexagonal.Payment.Infrastructure.AdapterOut;

import com.spring_boot.hexagonal.Payment.Application.DTO.Response.StripeResponseDTO;
import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;
import com.spring_boot.hexagonal.Payment.Domain.PortOut.PaymentProcessorInterface;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Component("stripePaymentAdapter")
public class StripePaymentAdapter implements PaymentProcessorInterface {

    @Value("${payment.adapter.stripe.url}")
    private String stripeUrl;

    private final RestTemplate restTemplate;

    public StripePaymentAdapter() {
        this.restTemplate = new RestTemplate();
    }
    
    @Override
    public Payment processPayment(Double amount, String transactionData) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("orderId", transactionData);
        requestBody.put("totalAmount", amount);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        // Llamada a Express y mapeo de la respuesta a StripeResponseDTO
        ResponseEntity<StripeResponseDTO> response = restTemplate.postForEntity(
                stripeUrl + "/api/payment",
                entity,
                StripeResponseDTO.class
        );

        StripeResponseDTO stripeResponse = response.getBody();

        Payment payment = new Payment();
        if (stripeResponse != null) {
            // Usamos el clientSecret como identificador (o token) de la transacción
            payment.setTransactionId(stripeResponse.getClientSecret());
        } else {
            // En caso de error, podrías manejarlo de otra forma
            payment.setTransactionId("N/A");
        }
        payment.setAmount(amount);
        payment.setStatus("PENDING_CONFIRMATION");
        payment.setDate(LocalDateTime.now());
        payment.setMethod("stripe");
        return payment;
    }


    @Override
    public Payment processRefund(String transactionId, Double refundAmount) {
        Payment refund = new Payment();
        refund.setTransactionId(transactionId);
        refund.setAmount(refundAmount);
        refund.setStatus("REFUNDED");
        refund.setDate(LocalDateTime.now());
        return refund;
    }
}
