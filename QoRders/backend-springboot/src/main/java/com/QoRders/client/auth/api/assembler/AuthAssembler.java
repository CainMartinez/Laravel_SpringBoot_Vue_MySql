package com.QoRders.client.auth.api.assembler;

import com.QoRders.client.auth.api.response.AuthResponse;
import com.QoRders.client.client.domain.entity.ClientEntity;

import org.springframework.stereotype.Component;

@Component
public class AuthAssembler {

    public AuthResponse toAuthResponse(ClientEntity user, String accessToken) {
        return AuthResponse.builder()
                .email(user.getEmail())
                .firstName(user.getFirstName())
                .lastName(user.getLastName())
                .token(accessToken)
                .build();
    }

    public String toTokenResponse(String accessToken) {
        return accessToken;
    }
}