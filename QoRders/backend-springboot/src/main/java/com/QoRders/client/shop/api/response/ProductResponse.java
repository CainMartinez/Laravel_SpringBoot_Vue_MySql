package com.QoRders.client.shop.api.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
public class ProductResponse {

    @JsonProperty("product_id")
    private Integer productId;

    @JsonProperty("uuid")
    private String uuid;

    @JsonProperty("name")
    private String name;

    @JsonProperty("slug")
    private String slug;

    @JsonProperty("description")
    private String description;

    @JsonProperty("unit_price")
    private BigDecimal unitPrice;

    @JsonProperty("allergens")
    private String allergens;

    @JsonProperty("stock")
    private Integer stock;

    @JsonProperty("image_url")
    private String imageUrl;

    @JsonProperty("product_type")
    private String productType;

    @JsonProperty("origin")
    private String origin;

    @JsonProperty("is_active")
    private Boolean isActive;
}