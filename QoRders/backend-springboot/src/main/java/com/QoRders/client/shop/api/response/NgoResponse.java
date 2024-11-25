package com.QoRders.client.shop.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class NgoResponse {

    @JsonProperty("uuid")
    private String uuid;

    @JsonProperty("name")
    private String name;

    @JsonProperty("slug")
    private String slug;

    @JsonProperty("description")
    private String description;

    @JsonProperty("country")
    private String country;

    @JsonProperty("email")
    private String email;

    @JsonProperty("phone_number")
    private String phoneNumber;

    @JsonProperty("website_url")
    private String websiteUrl;

    @JsonProperty("logo_url")
    private String logoUrl;

    @JsonProperty("image_url")
    private String imageUrl;

    @JsonProperty("description_img_url")
    private String descriptionImageUrl;

    @JsonProperty("total_donations")
    private String totalDonations;

    @JsonProperty("is_active")
    private Boolean isActive;
}