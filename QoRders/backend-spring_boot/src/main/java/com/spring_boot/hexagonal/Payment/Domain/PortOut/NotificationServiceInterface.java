package com.spring_boot.hexagonal.Payment.Domain.PortOut;

public interface NotificationServiceInterface {
    void sendEmailNotification(String customerEmail, String subject, String message);
    void sendWhatsAppNotification(String customerPhone, String message);
}