package com.QoRders.client.client.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "Customer")
@Getter
@Setter
public class ClientEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "customer_id")
    private Integer client_id;

    @Column(name = "customer_uuid", nullable = false, unique = true)
    private String client_uuid;

    @Column(name = "first_name", nullable = false, length = 100)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 100)
    private String lastName;

    @Column(name = "age")
    private Integer age;

    @Column(name = "address", columnDefinition = "TEXT")
    private String address;

    @Column(name = "email", nullable = false, unique = true, length = 150)
    private String email;

    @Column(name = "phone_number", length = 15)
    private String phone_number;

    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Column(name = "avatar_url", columnDefinition = "TEXT")
    private String avatar_url;

    @Column(name = "bio", columnDefinition = "TEXT")
    private String bio;

    @Column(name = "has_coupon", nullable = false)
    private Boolean has_coupon = false;

    @Column(name = "loyalty_points", nullable = false)
    private Integer loyalty_points = 0;

    @Column(name = "is_active", nullable = false)
    private Boolean is_active = true;

    @Column(name = "refresh_token", length = 100)
    private String refresh_token;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime created_at = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updated_at = LocalDateTime.now();

    @PrePersist
    protected void onCreate() {
        this.created_at = LocalDateTime.now();
        this.updated_at = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updated_at = LocalDateTime.now();
    }
}