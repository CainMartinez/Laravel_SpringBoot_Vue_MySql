package com.spring_boot.hexagonal.Payment.Application.UseCase.Command;

public class ProcessPaymentCommand {
    private Double amount;
    private String method;
    private String transactionData;
    private String customerName;
    private String customerEmail;
    private String customerPhone;

    public ProcessPaymentCommand(Double amount, String method, String transactionData,
                                 String customerName, String customerEmail, String customerPhone) {
        this.amount = amount;
        this.method = method;
        this.transactionData = transactionData;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.customerPhone = customerPhone;
    }

    // Getters
    public Double getAmount() {
        return amount;
    }
    public String getMethod() {
        return method;
    }
    public String getTransactionData() {
        return transactionData;
    }
    public String getCustomerName() {
        return customerName;
    }
    public String getCustomerEmail() {
        return customerEmail;
    }
    public String getCustomerPhone() {
        return customerPhone;
    }
}
