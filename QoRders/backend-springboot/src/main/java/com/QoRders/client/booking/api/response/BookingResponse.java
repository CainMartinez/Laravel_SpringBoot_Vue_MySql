package com.QoRders.client.booking.api.response;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookingResponse {

    private String bookingUuid;
    private String status;
    private String roomName;
    private String shift;
    private String date;
    private Integer guestCount;
    private String phoneNumber;
}