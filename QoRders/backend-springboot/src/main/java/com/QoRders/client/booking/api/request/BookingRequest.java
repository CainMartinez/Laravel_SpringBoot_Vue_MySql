package com.QoRders.client.booking.api.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookingRequest {

    @NotNull(message = "Date is required")
    private String date;

    @NotBlank(message = "Room is required")
    @Size(max = 100, message = "Room name must be less than 100 characters")
    private String room;

    @NotBlank(message = "Name is required")
    @Size(max = 100, message = "Name must be less than 100 characters")
    private String firstName;

    @NotBlank(message = "Shift is required")
    @Size(max = 50, message = "Shift must be less than 50 characters")
    private String shift;

    @NotNull(message = "Guest count is required")
    @Positive(message = "Guest count must be a positive number")
    private Integer guest_count;

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;

    @NotBlank(message = "Phone number is required")
    @Size(min = 9, max = 15, message = "Phone number must be between 9 and 15 characters")
    private String phoneNumber;
}