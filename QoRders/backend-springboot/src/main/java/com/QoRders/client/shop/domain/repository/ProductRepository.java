package com.QoRders.client.shop.domain.repository;

import com.QoRders.client.shop.domain.entity.ProductEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<ProductEntity, Integer> {
    // Future raw SQL queries or filters can be added here
}