package com.QoRders.client.shop.domain.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.QoRders.client.home.domain.entity.RoomEntity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Entity
@Table(name = "NGO")
@Getter
@Setter
public class NgoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ngo_id")
    private Integer ngoId;

    @Column(name = "ngo_uuid", nullable = false)
    private String ngoUuid;

    @Column(name = "ngo_name", nullable = false)
    private String ngoName;

    @Column(name = "ngo_slug", nullable = false)
    private String ngoSlug;

    @Column(name = "description")
    private String description;

    @Column(name = "country", nullable = false, unique = true)
    private String country;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "website_url")
    private String websiteUrl;

    @Column(name = "logo_url")
    private String logoUrl;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "description_img_url")
    private String descriptionImageUrl;

    @Column(name = "total_donations", precision = 10, scale = 2)
    private String totalDonations;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @OneToOne(mappedBy = "ngo", cascade = CascadeType.ALL)
    @JsonManagedReference // Permite serialización
    private RoomEntity room;

    @OneToMany(mappedBy = "country", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProductEntity> products;
}