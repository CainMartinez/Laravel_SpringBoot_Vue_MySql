package com.QoRders.client.order.api.response;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Getter
@Setter
public class OrderResponse {

    private Integer orderId;
    private String orderUuid;
    private String orderStatus;
    private String paymentStatus;
    private BigDecimal totalAmount;
    private String notes;
    private List<OrderProductResponse> orderProducts;

    @Getter
    @Setter
    public static class OrderProductResponse {
        private String productName;
        private Integer quantity;
        private BigDecimal unitPrice;
        private Boolean isDelivered;
    }
}