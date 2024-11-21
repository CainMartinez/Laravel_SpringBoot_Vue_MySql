package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.assembler.ProductAssembler;
import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.domain.repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final ProductAssembler productAssembler;

    public ProductServiceImpl(ProductRepository productRepository, ProductAssembler productAssembler) {
        this.productRepository = productRepository;
        this.productAssembler = productAssembler;
    }

    @Override
    public List<ProductDto> listAll() {
        return productRepository.findAll()
                .stream()
                .map(productAssembler::toDto)
                .collect(Collectors.toList());
    }
}