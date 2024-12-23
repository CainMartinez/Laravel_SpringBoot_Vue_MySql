package com.QoRders.client.order.api.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class OrderProductRequest {

    @NotNull(message = "Order ID is required")
    private Integer orderId;

    @NotNull(message = "Products are required")
    private List<ProductQuantityRequest> products;

    @Getter
    @Setter
    public static class ProductQuantityRequest {
        @NotNull(message = "Product ID is required")
        private Integer productId;

        @NotNull(message = "Quantity is required")
        @Positive(message = "Quantity must be greater than 0")
        private Integer quantity;
    }
}