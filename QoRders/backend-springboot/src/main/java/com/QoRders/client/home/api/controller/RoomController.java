package com.QoRders.client.home.api.controller;

import com.QoRders.client.home.api.assembler.RoomAssembler;
import com.QoRders.client.home.api.response.RoomResponse;
import com.QoRders.client.home.domain.model.Room;
import com.QoRders.client.home.domain.service.RoomService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    private final RoomService roomService;
    private final RoomAssembler roomAssembler;

    public RoomController(RoomService roomService, RoomAssembler roomAssembler) {
        this.roomService = roomService;
        this.roomAssembler = roomAssembler;
    }

    @GetMapping
    public ResponseEntity<List<RoomResponse>> listAll() {
        List<Room> rooms = roomService.listAll();
        System.out.println("Rooms from service: " + rooms); // Log adicional
        List<RoomResponse> response = roomAssembler.toResponseList(rooms);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{slug}")
    public ResponseEntity<RoomResponse> listOneBySlug(@PathVariable String slug) {
        return roomService.listOneBySlug(slug)
                .map(roomAssembler::toResponse)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}