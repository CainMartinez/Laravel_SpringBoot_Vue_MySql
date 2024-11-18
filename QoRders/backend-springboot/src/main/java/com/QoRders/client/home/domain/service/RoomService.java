package com.QoRders.client.home.domain.service;

import com.QoRders.client.home.domain.model.Room;

import java.util.List;
import java.util.Optional;

public interface RoomService {
    List<Room> listAll();
    Optional<Room> listOneBySlug(String slug);
}