package com.QoRders.client.shop.api.controller;

import com.QoRders.client.shop.api.dto.ProductDto;
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
    public ResponseEntity<?> listProductsByRoom(
            @PathVariable String slug,
            @RequestParam(defaultValue = "0") int offset,
            @RequestParam(defaultValue = "10") int limit
    ) {
        if (!productService.roomExists(slug)) {
            return ResponseEntity.status(404).body(
                    String.format("Room with slug '%s' does not exist.", slug));
        }

        List<ProductDto> products = productService.findProductsByRoomSlug(slug, offset, limit);
        return ResponseEntity.ok(products);
    }
}