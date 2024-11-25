package com.QoRders.client.shop.api.controller;

import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.domain.model.ProductFilter;
import com.QoRders.client.shop.domain.service.ProductService;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
@CrossOrigin(origins = "http://localhost:8085")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping
    public ResponseEntity<List<ProductDto>> listAll(
            @RequestParam(defaultValue = "0") int offset,
            @RequestParam(defaultValue = "10") int limit
    ) {
        List<ProductDto> products = productService.listAll(offset, limit);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/room/{slug}")
    public ResponseEntity<?> listProductsByRoomSlug(
            @PathVariable String slug,
            @RequestParam(required = false) String productType,
            @RequestParam(required = false) String order,
            @RequestParam(defaultValue = "0") int offset,
            @RequestParam(defaultValue = "10") int limit
    ) {
        ProductFilter filter = new ProductFilter(slug, productType, order, offset, limit);
        List<ProductDto> products = productService.filterProducts(filter);

        if (products.isEmpty()) {
            return ResponseEntity.status(404).body(
                    String.format("No products found for room with slug '%s' or associated NGO.", slug));
        }

        return ResponseEntity.ok(products);
    }
}