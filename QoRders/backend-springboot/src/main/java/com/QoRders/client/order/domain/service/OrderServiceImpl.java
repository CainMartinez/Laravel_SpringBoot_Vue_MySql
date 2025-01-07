package com.QoRders.client.order.domain.service;

import com.QoRders.client.booking.domain.entity.BookingEntity;
import com.QoRders.client.booking.domain.repository.BookingRepository;
import com.QoRders.client.order.domain.entity.OrderEntity;
import com.QoRders.client.order.domain.entity.OrderProductsEntity;
import com.QoRders.client.order.domain.exceptions.ActiveOrderExistsException;
import com.QoRders.client.order.domain.repository.OrderProductsRepository;
import com.QoRders.client.order.domain.repository.OrderRepository;
import com.QoRders.client.shop.domain.entity.ProductEntity;
import com.QoRders.client.shop.domain.repository.ProductRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;
    private final OrderProductsRepository orderProductsRepository;
    private final BookingRepository bookingRepository;
    private final ProductRepository productRepository;

    @Override
    @Transactional
    public OrderEntity createOrder(Integer bookingId, String notes) {
        BookingEntity booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));

        boolean existsActiveOrder = orderRepository.existsByBookingIdAndOrderStatusNot(
                bookingId, OrderEntity.OrderStatus.Delivered);

        if (existsActiveOrder) {
            throw new ActiveOrderExistsException("Ya existe un pedido activo para esta reserva. Espere a que se le entregue para poder realizar otro.");
        }

        OrderEntity order = new OrderEntity();
        order.setBooking(booking);
        order.setOrderStatus(OrderEntity.OrderStatus.Waiting);
        order.setPaymentStatus(OrderEntity.PaymentStatus.Unpaid);
        order.setTotalAmount(BigDecimal.ZERO);
        order.setNotes(notes != null ? notes : "");
        order.setIsActive(true);

        return orderRepository.save(order);
    }

    @Override
    @Transactional
    public OrderEntity addProductToOrder(Integer orderId, OrderProductsEntity productRequest, Integer productId, String email) {
        OrderEntity order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found"));

        if (!order.getBooking().getClient().getEmail().equals(email)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied to this order");
        }

        ProductEntity product = productRepository.findById(productId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));

        OrderProductsEntity orderProduct = new OrderProductsEntity();
        orderProduct.setOrder(order);
        orderProduct.setProduct(product);
        orderProduct.setQuantity(productRequest.getQuantity());

        orderProductsRepository.save(orderProduct);

        BigDecimal totalAmount = orderProductsRepository.findByOrder(order).stream()
                .map(p -> BigDecimal.valueOf(p.getQuantity()).multiply(p.getProduct().getUnitPrice()))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        order.setTotalAmount(totalAmount);
        return orderRepository.save(order);
    }

    @Override
    @Transactional(readOnly = true)
    public OrderEntity getOrderById(Integer orderId) {
        return orderRepository.findById(orderId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found"));
    }

    @Override
    @Transactional
    public OrderEntity updateOrder(OrderEntity order) {
        return orderRepository.save(order);
    }
}