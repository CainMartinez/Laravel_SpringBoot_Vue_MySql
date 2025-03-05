package com.spring_boot.hexagonal.Payment.Domain.PortOut;

import com.spring_boot.hexagonal.Payment.Domain.Entity.Payment;

public interface PaymentProcessorInterface {
    Payment processPayment(Double amount, String transactionData);
    Payment processRefund(String transactionId, Double refundAmount);
}
