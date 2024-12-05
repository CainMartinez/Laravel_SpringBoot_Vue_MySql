package com.QoRders.client.auth.api.controller;

import com.QoRders.client.auth.api.request.LoginRequest;
import com.QoRders.client.auth.api.request.RegisterRequest;
import com.QoRders.client.auth.api.response.AuthResponse;
import com.QoRders.client.auth.domain.service.AuthService;
import lombok.RequiredArgsConstructor;
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
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody RegisterRequest registerDto) {
        var authResponse = authService.register(registerDto);
        return ResponseEntity.ok(authResponse);
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody LoginRequest loginDto) {
        var authResponse = authService.login(loginDto);
        return ResponseEntity.ok(authResponse);
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader("Authorization") String accessToken) {
        authService.logout(accessToken);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refreshAccessToken(@RequestHeader("Authorization") String accessToken) {
        var authResponse = authService.refreshAccessToken(accessToken);
        return ResponseEntity.ok(authResponse);
    }
}