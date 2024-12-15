package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.WaiterEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WaiterRepository extends JpaRepository<WaiterEntity, Integer> {

    /**
     * Busca el primer camarero disponible para un turno específico.
     * 
     * @param shiftDisponibility Disponibilidad del turno (Lunch o Dinner).
     * @return Un Optional con el camarero si existe.
     */
    Optional<WaiterEntity> findFirstByShiftDisponibilityAndIsActiveTrue(WaiterEntity.ShiftDisponibility shiftDisponibility);

    /**
     * Obtiene todos los camareros activos.
     * 
     * @return Una lista de camareros activos.
     */
    List<WaiterEntity> findAllByIsActiveTrue();
}