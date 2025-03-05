package com.spring_boot.hexagonal.Payment.Domain.PortOut;

import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;

public interface NotificationServiceInterface {
    void sendEmailNotification(Payment payment, String message);
    void sendWhatsAppNotification(Payment payment, String message);
}
