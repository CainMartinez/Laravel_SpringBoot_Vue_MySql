package com.QoRders.client.home.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class RoomResponse {

    @JsonProperty("uuid")
    private String uuid;

    @JsonProperty("name")
    private String name;

    @JsonProperty("slug")
    private String slug;

    @JsonProperty("description")
    private String description;

    @JsonProperty("theme")
    private String theme;

    @JsonProperty("max_capacity")
    private Integer maxCapacity;

    @JsonProperty("total_bookings")
    private Integer totalBookings;

    @JsonProperty("average_rating")
    private BigDecimal averageRating;

    @JsonProperty("image_url")
    private String imageUrl;

    @JsonProperty("is_active")
    private Boolean isActive;

    @JsonProperty("ngo_id")
    private Integer ngoId;
}