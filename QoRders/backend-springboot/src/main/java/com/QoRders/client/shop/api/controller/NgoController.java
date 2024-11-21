package com.QoRders.client.shop.api.controller;

import com.QoRders.client.shop.api.dto.NgoDto;
import com.QoRders.client.shop.domain.service.NgoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/ngos")
@CrossOrigin(origins = "http://localhost:8085")
public class NgoController {

    private final NgoService ngoService;

    public NgoController(NgoService ngoService) {
        this.ngoService = ngoService;
    }

    @GetMapping
    public ResponseEntity<List<NgoDto>> listAll() {
        List<NgoDto> ngos = ngoService.listAll();
        return ResponseEntity.ok(ngos);
    }

    @GetMapping("/{slug}")
    public ResponseEntity<?> listOneBySlug(@PathVariable String slug) {
        Optional<NgoDto> ngo = ngoService.listOneBySlug(slug);
        if (ngo.isPresent()) {
            return ResponseEntity.ok(ngo.get());
        } else {
            return ResponseEntity.status(404).body(String.format("NGO with slug '%s' not found", slug));
        }
    }
}