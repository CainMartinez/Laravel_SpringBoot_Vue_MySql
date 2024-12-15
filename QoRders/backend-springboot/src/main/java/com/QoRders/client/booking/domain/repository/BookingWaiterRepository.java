package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.BookingWaiterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingWaiterRepository extends JpaRepository<BookingWaiterEntity, Integer> {
}