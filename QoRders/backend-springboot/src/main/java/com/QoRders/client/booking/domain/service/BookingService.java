package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.response.BookingResponse;
import com.QoRders.client.booking.domain.entity.BookingEntity;
import com.QoRders.client.booking.domain.entity.TicketEntity;

public interface BookingService {
    BookingResponse createBooking(BookingRequest request, String token);
    String finalizeBookingPayment(Integer orderId, String paymentMethod);
    BookingEntity getBookingById(Integer bookingId);
    TicketEntity generateTicket(Integer bookingId);
    String finalizeBookingPayment(Integer bookingId, Integer orderId, String paymentMethod, String paymentStatus);
}