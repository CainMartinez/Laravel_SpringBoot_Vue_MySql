package com.QoRders.client.order.domain.service;

import com.QoRders.client.booking.domain.entity.BookingEntity;
import com.QoRders.client.booking.domain.repository.BookingRepository;
import com.QoRders.client.order.domain.entity.OrderEntity;
import com.QoRders.client.order.domain.entity.OrderProductsEntity;
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
        // Verificar que la reserva existe
        BookingEntity booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));

        // Crear nueva orden
        OrderEntity order = new OrderEntity();
        order.setBooking(booking);
        order.setOrderStatus(OrderEntity.OrderStatus.Waiting);
        order.setPaymentStatus(OrderEntity.PaymentStatus.Unpaid);
        order.setTotalAmount(BigDecimal.ZERO);
        order.setNotes(notes != null ? notes : "");

        // Guardar en la base de datos
        return orderRepository.save(order);
    }

    @Override
    @Transactional
    public OrderEntity addProductToOrder(Integer orderId, OrderProductsEntity productRequest, Integer productId, String email) {
        // Validar que el usuario tiene acceso al pedido
        OrderEntity order = orderRepository.findById(orderId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Order not found"));
    
        if (!order.getBooking().getClient().getEmail().equals(email)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied to this order");
        }
    
        // Buscar el producto por ID
        ProductEntity product = productRepository.findById(productId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Product not found"));
    
        // Crear el objeto de OrderProductsEntity
        OrderProductsEntity orderProduct = new OrderProductsEntity();
        orderProduct.setOrder(order);
        orderProduct.setProduct(product);
        orderProduct.setQuantity(productRequest.getQuantity());
    
        // Guardar el producto en la base de datos
        orderProductsRepository.save(orderProduct);
    
        // Actualizar el total de la orden
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
}