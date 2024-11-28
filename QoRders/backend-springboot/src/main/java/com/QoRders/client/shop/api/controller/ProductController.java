package com.QoRders.client.shop.api.controller;

import com.QoRders.client.shop.api.dto.ProductDto;
import com.QoRders.client.shop.domain.service.ProductService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = {"http://localhost:8085", "http://localhost:8086"})
@RequestMapping("/api/products")
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/room/{slug}")
    public ResponseEntity<Page<ProductDto>> filterProducts(
            @PathVariable("slug") String slug,
            @RequestParam(value = "order", required = false) String order,
            @RequestParam(value = "productType", required = false) String productType,
            @RequestParam(value = "offset", defaultValue = "0") int offset,
            @RequestParam(value = "limit", defaultValue = "10") int limit) {

        // Si los parámetros vienen como "null", tratarlos como si no estuvieran presentes
        if ("null".equalsIgnoreCase(order)) {
            order = null;
        }
        if ("null".equalsIgnoreCase(productType)) {
            productType = null;
        }

        // Configurar Pageable según los parámetros
        Pageable pageable;
        if (order == null || order.isBlank()) {
            pageable = PageRequest.of(offset / limit, limit);
        } else {
            pageable = PageRequest.of(
                    offset / limit,
                    limit,
                    order.equalsIgnoreCase("desc") ? Sort.by("unitPrice").descending() : Sort.by("unitPrice").ascending()
            );
        }

        // Normalizar el parámetro productType
        if (productType != null && !productType.isBlank()) {
            productType = productType.replace("_", " ");
        }

        // Llamar al servicio con los parámetros
        Page<ProductDto> products = productService.filterProductsBySlugAndType(slug, productType, pageable);
        return ResponseEntity.ok(products);
    }
}