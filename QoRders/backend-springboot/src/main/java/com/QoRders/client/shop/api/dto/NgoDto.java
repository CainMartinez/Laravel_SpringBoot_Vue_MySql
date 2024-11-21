package com.QoRders.client.shop.api.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NgoDto {
    private String uuid;
    private String name;
    private String slug;
    private String description;
    private String country;
    private String email;
    private String phoneNumber;
    private String websiteUrl;
    private String logoUrl;
    private String imageUrl;
    private String totalDonations;
}