package com.QoRders.client.home.domain.service;

import com.QoRders.client.home.api.dto.RoomDto;

import java.util.List;
import java.util.Optional;

public interface RoomService {
    List<RoomDto> listAll();
    Optional<RoomDto> listOneBySlug(String slug);
}