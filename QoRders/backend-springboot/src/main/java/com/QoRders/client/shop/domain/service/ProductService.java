package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.dto.ProductDto;

import java.util.List;

public interface ProductService {
    List<ProductDto> listAll();
}