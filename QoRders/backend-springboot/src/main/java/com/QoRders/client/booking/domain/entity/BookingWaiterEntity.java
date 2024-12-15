package com.QoRders.client.booking.domain.entity;

// import com.QoRders.client.booking.domain.entity.Waiter;
import jakarta.persistence.*;
import lombok.*;
// import org.hibernate.annotations.GenericGenerator;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "Booking_Waiter")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
// @Builder
public class BookingWaiterEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_waiter_id")
    private Integer id;

    @Column(name = "booking_waiter_uuid", unique = true, nullable = false, updatable = false)
    private String uuid = UUID.randomUUID().toString();

    @ManyToOne
    @JoinColumn(name = "booking_id", nullable = false)
    private BookingEntity booking;

    @ManyToOne
    @JoinColumn(name = "waiter_id", nullable = false)
    private WaiterEntity waiter;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private Role role = Role.Support;

    @Column(name = "notes")
    private String notes;

    @Column(name = "assigned_at", updatable = false)
    private LocalDateTime assignedAt = LocalDateTime.now();

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    public enum Role {
        Lead,
        Support
    }
}