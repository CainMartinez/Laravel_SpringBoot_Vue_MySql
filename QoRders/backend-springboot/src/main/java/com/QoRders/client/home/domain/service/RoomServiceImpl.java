package com.QoRders.client.home.domain.service;

import com.QoRders.client.home.api.assembler.RoomAssembler;
import com.QoRders.client.home.api.dto.RoomDto;
import com.QoRders.client.home.domain.entity.RoomEntity;
import com.QoRders.client.home.domain.repository.RoomRepository;
import com.QoRders.client.redis.RedisService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class RoomServiceImpl implements RoomService {

    private final RoomRepository roomRepository;
    private final RoomAssembler roomAssembler;
    private final RedisService redisService;

    private static final long ROOM_CACHE_TTL = 21600; // 6 hours in seconds

    public RoomServiceImpl(RoomRepository roomRepository, RoomAssembler roomAssembler, RedisService redisService) {
        this.roomRepository = roomRepository;
        this.roomAssembler = roomAssembler;
        this.redisService = redisService;
    }

    @Override
    public List<RoomDto> listAll() {
        String redisKey = "room:listAll";

        // Intentar obtener la lista desde Redis
        @SuppressWarnings("unchecked")
        List<RoomDto> cachedRooms = (List<RoomDto>) redisService.get(redisKey);
        if (cachedRooms != null) {
            return cachedRooms;
        }

        // Si no está en Redis, buscar en la base de datos
        List<RoomEntity> rooms = roomRepository.findAll();
        List<RoomDto> roomDtos = rooms.stream()
                .map(roomAssembler::toDto)
                .collect(Collectors.toList());

        // Guardar la lista en Redis con TTL
        redisService.save(redisKey, roomDtos, ROOM_CACHE_TTL);

        return roomDtos;
    }

    @Override
    public Optional<RoomDto> listOneBySlug(String slug) {
        String redisKey = "room:slug:" + slug;

        // Intentar obtener la sala desde Redis
        RoomDto cachedRoom = (RoomDto) redisService.get(redisKey);
        if (cachedRoom != null) {
            return Optional.of(cachedRoom);
        }

        // Buscar en la base de datos si no está en Redis
        Optional<RoomDto> roomDto = roomRepository.findByRoomSlug(slug)
                .map(roomAssembler::toDto);

        roomDto.ifPresent(room -> {
            // Guardar en Redis con TTL
            redisService.save(redisKey, room, ROOM_CACHE_TTL);
        });

        return roomDto;
    }
}