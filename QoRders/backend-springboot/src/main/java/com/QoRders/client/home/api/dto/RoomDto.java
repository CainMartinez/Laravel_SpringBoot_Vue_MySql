package com.QoRders.client.home.api.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class RoomDto {
    private String uuid;
    private String name;
    private String slug;
    private String description;
    private String theme;
    private Integer maxCapacity;
    private Integer totalBookings;
    private BigDecimal averageRating;
    private String imageUrl;
    private Boolean isActive;
    private Integer ngoId;
}