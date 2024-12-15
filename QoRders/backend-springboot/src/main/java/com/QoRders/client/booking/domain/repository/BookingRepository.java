package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.BookingEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingRepository extends JpaRepository<BookingEntity, Integer> {

    boolean existsByClientCustomerIdAndStatus(Integer customerId, BookingEntity.Status status);
}