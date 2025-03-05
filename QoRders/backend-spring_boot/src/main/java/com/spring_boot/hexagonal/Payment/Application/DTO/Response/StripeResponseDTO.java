package com.spring_boot.hexagonal.Payment.Application.DTO.Response;

public class StripeResponseDTO {
    private String clientSecret;

    public String getClientSecret() {
        return clientSecret;
    }

    public void setClientSecret(String clientSecret) {
        this.clientSecret = clientSecret;
    }
}
