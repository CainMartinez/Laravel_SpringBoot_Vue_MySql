package com.QoRders.client.order.domain.repository;

import com.QoRders.client.order.domain.entity.OrderEntity;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends JpaRepository<OrderEntity, Integer> {
    boolean existsByBookingIdAndOrderStatusNot(Integer bookingId, OrderEntity.OrderStatus orderStatus);
    List<OrderEntity> findByBookingIdAndOrderStatus(Integer bookingId, OrderEntity.OrderStatus orderStatus);
    List<OrderEntity> findByBookingId(Integer bookingId);
    OrderEntity findByOrderId(Integer orderId);
}