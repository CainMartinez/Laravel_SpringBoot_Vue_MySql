package com.QoRders.client.order.api.assembler;

import com.QoRders.client.order.api.response.OrderResponse;
import com.QoRders.client.order.domain.entity.OrderEntity;
import org.springframework.stereotype.Component;

import java.util.stream.Collectors;

@Component
public class OrderAssembler {

    public OrderResponse toResponse(OrderEntity orderEntity) {
        OrderResponse response = new OrderResponse();
        response.setOrderId(orderEntity.getOrderId());
        response.setOrderUuid(orderEntity.getOrderUuid());
        response.setOrderStatus(orderEntity.getOrderStatus().name());
        response.setPaymentStatus(orderEntity.getPaymentStatus().name());
        response.setTotalAmount(orderEntity.getTotalAmount());
        response.setNotes(orderEntity.getNotes());

        response.setOrderProducts(orderEntity.getOrderProducts().stream().map(product -> {
            OrderResponse.OrderProductResponse productResponse = new OrderResponse.OrderProductResponse();
            productResponse.setProductName(product.getProduct().getProductName());
            productResponse.setQuantity(product.getQuantity());
            productResponse.setUnitPrice(product.getProduct().getUnitPrice());
            productResponse.setIsDelivered(product.getIsDelivered());
            return productResponse;
        }).collect(Collectors.toList()));

        return response;
    }
}