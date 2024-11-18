package com.QoRders.client.home.api.assembler;

import com.QoRders.client.home.api.dto.RoomDto;
import com.QoRders.client.home.domain.model.Room;
import org.springframework.stereotype.Component;

@Component
public class RoomAssembler {

    public RoomDto toDto(Room room) {
        RoomDto dto = new RoomDto();
        dto.setUuid(room.getRoomUuid());
        dto.setName(room.getRoomName());
        dto.setSlug(room.getRoomSlug());
        dto.setDescription(room.getDescription());
        dto.setTheme(room.getTheme());
        dto.setMaxCapacity(room.getMaxCapacity());
        dto.setTotalBookings(room.getTotalBookings());
        dto.setAverageRating(room.getAverageRating());
        dto.setImageUrl(room.getImageUrl());
        dto.setIsActive(room.getIsActive());
        dto.setNgoId(room.getNgoId());
        return dto;
    }
}