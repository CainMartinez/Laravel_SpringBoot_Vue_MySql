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
public class WhatsAppNotificationAdapter implements NotificationServiceInterface {

    @Value("${notification.whatsapp.url}")
    private String whatsappUrl;

    private final RestTemplate restTemplate;

    public WhatsAppNotificationAdapter() {
        this.restTemplate = new RestTemplate();
    }

    @Override
    public void sendEmailNotification(Payment payment, String message) {
        // Este adaptador sólo envía mensajes de WhatsApp.
    }

    @Override
    public void sendWhatsAppNotification(Payment payment, String message) {
        Map<String, Object> requestBody = new HashMap<>();
        // En un escenario real, el teléfono se obtendría de la transacción o parámetros.
        requestBody.put("phone", "622095840");
        requestBody.put("otp", message); // Se reutiliza el campo para enviar el mensaje

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        restTemplate.postForEntity(whatsappUrl + "/payment/notification", entity, String.class);
    }
}
