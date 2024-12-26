package com.QoRders.client.booking.domain.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Tickets")
@Getter
@Setter
public class TicketEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ticket_id")
    private Integer ticketId;

    @Column(name = "ticket_uuid", nullable = false, unique = true)
    private String ticketUuid;

    @Column(name = "booking_id", nullable = false)
    private Integer bookingId;

    @Column(name = "total_amount", precision = 10, scale = 2, nullable = false)
    private BigDecimal totalAmount;

    @Column(name = "amount_to_pay", precision = 10, scale = 2, nullable = false)
    private BigDecimal amountToPay;

    @Column(name = "donated_amount", precision = 10, scale = 2, nullable = false)
    private BigDecimal donatedAmount;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_status", nullable = false)
    private PaymentStatus paymentStatus = PaymentStatus.Pending;

    @Column(name = "created_at", nullable = false, updatable = false)
    @org.hibernate.annotations.CreationTimestamp
    private LocalDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    @org.hibernate.annotations.UpdateTimestamp
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "booking_id", insertable = false, updatable = false)
    private BookingEntity booking;

    public enum PaymentStatus {
        Paid,
        Pending,
        Partial
    }
}