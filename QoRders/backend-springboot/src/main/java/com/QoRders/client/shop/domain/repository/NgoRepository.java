package com.QoRders.client.shop.domain.repository;

import com.QoRders.client.shop.domain.entity.NgoEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface NgoRepository extends JpaRepository<NgoEntity, Integer> {
    Optional<NgoEntity> findByNgoSlug(String ngoSlug);
}