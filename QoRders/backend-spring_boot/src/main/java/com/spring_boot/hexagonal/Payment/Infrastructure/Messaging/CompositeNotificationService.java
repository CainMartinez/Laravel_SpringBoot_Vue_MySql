package com.spring_boot.hexagonal.Payment.Infrastructure.Messaging;

import com.spring_boot.hexagonal.Payment.Domain.PortOut.NotificationServiceInterface;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import java.util.HashMap;
import java.util.Map;

@Component("compositeNotificationService")
public class CompositeNotificationService implements NotificationServiceInterface {

    private final RestTemplate restTemplate = new RestTemplate();

    private static final String EMAIL_SERVICE_URL = "http://resend_container:3000/api/feedback/send";
    private static final String WHATSAPP_SERVICE_URL = "http://ultramsg_container:3001/api/payment/notification";

    @Override
    public void sendEmailNotification(String customerEmail, String subject, String message) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("to", customerEmail);
        requestBody.put("subject", subject);
        requestBody.put("html", message);

        try {
            restTemplate.postForEntity(EMAIL_SERVICE_URL, requestBody, String.class);
            System.out.println("✅ Email enviado con éxito a " + customerEmail);
        } catch (Exception e) {
            System.err.println("❌ Error enviando email a " + customerEmail + ": " + e.getMessage());
        }
    }

    @Override
    public void sendWhatsAppNotification(String customerPhone, String message) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("phone", customerPhone);
        requestBody.put("otp", message);

        try {
            restTemplate.postForEntity(WHATSAPP_SERVICE_URL, requestBody, String.class);
            System.out.println("✅ WhatsApp enviado con éxito a " + customerPhone);
        } catch (Exception e) {
            System.err.println("❌ Error enviando WhatsApp a " + customerPhone + ": " + e.getMessage());
        }
    }
}