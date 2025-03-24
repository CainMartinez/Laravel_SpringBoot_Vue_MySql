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
                "<html lang='es'>\n" +
                "<head>\n" +
                "    <meta charset='UTF-8'>\n" +
                "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n" +
                "    <title>Confirmación de Pago - QoRders</title>\n" +
                "    <link href='https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Lora:wght@400;500;600&display=swap' rel='stylesheet'>\n" +
                "    <style>\n" +
                "        body {\n" +
                "            margin: 0;\n" +
                "            padding: 0;\n" +
                "            font-family: 'Lora', Georgia, serif;\n" +
                "            background-color: #f8f5ef;\n" +
                "            color: #5d4037;\n" +
                "            line-height: 1.6;\n" +
                "        }\n" +
                "        .email-container {\n" +
                "            max-width: 650px;\n" +
                "            margin: 20px auto;\n" +
                "            background-color: #ffffff;\n" +
                "            border-radius: 12px;\n" +
                "            overflow: hidden;\n" +
                "            box-shadow: 0 8px 30px rgba(0,0,0,0.12);\n" +
                "        }\n" +
                "        .header {\n" +
                "            background-color: #8d6e63;\n" +
                "            background-image: url('https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');\n" +
                "            background-size: cover;\n" +
                "            background-position: center;\n" +
                "            text-align: center;\n" +
                "            padding: 60px 20px;\n" +
                "            position: relative;\n" +
                "        }\n" +
                "        .header::before {\n" +
                "            content: '';\n" +
                "            position: absolute;\n" +
                "            top: 0;\n" +
                "            left: 0;\n" +
                "            right: 0;\n" +
                "            bottom: 0;\n" +
                "            background: rgba(0, 0, 0, 0.5);\n" +
                "            z-index: 1;\n" +
                "        }\n" +
                "        .header-content {\n" +
                "            position: relative;\n" +
                "            z-index: 2;\n" +
                "        }\n" +
                "        .logo {\n" +
                "            margin-bottom: 15px;\n" +
                "        }\n" +
                "        .header h1 {\n" +
                "            font-family: 'Playfair Display', serif;\n" +
                "            color: #ffffff;\n" +
                "            margin: 0;\n" +
                "            font-size: 36px;\n" +
                "            font-weight: 700;\n" +
                "            letter-spacing: 1px;\n" +
                "            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.3);\n" +
                "        }\n" +
                "        .tagline {\n" +
                "            color: #f0f0f0;\n" +
                "            font-style: italic;\n" +
                "            margin-top: 5px;\n" +
                "            font-size: 18px;\n" +
                "        }\n" +
                "        .content {\n" +
                "            padding: 40px 30px;\n" +
                "            background-color: #ffffff;\n" +
                "            background-image: url('data:image/svg+xml,%3Csvg width=\"100\" height=\"100\" viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"%3E%3Cpath d=\"M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5z\" fill=\"%238d6e63\" fill-opacity=\"0.03\" fill-rule=\"evenodd\"/%3E%3C/svg%3E');\n" +
                "        }\n" +
                "        .title {\n" +
                "            font-family: 'Playfair Display', serif;\n" +
                "            color: #5d4037;\n" +
                "            font-size: 24px;\n" +
                "            margin-bottom: 20px;\n" +
                "            text-align: center;\n" +
                "            font-weight: 600;\n" +
                "        }\n" +
                "        .name {\n" +
                "            font-weight: 600;\n" +
                "            color: #8d6e63;\n" +
                "        }\n" +
                "        .content p {\n" +
                "            margin: 15px 0;\n" +
                "            font-size: 16px;\n" +
                "            color: #5d4037;\n" +
                "        }\n" +
                "        .transaction-box {\n" +
                "            background-color: #f8f5ef;\n" +
                "            border-left: 4px solid #8d6e63;\n" +
                "            padding: 15px 20px;\n" +
                "            margin: 30px 0;\n" +
                "            border-radius: 5px;\n" +
                "        }\n" +
                "        .transaction-box p {\n" +
                "            margin: 5px 0;\n" +
                "        }\n" +
                "        .transaction-id {\n" +
                "            font-family: monospace;\n" +
                "            font-weight: 600;\n" +
                "            background-color: rgba(141, 110, 99, 0.1);\n" +
                "            padding: 3px 7px;\n" +
                "            border-radius: 4px;\n" +
                "        }\n" +
                "        .divider {\n" +
                "            height: 1px;\n" +
                "            background-color: #e0e0e0;\n" +
                "            margin: 30px 0;\n" +
                "        }\n" +
                "        .benefits {\n" +
                "            display: flex;\n" +
                "            justify-content: space-between;\n" +
                "            margin: 30px 0;\n" +
                "            flex-wrap: wrap;\n" +
                "        }\n" +
                "        .benefit-item {\n" +
                "            width: 30%;\n" +
                "            text-align: center;\n" +
                "            margin-bottom: 15px;\n" +
                "            padding: 15px 10px;\n" +
                "            background-color: rgba(141, 110, 99, 0.05);\n" +
                "            border-radius: 8px;\n" +
                "        }\n" +
                "        .benefit-item h3 {\n" +
                "            font-family: 'Playfair Display', serif;\n" +
                "            margin: 10px 0 5px;\n" +
                "            color: #8d6e63;\n" +
                "            font-size: 18px;\n" +
                "        }\n" +
                "        .benefit-item p {\n" +
                "            margin: 5px 0 0;\n" +
                "            font-size: 14px;\n" +
                "        }\n" +
                "        .icon {\n" +
                "            margin-bottom: 10px;\n" +
                "            font-size: 30px;\n" +
                "            color: #8d6e63;\n" +
                "        }\n" +
                "        .cta-button {\n" +
                "            display: block;\n" +
                "            text-align: center;\n" +
                "            background-color: #8d6e63;\n" +
                "            color: white;\n" +
                "            text-decoration: none;\n" +
                "            padding: 15px 30px;\n" +
                "            margin: 30px auto;\n" +
                "            border-radius: 30px;\n" +
                "            font-weight: 600;\n" +
                "            max-width: 220px;\n" +
                "            transition: background-color 0.3s;\n" +
                "        }\n" +
                "        .cta-button:hover {\n" +
                "            background-color: #6d4c41;\n" +
                "        }\n" +
                "        .footer {\n" +
                "            background-color: #5d4037;\n" +
                "            color: white;\n" +
                "            text-align: center;\n" +
                "            padding: 30px 15px;\n" +
                "        }\n" +
                "        .footer .logo {\n" +
                "            margin-bottom: 15px;\n" +
                "            font-family: 'Playfair Display', serif;\n" +
                "            font-size: 24px;\n" +
                "            font-weight: 700;\n" +
                "        }\n" +
                "        .footer-content {\n" +
                "            display: flex;\n" +
                "            justify-content: center;\n" +
                "            flex-wrap: wrap;\n" +
                "            margin-bottom: 20px;\n" +
                "        }\n" +
                "        .footer-column {\n" +
                "            margin: 0 20px;\n" +
                "            text-align: left;\n" +
                "        }\n" +
                "        .footer h4 {\n" +
                "            margin-top: 0;\n" +
                "            border-bottom: 1px solid rgba(255, 255, 255, 0.3);\n" +
                "            padding-bottom: 5px;\n" +
                "            font-size: 16px;\n" +
                "        }\n" +
                "        .footer p {\n" +
                "            margin: 5px 0;\n" +
                "            font-size: 14px;\n" +
                "        }\n" +
                "        .social-links {\n" +
                "            margin-top: 15px;\n" +
                "        }\n" +
                "        .social-icon {\n" +
                "            display: inline-block;\n" +
                "            width: 32px;\n" +
                "            height: 32px;\n" +
                "            line-height: 32px;\n" +
                "            border-radius: 50%;\n" +
                "            background-color: white;\n" +
                "            color: #5d4037;\n" +
                "            margin: 0 5px;\n" +
                "            text-align: center;\n" +
                "            text-decoration: none;\n" +
                "            font-weight: bold;\n" +
                "        }\n" +
                "        .copyright {\n" +
                "            margin-top: 20px;\n" +
                "            font-size: 12px;\n" +
                "            color: rgba(255, 255, 255, 0.7);\n" +
                "        }\n" +
                "        @media only screen and (max-width: 600px) {\n" +
                "            .header {\n" +
                "                padding: 40px 15px;\n" +
                "            }\n" +
                "            .header h1 {\n" +
                "                font-size: 28px;\n" +
                "            }\n" +
                "            .content {\n" +
                "                padding: 30px 20px;\n" +
                "            }\n" +
                "            .benefit-item {\n" +
                "                width: 100%;\n" +
                "                margin-bottom: 15px;\n" +
                "            }\n" +
                "            .footer-column {\n" +
                "                width: 100%;\n" +
                "                margin: 0 0 20px;\n" +
                "                text-align: center;\n" +
                "            }\n" +
                "        }\n" +
                "    </style>\n" +
                "</head>\n" +
                "<body>\n" +
                "    <div class='email-container'>\n" +
                "        <div class='header'>\n" +
                "            <div class='header-content'>\n" +
                "                <div class='logo'>🍽️</div>\n" +
                "                <h1>QoRders</h1>\n" +
                "                <div class='tagline'>Experiencias Gastronómicas Extraordinarias</div>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "        \n" +
                "        <div class='content'>\n" +
                "            <div class='title'>¡Pago Confirmado!</div>\n" +
                "            \n" +
                "            <p>Estimado/a <span class='name'>" + customerEmail + "</span>,</p>\n" +
                "            \n" +
                "            <p>¡Gracias por confiar en QoRders! Le confirmamos que su pago ha sido procesado correctamente.</p>\n" +
                "            \n" +
                "            <div class='transaction-box'>\n" +
                "                <p><strong>ID de Transacción:</strong> <span class='transaction-id'>" + paymentIntentId + "</span></p>\n" +
                "                <p><strong>Estado:</strong> Completado</p>\n" +
                "                <p><strong>Fecha:</strong> " + java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) + "</p>\n" +
                "            </div>\n" +
                "            \n" +
                "            <p>Esperamos que haya disfrutado de su experiencia gastronómica con nosotros. Con cada compra, no solo disfruta de nuestra exquisita cocina, sino que también contribuye a nuestras iniciativas benéficas.</p>\n" +
                "            \n" +
                "            <div class='divider'></div>\n" +
                "            \n" +
                "            <div class='benefits'>\n" +
                "                <div class='benefit-item'>\n" +
                "                    <div class='icon'>🌱</div>\n" +
                "                    <h3>Donaciones</h3>\n" +
                "                    <p>El 0.9% de su consumo se destina a iniciativas benéficas</p>\n" +
                "                </div>\n" +
                "                <div class='benefit-item'>\n" +
                "                    <div class='icon'>⭐</div>\n" +
                "                    <h3>Puntos de Fidelidad</h3>\n" +
                "                    <p>100 puntos por cada euro gastado</p>\n" +
                "                </div>\n" +
                "                <div class='benefit-item'>\n" +
                "                    <div class='icon'>🎫</div>\n" +
                "                    <h3>Cupones</h3>\n" +
                "                    <p>20% de descuento en su próxima visita</p>\n" +
                "                </div>\n" +
                "            </div>\n" +
                "            \n" +
                "            <p>¡Le esperamos pronto para otra experiencia gastronómica inolvidable!</p>\n" +
                "            \n" +
                "            <a href='http://localhost:3000/profile' class='cta-button'>Ver mi perfil</a>\n" +
                "        </div>\n" +
                "        \n" +
                "        <div class='footer'>\n" +
                "            <div class='logo'>QoRders</div>\n" +
                "            \n" +
                "            <div class='footer-content'>\n" +
                "                <div class='footer-column'>\n" +
                "                    <h4>Dirección</h4>\n" +
                "                    <p>Calle de la Buena Comida, 123</p>\n" +
                "                    <p>28001 Madrid, España</p>\n" +
                "                </div>\n" +
                "                \n" +
                "                <div class='footer-column'>\n" +
                "                    <h4>Contacto</h4>\n" +
                "                    <p>Teléfono: +34 912 345 678</p>\n" +
                "                    <p>Email: info@qorders.com</p>\n" +
                "                </div>\n" +
                "                \n" +
                "                <div class='footer-column'>\n" +
                "                    <h4>Horario</h4>\n" +
                "                    <p>Lun-Vie: 12:00 - 23:00</p>\n" +
                "                    <p>Sáb-Dom: 13:00 - 00:00</p>\n" +
                "                </div>\n" +
                "            </div>\n" +
                "            \n" +
                "            <div class='social-links'>\n" +
                "                <a href='#' class='social-icon'>f</a>\n" +
                "                <a href='#' class='social-icon'>t</a>\n" +
                "                <a href='#' class='social-icon'>i</a>\n" +
                "            </div>\n" +
                "            \n" +
                "            <div class='copyright'>\n" +
                "                &copy; " + java.time.LocalDate.now().getYear() + " QoRders. Todos los derechos reservados.\n" +
                "            </div>\n" +
                "        </div>\n" +
                "    </div>\n" +
                "</body>\n" +
                "</html>";
    
        // Enviar email y WhatsApp con la confirmación del pago
        notificationService.sendEmailNotification(customerEmail, "Confirmación de Pago - QoRders", message);
        notificationService.sendWhatsAppNotification(customerPhone, "¡Gracias por tu pedido en QoRders! Tu pago de " + paymentIntentId + " ha sido confirmado. Te esperamos pronto para disfrutar de más experiencias gastronómicas. ¡Buen provecho! 🍽️");
    }
}