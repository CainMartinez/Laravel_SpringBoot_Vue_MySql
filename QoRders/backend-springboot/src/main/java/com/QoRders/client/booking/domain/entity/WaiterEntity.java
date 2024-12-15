package com.QoRders.client.booking.domain.entity;

import jakarta.persistence.*;
import lombok.*;
// import org.hibernate.annotations.GenericGenerator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "Waiter")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
// @Builder
public class WaiterEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "waiter_id")
    private Integer id;

    @Column(name = "waiter_uuid", unique = true, nullable = false, updatable = false)
    private String uuid = UUID.randomUUID().toString();

    @Column(name = "firstName", nullable = false)
    private String firstName;

    @Column(name = "lastName", nullable = false)
    private String lastName;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "phone_number")
    private String phoneNumber;

    @Column(name = "hire_date", nullable = false)
    private LocalDate hireDate;

    @Column(name = "average_rating", precision = 3, scale = 2, nullable = false)
    private BigDecimal averageRating = BigDecimal.valueOf(0.00);

    @Column(name = "salary", precision = 10, scale = 2, nullable = false)
    private BigDecimal salary = BigDecimal.valueOf(1000.00);

    @Enumerated(EnumType.STRING)
    @Column(name = "shift_disponibility", nullable = false)
    private ShiftDisponibility shiftDisponibility = ShiftDisponibility.Flexible;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;

    @Column(name = "avatar_url")
    private String avatarUrl;

    @Column(name = "bio")
    private String bio;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @OneToMany(mappedBy = "waiter", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BookingWaiterEntity> bookingWaiters;

    public enum ShiftDisponibility {
        Lunch,
        Dinner,
        Flexible
    }
}