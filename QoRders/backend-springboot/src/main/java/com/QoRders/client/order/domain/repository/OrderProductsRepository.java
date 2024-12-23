package com.QoRders.client.order.domain.repository;

import com.QoRders.client.order.domain.entity.OrderEntity;
import com.QoRders.client.order.domain.entity.OrderProductsEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderProductsRepository extends JpaRepository<OrderProductsEntity, Integer> {
    /**
     * Encuentra todos los productos asociados a una orden.
     *
     * @param order La orden asociada.
     * @return Lista de productos.
     */
    List<OrderProductsEntity> findByOrder(OrderEntity order);
}