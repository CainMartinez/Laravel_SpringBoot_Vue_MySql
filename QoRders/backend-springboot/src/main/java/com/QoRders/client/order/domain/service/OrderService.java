package com.QoRders.client.order.domain.service;

import com.QoRders.client.order.domain.entity.OrderEntity;
import com.QoRders.client.order.domain.entity.OrderProductsEntity;

public interface OrderService {
    OrderEntity createOrder(Integer bookingId, String notes);
    OrderEntity addProductToOrder(Integer orderId, OrderProductsEntity productRequest, Integer productId, String email);
    OrderEntity getOrderById(Integer orderId);
    OrderEntity updateOrder(OrderEntity order);
}