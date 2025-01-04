package com.QoRders.client.booking.api.response;

import java.sql.Date;
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
    private Date bookingDate;
    private List<TicketDto> tickets;
}