package com.spring_boot.hexagonal.Payment.Application.DTO.Request;

public class ProcessRefundRequestDTO {
    private String transactionId;
    private Double refundAmount;
    private String customerEmail;
    private String customerPhone;
    
    // Getters y setters
    public String getTransactionId() {
        return transactionId;
    }
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    public Double getRefundAmount() {
        return refundAmount;
    }
    public void setRefundAmount(Double refundAmount) {
        this.refundAmount = refundAmount;
    }
    public String getCustomerEmail() {
        return customerEmail;
    }
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    public String getCustomerPhone() {
        return customerPhone;
    }
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
}
