package com.spring_boot.hexagonal.Payment.Application.UseCase.Command;

public class ProcessRefundCommand {
    private String transactionId;
    private Double refundAmount;
    private String customerEmail;
    private String customerPhone;

    public ProcessRefundCommand(String transactionId, Double refundAmount, String customerEmail, String customerPhone) {
        this.transactionId = transactionId;
        this.refundAmount = refundAmount;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
    }

    // Getters
    public String getTransactionId() {
        return transactionId;
    }
    public Double getRefundAmount() {
        return refundAmount;
    }
    public String getCustomerEmail() {
        return customerEmail;
    }
    public String getCustomerPhone() {
        return customerPhone;
    }
}
