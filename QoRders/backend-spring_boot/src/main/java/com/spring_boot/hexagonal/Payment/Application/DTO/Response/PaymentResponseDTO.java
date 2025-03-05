package com.spring_boot.hexagonal.Payment.Application.DTO.Response;

import java.time.LocalDateTime;

public class PaymentResponseDTO {
    private String transactionId;
    private Double amount;
    private LocalDateTime date;
    private String status;
    private String message; // Mensaje personalizado

    public PaymentResponseDTO() { }

    public PaymentResponseDTO(String transactionId, Double amount, LocalDateTime date, String status, String message) {
        this.transactionId = transactionId;
        this.amount = amount;
        this.date = date;
        this.status = status;
        this.message = message;
    }

    // Getters y setters
    public String getTransactionId() {
        return transactionId;
    }
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    public Double getAmount() {
        return amount;
    }
    public void setAmount(Double amount) {
        this.amount = amount;
    }
    public LocalDateTime getDate() {
        return date;
    }
    public void setDate(LocalDateTime date) {
        this.date = date;
    }
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }
}