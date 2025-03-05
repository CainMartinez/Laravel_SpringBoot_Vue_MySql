package com.spring_boot.hexagonal.Payment.Application.UseCase.PortIn;

import com.spring_boot.hexagonal.Payment.Application.UseCase.Command.ProcessPaymentCommand;
import com.spring_boot.hexagonal.Payment.Application.UseCase.Command.ProcessRefundCommand;
import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;
import com.spring_boot.hexagonal.Payment.Domain.PortOut.NotificationServiceInterface;
import com.spring_boot.hexagonal.Payment.Infrastructure.AdapterOut.PayPalPaymentAdapter;
import com.spring_boot.hexagonal.Payment.Infrastructure.AdapterOut.StripePaymentAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class PaymentUseCase {

    private final StripePaymentAdapter stripePaymentAdapter;
    private final PayPalPaymentAdapter paypalPaymentAdapter;
    private final NotificationServiceInterface notificationService;

    @Autowired
    public PaymentUseCase(StripePaymentAdapter stripePaymentAdapter,
            PayPalPaymentAdapter paypalPaymentAdapter,
            @Qualifier("compositeNotificationService") NotificationServiceInterface notificationService) {
        this.stripePaymentAdapter = stripePaymentAdapter;
        this.paypalPaymentAdapter = paypalPaymentAdapter;
        this.notificationService = notificationService;
    }

    public Payment processPayment(ProcessPaymentCommand command) {
        Payment payment;
        if ("stripe".equalsIgnoreCase(command.getMethod())) {
            payment = stripePaymentAdapter.processPayment(command.getAmount(), command.getTransactionData());
        } else if ("paypal".equalsIgnoreCase(command.getMethod())) {
            payment = paypalPaymentAdapter.processPayment(command.getAmount(), command.getTransactionData());
        } else {
            throw new IllegalArgumentException("Método de pago no soportado: " + command.getMethod());
        }
        payment.setMethod(command.getMethod());
        payment.setDate(LocalDateTime.now());

        String message = "<!DOCTYPE html>\n" + //
                        "        <html lang='en'>\n" + //
                        "            <head>\n" + //
                        "                <meta charset='UTF-8'>\n" + //
                        "                <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n" + //
                        "                <title>Restaurante QoRders</title>\n" + //
                        "                <style>body{margin:0;padding:0;font-family:Arial,sans-serif;background-color:#f9f9f9;color:#333}.email-container{width:100%;max-width:600px;margin:20px auto;background-color:#ffffff;border:1px solid #ddd;border-radius:8px;overflow:hidden;box-shadow:0 4px 8px rgba(0,0,0,0.1)}.header{background-color:#3b5998;color:white;text-align:center;padding:20px 10px}.header h1{margin:0;font-size:24px}.content{padding:20px}.content p{line-height:1.6;font-size:16px;margin:15px 0}.content a{color:#3b5998;text-decoration:none;font-weight:bold}.footer{background-color:#f1f1f1;text-align:center;padding:15px 10px;font-size:14px;color:#666}.footer p{margin:5px 0}</style>\n" + //
                        "            </head>\n" + //
                        "            <body>\n" + //
                        "                <div class='email-container'>\n" + //
                        "                    <div class='header'>\n" + //
                        "                        <h1>Restaurante QoRders</h1>\n" + //
                        "                    </div>\n" + //
                        "                    <div class='content'>\n" + //
                        "                        <p>Espero que su estancia haya sido satisfactoria.</p>\n" + //
                        "                        <p>Pago procesado para " + command.getCustomerName() + " .</p>\n" + //
                        "                        <p>Su transacción (" + payment.getTransactionId() + ") se ha completado con éxito.</p>\n" + //
                        "                    </div>\n" + //
                        "                    <div class='footer'>\n" + //
                        "                        <p>Restaurante QoRders</p>\n" + //
                        "                        <p>Dirección: Calle de la Buena Comida, 123, Madrid, España</p>\n" + //
                        "                        <p>Teléfono: +34 912 345 678</p><p>Email: contacto@qorders.com</p>\n" + //
                        "                    </div>\n" + //
                        "                </div>\n" + //
                        "            </body>\n" + //
                        "        </html>";

        notificationService.sendEmailNotification(payment, message);
        notificationService.sendWhatsAppNotification(payment, message);
        return payment;
    }

    public Payment processRefund(ProcessRefundCommand command) {
        // Para simplificar, usamos el adaptador Stripe para el reembolso.
        Payment refund = stripePaymentAdapter.processRefund(command.getTransactionId(), command.getRefundAmount());
        refund.setDate(LocalDateTime.now());

        String message = "Se ha procesado una devolución para la transacción " +
                command.getTransactionId() + ". Monto: " + command.getRefundAmount();

        notificationService.sendEmailNotification(refund, message);
        notificationService.sendWhatsAppNotification(refund, message);
        return refund;
    }
}
