package com.QoRders.client.booking.api.request;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PaymentRequest {
    @NotNull(message = "El ID de la reserva es obligatorio")
    private Integer bookingId;
    
    @NotNull(message = "El ID de la orden es obligatorio")
    private Integer orderId;
    
    private String paymentMethod;
    
    private String paymentStatus;
}