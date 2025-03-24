package com.QoRders.client.client.api.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ClientUpdateRequest {

    @Size(max = 100, message = "First name cannot exceed 100 characters")
    private String firstName;

    @Size(max = 100, message = "Last name cannot exceed 100 characters")
    private String lastName;

    private Integer age;

    @Size(max = 500, message = "Address cannot exceed 500 characters")
    private String address;

    @Email(message = "Email must be valid")
    @Size(max = 150, message = "Email cannot exceed 150 characters")
    private String email;

    @Size(max = 15, message = "Phone number cannot exceed 15 characters")
    private String phoneNumber;

    @Size(max = 255, message = "Avatar URL cannot exceed 255 characters")
    private String avatarUrl;

    @Size(max = 500, message = "Bio cannot exceed 500 characters")
    private String bio;

    @Size(min = 8, max = 255, message = "Password must be between 8 and 255 characters")
    private String password;

    private boolean has_coupon;

    private int loyalty_points;
}