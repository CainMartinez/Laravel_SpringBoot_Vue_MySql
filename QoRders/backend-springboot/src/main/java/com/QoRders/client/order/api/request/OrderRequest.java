package com.QoRders.client.order.api.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderRequest {

    @NotNull(message = "Booking ID is required")
    private Integer bookingId;

    private String notes;
}