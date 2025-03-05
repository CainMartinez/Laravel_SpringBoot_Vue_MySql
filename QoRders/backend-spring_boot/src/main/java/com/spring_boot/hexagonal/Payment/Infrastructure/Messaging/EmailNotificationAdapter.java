package com.spring_boot.hexagonal.Payment.Infrastructure.Messaging;

import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;
import com.spring_boot.hexagonal.Payment.Domain.PortOut.NotificationServiceInterface;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Component
public class EmailNotificationAdapter implements NotificationServiceInterface {

    @Value("${notification.email.url}")
    private String emailUrl;

    private final RestTemplate restTemplate;

    public EmailNotificationAdapter() {
        this.restTemplate = new RestTemplate();
    }

    @Override
    public void sendEmailNotification(Payment payment, String message) {
        Map<String, Object> requestBody = new HashMap<>();
        // En un escenario real, se obtendrían los datos del destinatario desde la transacción o parámetros.
        requestBody.put("to", "cainmartinez3@gmail.com");
        requestBody.put("subject", "Notificación de Pago");
        requestBody.put("html", message);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        restTemplate.postForEntity(emailUrl + "/api/feedback/send", entity, String.class);
    }

    @Override
    public void sendWhatsAppNotification(Payment payment, String message) {
        // Este adaptador sólo envía correos.
    }
}
