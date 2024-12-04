package com.QoRders.client.auth.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "Blacklist")
@Getter
@Setter
public class BlacklistTokenEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String token;

    @Column(nullable = false)
    private String email;

    @Column(name = "expiration_date", nullable = false)
    private Date expirationDate;
}