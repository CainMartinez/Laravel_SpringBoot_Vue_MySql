package com.QoRders.client.shop.domain.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductFilter {
    private String slug;
    private String productType;
    private String order;
    private int offset;
    private int limit;
}