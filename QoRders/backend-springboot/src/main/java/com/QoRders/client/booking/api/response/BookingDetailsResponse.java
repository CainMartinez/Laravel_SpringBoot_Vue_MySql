package com.QoRders.client.booking.api.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
public class BookingDetailsResponse {
    private Integer bookingId;
    private String uuid;
    private String clientEmail;
    private String roomName;
    private String roomSlug;
    private Integer guestCount;
    private String status;
    private String notes;
    private Date bookingDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}