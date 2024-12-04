package com.QoRders.client.client.api.assembler;

import org.springframework.stereotype.Component;

import com.QoRders.client.client.api.request.ClientUpdateRequest;
import com.QoRders.client.client.api.response.ClientResponse;
import com.QoRders.client.client.domain.entity.ClientEntity;

import java.time.format.DateTimeFormatter;

@Component
public class ClientAssembler {

    @SuppressWarnings("unused")
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public ClientResponse toResponse(ClientEntity customer) {
        return ClientResponse.builder()
                .uuid(customer.getCustomerUuid())
                .firstName(customer.getFirstName())
                .lastName(customer.getLastName())
                .email(customer.getEmail())
                .phoneNumber(customer.getPhoneNumber())
                .bio(customer.getBio())
                .avatarUrl(customer.getAvatarUrl())
                .hasCoupon(customer.getHasCoupon())
                .loyaltyPoints(customer.getLoyaltyPoints())
                .isActive(customer.getIsActive())
                .createdAt(customer.getCreatedAt() != null ? customer.getCreatedAt().toString() : null)
                .updatedAt(customer.getUpdatedAt() != null ? customer.getUpdatedAt().toString() : null)
                .build();
    }

    public void copyToEntity(ClientUpdateRequest clientUpdateDto, ClientEntity customer) {
        if (clientUpdateDto.getFirstName() != null) {
            customer.setFirstName(clientUpdateDto.getFirstName());
        }
        if (clientUpdateDto.getLastName() != null) {
            customer.setLastName(clientUpdateDto.getLastName());
        }
        if (clientUpdateDto.getBio() != null) {
            customer.setBio(clientUpdateDto.getBio());
        }
        if (clientUpdateDto.getAvatarUrl() != null) {
            customer.setAvatarUrl(clientUpdateDto.getAvatarUrl());
        }
        if (clientUpdateDto.getPhoneNumber() != null) {
            customer.setPhoneNumber(clientUpdateDto.getPhoneNumber());
        }
    }
}