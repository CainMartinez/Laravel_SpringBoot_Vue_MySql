package com.QoRders.client.booking.api.request;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class TicketDto {
    private Integer ticketId;
    private BigDecimal totalAmount;
    private BigDecimal amountToPay;
    private String paymentStatus;
    private LocalDateTime createdAt;
}