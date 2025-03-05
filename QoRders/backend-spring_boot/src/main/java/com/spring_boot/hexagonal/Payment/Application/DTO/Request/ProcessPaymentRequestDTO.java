package com.spring_boot.hexagonal.Payment.Application.DTO.Request;

public class ProcessPaymentRequestDTO {
    private Double amount;
    private String method; // "stripe" o "paypal"
    private String transactionData; // Por ejemplo, orderId u otro identificador
    private String customerName;
    private String customerEmail;
    private String customerPhone;
    
    // Getters y setters
    public Double getAmount() {
        return amount;
    }
    public void setAmount(Double amount) {
        this.amount = amount;
    }
    public String getMethod() {
        return method;
    }
    public void setMethod(String method) {
        this.method = method;
    }
    public String getTransactionData() {
        return transactionData;
    }
    public void setTransactionData(String transactionData) {
        this.transactionData = transactionData;
    }
    public String getCustomerName() {
        return customerName;
    }
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
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
