package com.QoRders.client.order.domain.repository;

import com.QoRders.client.order.domain.entity.OrderEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends JpaRepository<OrderEntity, Integer> {
    boolean existsByBookingIdAndOrderStatusNot(Integer bookingId, OrderEntity.OrderStatus orderStatus);
}