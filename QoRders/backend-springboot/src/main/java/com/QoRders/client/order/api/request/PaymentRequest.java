package com.QoRders.client.order.api.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PaymentRequest {
    @NotNull(message = "Payment method is required")
    private String paymentMethod;
}