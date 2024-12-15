package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.response.BookingResponse;

public interface BookingService {
    BookingResponse createBooking(BookingRequest request, String token);
}