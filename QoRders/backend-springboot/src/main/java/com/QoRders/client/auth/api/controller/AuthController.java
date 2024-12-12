package com.QoRders.client.auth.api.controller;

import com.QoRders.client.auth.api.request.LoginRequest;
import com.QoRders.client.auth.api.request.RegisterRequest;
import com.QoRders.client.auth.api.response.AuthResponse;
import com.QoRders.client.auth.domain.service.AuthService;

import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:8085")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> register(@Valid @RequestBody RegisterRequest registerDto) {
        authService.register(registerDto);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Client registered successfully.");
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@Valid @RequestBody LoginRequest loginDto) {
        var authResponse = authService.login(loginDto);
        return ResponseEntity.ok(authResponse);
    }

    @PostMapping("/client/logout")
    public ResponseEntity<Map<String, String>> logout(@RequestHeader("Authorization") String accessToken) {
        authService.logout(accessToken);
        Map<String, String> response = new HashMap<>();
        response.put("message", "Client logged out successfully.");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refreshAccessToken(@RequestHeader("Authorization") String accessToken) {
        var authResponse = authService.refreshAccessToken(accessToken);
        return ResponseEntity.ok(authResponse);
    }
}