package com.QoRders.client.home.domain.service;

import com.QoRders.client.home.domain.model.Room;
import com.QoRders.client.home.domain.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;

    // Inyección de dependencias a través del constructor
    public RoomServiceImpl(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    @Override
    public List<Room> listAll() {
        List<Room> rooms = roomRepository.findAll();
        System.out.println("Rooms found: " + rooms); // Log para depuración
        return rooms;
    }

    @Override
    public Optional<Room> listOneBySlug(String slug) {
        return roomRepository.findByRoomSlug(slug);
    }
}