package com.QoRders.client.home.api.controller;

import com.QoRders.client.home.api.dto.RoomDto;
import com.QoRders.client.home.domain.service.RoomService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/rooms")
@CrossOrigin(origins = "http://localhost:5200")
public class RoomController {

    private final RoomService roomService;

    public RoomController(RoomService roomService) {
        this.roomService = roomService;
    }

    @GetMapping
    public ResponseEntity<List<RoomDto>> listAll() {
        List<RoomDto> rooms = roomService.listAll();
        return ResponseEntity.ok(rooms);
    }

    @GetMapping("/{slug}")
    public ResponseEntity<?> listOneBySlug(@PathVariable String slug) {
        Optional<RoomDto> room = roomService.listOneBySlug(slug);
        if (room.isPresent()) {
            return ResponseEntity.ok(room.get());
        } else {
            return ResponseEntity.status(404).body(String.format("Room with slug '%s' not found", slug));
        }
    }
}