package com.QoRders.client.home.api.assembler;

import com.QoRders.client.home.api.dto.RoomDto;
import com.QoRders.client.home.api.response.RoomResponse;
import com.QoRders.client.home.domain.entity.RoomEntity;
import org.springframework.stereotype.Component;

@Component
public class RoomAssembler {

    public RoomDto toDto(RoomEntity room) {
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
        if (room.getNgo() != null) {
            dto.setNgoId(room.getNgo().getNgoId());
        }
        return dto;
    }

    public RoomResponse toResponse(RoomEntity room) {
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
        response.setNgoId(room.getNgo() != null ? room.getNgo().getNgoId() : null);
        return response;
    }
}