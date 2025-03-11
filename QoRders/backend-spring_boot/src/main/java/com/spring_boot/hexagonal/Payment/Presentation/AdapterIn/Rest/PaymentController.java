package com.spring_boot.hexagonal.Payment.Presentation.AdapterIn.Rest;

import com.spring_boot.hexagonal.Payment.Application.UseCase.PortIn.PaymentUseCase;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/payment")
@CrossOrigin(origins = "*")
public class PaymentController {

    private final PaymentUseCase paymentUseCase;

    @Autowired
    public PaymentController(PaymentUseCase paymentUseCase) {
        this.paymentUseCase = paymentUseCase;
    }

    /**
     * Nuevo endpoint para confirmar el pago después de que Vue haya completado la transacción en Stripe.
     */
    @PostMapping("/confirm")
    public ResponseEntity<String> confirmPayment(@RequestBody Map<String, Object> paymentData) {
        String paymentIntentId = (String) paymentData.get("paymentIntentId");
        String customerEmail = (String) paymentData.get("customerEmail");
        String customerPhone = (String) paymentData.get("customerPhone");

        if (paymentIntentId == null || customerEmail == null || customerPhone == null) {
            return ResponseEntity.badRequest().body("Datos incompletos en la confirmación de pago.");
        }

        // Enviar notificaciones tras la confirmación del pago
        paymentUseCase.confirmPayment(paymentIntentId, customerEmail, customerPhone);

        return ResponseEntity.ok("Pago confirmado y notificación enviada con éxito.");
    }
}
