package com.QoRders.client.home.api.assembler;

import com.QoRders.client.home.api.response.RoomResponse;
import com.QoRders.client.home.domain.model.Room;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class RoomAssembler {

    public RoomResponse toResponse(Room room) {
        // Mapeo manual de los campos desde Room a RoomResponse
        RoomResponse response = new RoomResponse();
        response.setUuid(room.getRoomUuid());
        response.setName(room.getRoomName());
        response.setSlug(room.getRoomSlug());
        response.setDescription(room.getDescription());
        response.setTheme(room.getTheme());
        response.setMaxCapacity(room.getMaxCapacity());
        response.setTotalBookings(room.getTotalBookings());
        response.setAverageRating(room.getAverageRating());
        response.setImageUrl(room.getImageUrl());
        response.setIsActive(room.getIsActive());
        response.setNgoId(room.getNgoId());
        return response;
    }

    public List<RoomResponse> toResponseList(List<Room> rooms) {
        return rooms.stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }
}