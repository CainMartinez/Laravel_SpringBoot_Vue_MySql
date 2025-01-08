package com.QoRders.client.shop.api.assembler;

import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.api.response.ProductResponse;
import com.QoRders.client.shop.domain.entity.ProductEntity;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ProductAssembler {

    public ProductResponse toResponse(ProductEntity product) {
        ProductResponse response = new ProductResponse();
        response.setProductId(product.getProductId());
        response.setUuid(product.getProductUuid());
        response.setName(product.getProductName());
        response.setSlug(product.getProductSlug());
        response.setDescription(product.getDescription());
        response.setUnitPrice(product.getUnitPrice());
        response.setAllergens(product.getAllergens());
        response.setStock(product.getStock());
        response.setImageUrl(product.getImageUrl());
        response.setProductType(product.getProductType().toString());
        if (product.getCountry() != null) {
            response.setOrigin(product.getCountry().getCountry());
        } else {
            response.setOrigin(null);
        }
        response.setIsActive(product.getIsActive());
        return response;
    }

    public List<ProductResponse> toResponseList(List<ProductEntity> products) {
        return products.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    public ProductDto toDto(ProductEntity product) {
        ProductDto dto = new ProductDto();
        dto.setProductId(product.getProductId());
        dto.setUuid(product.getProductUuid());
        dto.setName(product.getProductName());
        dto.setSlug(product.getProductSlug());
        dto.setDescription(product.getDescription());
        dto.setUnitPrice(product.getUnitPrice());
        dto.setAllergens(product.getAllergens());
        dto.setStock(product.getStock());
        dto.setImageUrl(product.getImageUrl());
        dto.setProductType(product.getProductType().toString());
        if (product.getCountry() != null) {
            dto.setOrigin(product.getCountry().getCountry());
        } else {
            dto.setOrigin(null);
        }
        dto.setIsActive(product.getIsActive());
        return dto;
    }
}