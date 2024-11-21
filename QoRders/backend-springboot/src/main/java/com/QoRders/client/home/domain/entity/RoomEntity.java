package com.QoRders.client.home.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

import com.QoRders.client.shop.domain.entity.NgoEntity;

@Entity
@Table(name = "Room")
@Getter
@Setter
public class RoomEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_id")
    private Integer roomId;

    @Column(name = "room_uuid", nullable = false)
    private String roomUuid;

    @Column(name = "room_name", nullable = false)
    private String roomName;

    @Column(name = "room_slug", nullable = false)
    private String roomSlug;

    @Column(name = "description")
    private String description;

    @Column(name = "theme", nullable = false)
    private String theme;

    @Column(name = "max_capacity", nullable = false)
    private Integer maxCapacity;

    @Column(name = "total_bookings")
    private Integer totalBookings;

    @Column(name = "average_rating", precision = 3, scale = 2)
    private BigDecimal averageRating;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @OneToOne
    @JoinColumn(name = "ngo_id", referencedColumnName = "ngo_id", nullable = false)
    private NgoEntity ngo;
}