package com.QoRders.client.booking.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "Shift")
@Getter
@Setter
public class ShiftEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "shift_id")
    private Integer shiftId;

    @Column(name = "shift_uuid", nullable = false, unique = true)
    private String shiftUuid;

    @Column(name = "shift_date", nullable = false)
    private LocalDate shiftDate;

    @Column(name = "shift_type", nullable = false)
    @Enumerated(EnumType.STRING)
    private ShiftType shiftType;

    @Column(name = "total_revenue", precision = 10, scale = 2)
    private BigDecimal totalRevenue;

    @Column(name = "is_active", nullable = false)
    private Boolean isActive;

    public enum ShiftType {
        Lunch,
        Dinner
    }
}