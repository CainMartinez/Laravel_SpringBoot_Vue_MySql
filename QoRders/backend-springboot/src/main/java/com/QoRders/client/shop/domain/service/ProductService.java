package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.dto.ProductDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

public interface ProductService {
    Page<ProductDto> filterProductsBySlugAndType(String slug, String productType, Pageable pageable);
}