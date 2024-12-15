package com.QoRders.client.booking.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.QoRders.client.home.domain.entity.RoomEntity;

@Entity
@Table(name = "Room_Shift")
@Getter
@Setter
public class RoomShiftEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "room_shift_id")
    private Integer roomShiftId;

    @Column(name = "room_shift_uuid", nullable = false, unique = true)
    private String roomShiftUuid;

    @ManyToOne
    @JoinColumn(name = "room_id", referencedColumnName = "room_id", nullable = false)
    private RoomEntity room;

    @ManyToOne
    @JoinColumn(name = "shift_id", referencedColumnName = "shift_id", nullable = false)
    private ShiftEntity shift;

    @Column(name = "reserved_capacity")
    private Integer reservedCapacity;

    @Column(name = "total_revenue", precision = 10, scale = 2)
    private BigDecimal totalRevenue;

    @Column(name = "status", nullable = false)
    @Enumerated(EnumType.STRING)
    private RoomShiftStatus status;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }

    public enum RoomShiftStatus {
        Active,
        Closed,
        Pending
    }
}