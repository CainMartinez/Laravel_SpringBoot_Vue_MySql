package com.QoRders.client.shop.api.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class ProductDto {

    private Integer productId;
    private String uuid;
    private String name;
    private String slug;
    private String description;
    private BigDecimal unitPrice;
    private String allergens;
    private Integer stock;
    private String imageUrl;
    private String productType;
    private String origin;
    private Boolean isActive;
}