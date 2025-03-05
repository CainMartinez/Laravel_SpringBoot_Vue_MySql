package com.spring_boot.hexagonal.Payment.Infrastructure.AdapterOut;

import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;
import com.spring_boot.hexagonal.Payment.Domain.PortOut.PaymentProcessorInterface;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component("paypalPaymentAdapter")
public class PayPalPaymentAdapter implements PaymentProcessorInterface {

    @Value("${paypal.client.id}")
    private String clientId;

    @Value("${paypal.client.secret}")
    private String clientSecret;

    @Value("${paypal.mode}")
    private String mode;

    private final WebClient webClient;

    public PayPalPaymentAdapter() {
        this.webClient = WebClient.builder().build();
    }

    /**
     * Devuelve la URL base de la API de PayPal en función del modo.
     */
    private String getBaseUrl() {
        return "sandbox".equalsIgnoreCase(mode)
            ? "https://api-m.sandbox.paypal.com"
            : "https://api-m.paypal.com";
    }

    /**
     * Obtiene el token de acceso (OAuth2) para autenticarse con la API de PayPal.
     */
    private String getAccessToken() {
        // Preparar la autenticación básica
        String auth = clientId + ":" + clientSecret;
        String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes(StandardCharsets.UTF_8));

        @SuppressWarnings("unchecked")
        Map<String, Object> tokenResponse = webClient.post()
            .uri(getBaseUrl() + "/v1/oauth2/token")
            .header(HttpHeaders.AUTHORIZATION, "Basic " + encodedAuth)
            .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_FORM_URLENCODED_VALUE)
            .bodyValue("grant_type=client_credentials")
            .retrieve()
            .bodyToMono(Map.class)
            .block();

        return tokenResponse != null ? (String) tokenResponse.get("access_token") : null;
    }

    @Override
    public Payment processPayment(Double amount, String transactionData) {
        // Construir la orden de pago según la especificación de PayPal
        Map<String, Object> orderRequest = new HashMap<>();
        orderRequest.put("intent", "CAPTURE");

        // Configurar la unidad de compra (purchase_unit)
        Map<String, Object> purchaseUnit = new HashMap<>();
        purchaseUnit.put("reference_id", transactionData);
        // Formatear el importe como String con dos decimales
        Map<String, Object> amountDetails = new HashMap<>();
        amountDetails.put("currency_code", "USD");
        amountDetails.put("value", String.format("%.2f", amount));
        purchaseUnit.put("amount", amountDetails);

        orderRequest.put("purchase_units", List.of(purchaseUnit));

        // Obtener el token de acceso
        String accessToken = getAccessToken();
        if (accessToken == null) {
            throw new RuntimeException("No se pudo obtener el token de acceso de PayPal");
        }

        // Enviar la solicitud a PayPal para crear la orden
        @SuppressWarnings("unchecked")
        Map<String, Object> response = webClient.post()
            .uri(getBaseUrl() + "/v2/checkout/orders")
            .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + accessToken)
            .bodyValue(orderRequest)
            .retrieve()
            .bodyToMono(Map.class)
            .block();

        // Crear la entidad Payment a partir de la respuesta (este es un ejemplo; en producción se debe mapear según la respuesta real)
        Payment payment = new Payment();
        payment.setTransactionId(response != null ? (String) response.get("id") : "N/A");
        payment.setAmount(amount);
        payment.setStatus("PROCESSED");
        payment.setDate(LocalDateTime.now());
        payment.setMethod("paypal");
        return payment;
    }

    @Override
    public Payment processRefund(String transactionId, Double refundAmount) {
        // Implementa la lógica de devolución llamando a la API de PayPal.
        // Para efectos de este ejemplo, se devuelve un objeto simulado.
        Payment refund = new Payment();
        refund.setTransactionId(transactionId);
        refund.setAmount(refundAmount);
        refund.setStatus("REFUNDED");
        refund.setDate(LocalDateTime.now());
        refund.setMethod("paypal");
        return refund;
    }
}
