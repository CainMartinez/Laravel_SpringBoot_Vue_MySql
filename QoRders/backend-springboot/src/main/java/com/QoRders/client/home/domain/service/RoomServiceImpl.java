package com.QoRders.client.home.domain.service;

import com.QoRders.client.home.api.assembler.RoomAssembler;
import com.QoRders.client.home.api.dto.RoomDto;
import com.QoRders.client.home.domain.model.Room;
import com.QoRders.client.home.domain.repository.RoomRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;
    private final RoomAssembler roomAssembler;

    public RoomServiceImpl(RoomRepository roomRepository, RoomAssembler roomAssembler) {
        this.roomRepository = roomRepository;
        this.roomAssembler = roomAssembler;
    }

    @Override
    public List<RoomDto> listAll() {
        List<Room> rooms = roomRepository.findAll();
        return rooms.stream()
                .map(roomAssembler::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<RoomDto> listOneBySlug(String slug) {
        return roomRepository.findByRoomSlug(slug)
                .map(roomAssembler::toDto);
    }
}