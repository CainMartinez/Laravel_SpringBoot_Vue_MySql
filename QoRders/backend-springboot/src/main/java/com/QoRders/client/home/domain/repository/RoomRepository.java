package com.QoRders.client.home.domain.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.QoRders.client.home.domain.entity.RoomEntity;

import java.util.Optional;

@Repository
public interface RoomRepository extends JpaRepository<RoomEntity, Integer> {
    Optional<RoomEntity> findByRoomSlug(String roomSlug);
}