package com.QoRders.client.client.api.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ClientResponse {
    private String uuid;
    private String firstName;
    private String lastName;
    private String email;
    private String phoneNumber;
    private String bio;
    private String avatarUrl;
    private Boolean hasCoupon;
    private Integer loyaltyPoints;
    private Boolean isActive;
    private String createdAt;
    private String updatedAt;
}