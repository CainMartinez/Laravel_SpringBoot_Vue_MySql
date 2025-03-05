package com.spring_boot.hexagonal.Payment.Presentation.AdapterIn.Rest;

import com.spring_boot.hexagonal.Payment.Application.DTO.Request.ProcessPaymentRequestDTO;
import com.spring_boot.hexagonal.Payment.Application.DTO.Request.ProcessRefundRequestDTO;
import com.spring_boot.hexagonal.Payment.Application.DTO.Response.PaymentResponseDTO;
import com.spring_boot.hexagonal.Payment.Application.UseCase.Command.ProcessPaymentCommand;
import com.spring_boot.hexagonal.Payment.Application.UseCase.Command.ProcessRefundCommand;
import com.spring_boot.hexagonal.Payment.Application.UseCase.PortIn.PaymentUseCase;
import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payment")
public class PaymentController {

    private final PaymentUseCase paymentUseCase;

    @Autowired
    public PaymentController(PaymentUseCase paymentUseCase) {
        this.paymentUseCase = paymentUseCase;
    }

    @PostMapping("/process")
    public ResponseEntity<PaymentResponseDTO> processPayment(@RequestBody ProcessPaymentRequestDTO requestDTO) {
        Payment payment = paymentUseCase.processPayment(
                new ProcessPaymentCommand(
                        requestDTO.getAmount(),
                        requestDTO.getMethod(),
                        requestDTO.getTransactionData(),
                        requestDTO.getCustomerName(),
                        requestDTO.getCustomerEmail(),
                        requestDTO.getCustomerPhone()
                )
        );
        PaymentResponseDTO responseDTO = new PaymentResponseDTO(
                payment.getTransactionId(),
                payment.getAmount(),
                payment.getDate(),
                payment.getStatus(),
                "Pago procesado exitosamente."
        );
        return ResponseEntity.ok(responseDTO);
    }

    @PostMapping("/refund")
    public ResponseEntity<PaymentResponseDTO> processRefund(@RequestBody ProcessRefundRequestDTO requestDTO) {
        Payment payment = paymentUseCase.processRefund(
                new ProcessRefundCommand(
                        requestDTO.getTransactionId(),
                        requestDTO.getRefundAmount(),
                        requestDTO.getCustomerEmail(),
                        requestDTO.getCustomerPhone()
                )
        );
        PaymentResponseDTO responseDTO = new PaymentResponseDTO(
                payment.getTransactionId(),
                payment.getAmount(),
                payment.getDate(),
                payment.getStatus(),
                "Devolución procesada exitosamente."
        );
        return ResponseEntity.ok(responseDTO);
    }
}
