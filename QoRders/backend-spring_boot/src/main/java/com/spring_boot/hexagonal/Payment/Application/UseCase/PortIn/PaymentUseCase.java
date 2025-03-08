package com.spring_boot.hexagonal.Payment.Application.UseCase.PortIn;

import com.spring_boot.hexagonal.Payment.Domain.PortOut.NotificationServiceInterface;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class PaymentUseCase {

    private final NotificationServiceInterface notificationService;

    @Autowired
    public PaymentUseCase(@Qualifier("compositeNotificationService") NotificationServiceInterface notificationService) {
        this.notificationService = notificationService;
    }

    /**
     * Método para confirmar un pago y enviar notificaciones.
     */
    public void confirmPayment(String paymentIntentId, String customerEmail, String customerPhone) {
        String message = "<!DOCTYPE html>\n" +
                "<html lang='en'>\n" +
                "    <head>\n" +
                "        <meta charset='UTF-8'>\n" +
                "        <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n" +
                "        <title>Restaurante QoRders</title>\n" +
                "        <style>body{margin:0;padding:0;font-family:Arial,sans-serif;background-color:#f9f9f9;color:#333}.email-container{width:100%;max-width:600px;margin:20px auto;background-color:#ffffff;border:1px solid #ddd;border-radius:8px;overflow:hidden;box-shadow:0 4px 8px rgba(0,0,0,0.1)}.header{background-color:#3b5998;color:white;text-align:center;padding:20px 10px}.header h1{margin:0;font-size:24px}.content{padding:20px}.content p{line-height:1.6;font-size:16px;margin:15px 0}.footer{background-color:#f1f1f1;text-align:center;padding:15px 10px;font-size:14px;color:#666}.footer p{margin:5px 0}</style>\n" +
                "    </head>\n" +
                "    <body>\n" +
                "        <div class='email-container'>\n" +
                "            <div class='header'>\n" +
                "                <h1>Restaurante QoRders</h1>\n" +
                "            </div>\n" +
                "            <div class='content'>\n" +
                "                <p>Gracias por confiar en QoRders "+customerEmail+" tu pago ha sido procesado correctamente.</p>\n" +
                "                <p>Tu transacción (" + paymentIntentId + ") se ha completado con éxito.</p>\n" +
                "                <p>Esperamos verte pronto en nuestro establecimiento.</p>\n" +
                "            </div>\n" +
                "            <div class='footer'>\n" +
                "                <p>Restaurante QoRders</p>\n" +
                "                <p>Dirección: Calle de la Buena Comida, 123, Madrid, España</p>\n" +
                "                <p>Teléfono: +34 912 345 678</p>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "    </body>\n" +
                "</html>";

        // Enviar email y WhatsApp con la confirmación del pago
        notificationService.sendEmailNotification(customerEmail, "Confirmación de Pago", message);
        notificationService.sendWhatsAppNotification(customerPhone, "Tu pago ha sido procesado correctamente. Gracias por tu compra.");
    }
}