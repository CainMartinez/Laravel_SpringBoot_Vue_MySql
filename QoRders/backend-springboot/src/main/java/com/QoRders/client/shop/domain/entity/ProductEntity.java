package com.QoRders.client.shop.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import com.QoRders.client.shop.domain.converter.ProductTypeConverter;
import com.QoRders.client.shop.domain.enums.ProductType;

import java.math.BigDecimal;

@Entity
@Table(name = "Products")
@Getter
@Setter
public class ProductEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_id")
    private Integer productId;

    @Column(name = "product_uuid", nullable = false, unique = true)
    private String productUuid;

    @Column(name = "product_name", nullable = false)
    private String productName;

    @Column(name = "product_slug", nullable = false, unique = true)
    private String productSlug;

    @Column(name = "description")
    private String description;

    @Column(name = "unit_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal unitPrice;

    @Column(name = "allergens")
    private String allergens;

    @Column(name = "stock", nullable = false, columnDefinition = "int default 0")
    private Integer stock;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "product_type", nullable = false)
    @Convert(converter = ProductTypeConverter.class)
    private ProductType productType;

    @Column(name = "is_active", nullable = false, columnDefinition = "tinyint(1) default 1")
    private Boolean isActive;

    @Column(name = "created_at", updatable = false, insertable = false)
    private java.time.LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false)
    private java.time.LocalDateTime updatedAt;

    @ManyToOne
    @JoinColumn(name = "origin", referencedColumnName = "country", nullable = false)
    private NgoEntity country;
}