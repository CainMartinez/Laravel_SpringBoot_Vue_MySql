package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.assembler.ProductAssembler;
import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.domain.entity.ProductEntity;
import com.QoRders.client.shop.domain.repository.ProductRepository;
import com.QoRders.client.shop.infra.spec.ProductSpecification;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final ProductAssembler productAssembler;

    public ProductServiceImpl(ProductRepository productRepository, ProductAssembler productAssembler) {
        this.productRepository = productRepository;
        this.productAssembler = productAssembler;
    }

    @Override
    public Page<ProductDto> filterProductsBySlugAndType(String slug, String productType, Pageable pageable) {
        // Crear la especificación para el filtro
        Specification<ProductEntity> spec = ProductSpecification.withSlugAndType(slug, productType);

        // Obtener los productos filtrados con paginación
        Page<ProductEntity> products = productRepository.findAll(spec, pageable);

        // Mapear a DTO
        return products.map(productAssembler::toDto);
    }
}