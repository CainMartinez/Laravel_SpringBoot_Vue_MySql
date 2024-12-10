package com.QoRders.client.auth.api.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class AuthResponse {

    private String token;
    private String email;
    private String firstName;
    private String lastName;
    private Integer age;
    private String address;
    private String avatarUrl;
    private Integer phone_number;
}