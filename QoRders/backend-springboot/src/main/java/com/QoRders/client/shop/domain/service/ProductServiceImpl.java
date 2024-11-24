package com.QoRders.client.shop.domain.service;

import com.QoRders.client.shop.api.assembler.ProductAssembler;
import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.domain.enums.ProductType;
import com.QoRders.client.shop.domain.model.ProductFilter;
import com.QoRders.client.shop.domain.repository.ProductRepository;
import com.QoRders.client.home.domain.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final RoomRepository roomRepository;
    private final ProductAssembler productAssembler;

    public ProductServiceImpl(ProductRepository productRepository, RoomRepository roomRepository, ProductAssembler productAssembler) {
        this.productRepository = productRepository;
        this.roomRepository = roomRepository;
        this.productAssembler = productAssembler;
    }

    @Override
    public List<ProductDto> listAll(int offset, int limit) {
        return productRepository.findAllWithPagination(limit, offset)
                .stream()
                .map(productAssembler::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ProductDto> findProductsByRoomSlug(String slug, int offset, int limit) {
        return productRepository.findProductsByRoomSlug(slug, limit, offset)
                .stream()
                .map(productAssembler::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<ProductDto> filterProducts(ProductFilter filter) {
        String productTypeValue = ProductType.fromValue(filter.getProductType()).getValue();
        String order = filter.getOrder() != null ? filter.getOrder() : "asc";

        return productRepository.filterProductsByRoomAndTypeAndOrder(
                filter.getSlug(), productTypeValue, order, filter.getLimit(), filter.getOffset()
        ).stream()
        .map(productAssembler::toDto)
        .collect(Collectors.toList());
    }

    @Override
    public boolean roomExists(String slug) {
        return roomRepository.findByRoomSlug(slug).isPresent();
    }
}