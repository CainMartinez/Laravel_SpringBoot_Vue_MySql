package com.spring_boot.hexagonal.Payment.Infrastructure.Messaging;

import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;
import com.spring_boot.hexagonal.Payment.Domain.PortOut.NotificationServiceInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

@Component
@Primary
public class CompositeNotificationService implements NotificationServiceInterface {

    private final EmailNotificationAdapter emailAdapter;
    private final WhatsAppNotificationAdapter whatsappAdapter;

    @Autowired
    public CompositeNotificationService(EmailNotificationAdapter emailAdapter,
                                        WhatsAppNotificationAdapter whatsappAdapter) {
        this.emailAdapter = emailAdapter;
        this.whatsappAdapter = whatsappAdapter;
    }

    @Override
    public void sendEmailNotification(Payment payment, String message) {
        emailAdapter.sendEmailNotification(payment, message);
    }

    @Override
    public void sendWhatsAppNotification(Payment payment, String message) {
        whatsappAdapter.sendWhatsAppNotification(payment, message);
    }
}
