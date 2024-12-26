package com.QoRders.client.booking.api.response;

import java.time.LocalDateTime;
import java.util.List;

import com.QoRders.client.booking.api.request.TicketDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;


@Getter
@Setter
@AllArgsConstructor
public class BookingWithTicketsResponse {
    private Integer bookingId;
    private String roomName;
    private Integer guestCount;
    private String status;
    private String notes;
    private LocalDateTime createdAt;
    private List<TicketDto> tickets;
}