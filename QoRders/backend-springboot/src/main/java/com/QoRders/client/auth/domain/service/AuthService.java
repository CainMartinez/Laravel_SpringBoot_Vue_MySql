package com.QoRders.client.auth.domain.service;

import com.QoRders.client.auth.api.request.LoginRequest;
import com.QoRders.client.auth.api.request.RegisterRequest;
import com.QoRders.client.auth.api.response.AuthResponse;

public interface AuthService {
    void register(RegisterRequest registerRequest);
    String login(LoginRequest loginRequest);
    void logout(String accessToken);
    AuthResponse refreshAccessToken(String accessToken);
}