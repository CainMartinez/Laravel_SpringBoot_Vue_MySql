package com.QoRders.client.booking.api.assembler;

import com.QoRders.client.booking.api.response.BookingResponse;
import com.QoRders.client.booking.domain.entity.BookingEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.format.DateTimeFormatter;

@Component
@RequiredArgsConstructor
public class BookingAssembler {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    public BookingResponse toResponse(BookingEntity booking, String phoneNumber) {
        BookingResponse response = new BookingResponse();
        response.setBookingUuid(booking.getUuid());
        response.setStatus(booking.getStatus().name());
        response.setRoomName(booking.getRoomShift().getRoom().getRoomName());
        response.setShift(booking.getRoomShift().getShift().getShiftType().name());
        response.setDate(booking.getRoomShift().getShift().getShiftDate().format(DATE_FORMATTER));
        response.setGuestCount(booking.getGuestCount());
        response.setPhoneNumber(phoneNumber);
        return response;
    }
}