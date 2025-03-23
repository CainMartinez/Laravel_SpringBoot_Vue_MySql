package com.QoRders.client.client.api.assembler;

import com.QoRders.client.client.api.request.ClientUpdateRequest;
import com.QoRders.client.client.domain.entity.ClientEntity;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class ClientAssembler {

    /**
     * Construye una respuesta a partir de los datos almacenados en Redis.
     *
     * @param redisData Datos recuperados de Redis.
     * @return Mapa de respuesta con mensaje, cliente y token.
     */
    public Map<String, Object> toResponse(Map<String, Object> redisData) {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Client data retrieved successfully");
        response.put("client", redisData.get("client"));
        response.put("token", redisData.get("token"));
        return response;
    }

    /**
     * Copia los datos de un `ClientUpdateRequest` al objeto `ClientEntity`.
     *
     * @param clientUpdateRequest Objeto que contiene los datos a actualizar.
     * @param client              Entidad del cliente que se actualizará.
     */
    public void copyToEntity(ClientUpdateRequest clientUpdateRequest, ClientEntity client) {
        if (clientUpdateRequest.getFirstName() != null) {
            client.setFirstName(clientUpdateRequest.getFirstName());
        }
        if (clientUpdateRequest.getLastName() != null) {
            client.setLastName(clientUpdateRequest.getLastName());
        }
        if (clientUpdateRequest.getBio() != null) {
            client.setBio(clientUpdateRequest.getBio());
        }
        if (clientUpdateRequest.getAvatarUrl() != null) {
            client.setAvatar_url(clientUpdateRequest.getAvatarUrl());
        }
        if (clientUpdateRequest.getPhoneNumber() != null) {
            client.setPhone_number(clientUpdateRequest.getPhoneNumber());
        }
        if (clientUpdateRequest.getAge() != null) {
            client.setAge(clientUpdateRequest.getAge());
        }
        if (clientUpdateRequest.getAddress() != null) {
            client.setAddress(clientUpdateRequest.getAddress());
        }
        client.setHas_coupon(clientUpdateRequest.isHas_coupon());
    }
}