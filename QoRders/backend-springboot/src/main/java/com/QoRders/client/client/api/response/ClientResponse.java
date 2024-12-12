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
    private String phone_number;
    private String bio;
    private String avatar_url;
    private Boolean has_coupon;
    private Integer loyalty_points;
    private Integer age;
    private String address;
    private Boolean is_active;
    private String created_at;
    private String updated_at;
}