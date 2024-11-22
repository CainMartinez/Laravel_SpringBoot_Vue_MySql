package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.domain.model.ProductFilter;

import java.util.List;

public interface ProductService {
    List<ProductDto> listAll(int offset, int limit);

    List<ProductDto> findProductsByRoomSlug(String slug, int offset, int limit);

    boolean roomExists(String slug);

    List<ProductDto> filterProducts(ProductFilter filter);
}