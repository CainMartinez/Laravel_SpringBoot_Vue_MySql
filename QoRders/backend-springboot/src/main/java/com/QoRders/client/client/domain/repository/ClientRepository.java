package com.QoRders.client.client.domain.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.QoRders.client.client.domain.entity.ClientEntity;

import java.util.Optional;

@Repository
public interface ClientRepository extends JpaRepository<ClientEntity, Integer> {

    /**
     * Encuentra un usuario por su email.
     * 
     * @param email El email del usuario.
     * @return Un Optional con el usuario si existe.
     */
    Optional<ClientEntity> findByEmail(String email);

    /**
     * Encuentra un usuario por su UUID.
     * 
     * @param uuid El UUID del usuario.
     * @return Un Optional con el usuario si existe.
     */
    Optional<ClientEntity> findByCustomerUuid(String uuid);

    /**
     * Verifica si existe un usuario con un email específico.
     * 
     * @param email El email a verificar.
     * @return true si existe, de lo contrario false.
     */
    boolean existsByEmail(String email);
}