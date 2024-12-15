package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.ShiftEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ShiftRepository extends JpaRepository<ShiftEntity, Integer> {

    /**
     * Encuentra turnos por fecha y tipo.
     * 
     * @param shiftDate Fecha del turno.
     * @param shiftType Tipo de turno.
     * @return Lista de turnos coincidentes.
     */
    List<ShiftEntity> findByShiftDateAndShiftType(LocalDate shiftDate, ShiftEntity.ShiftType shiftType);

    /**
     * Verifica si existe un turno activo por ID.
     * 
     * @param shiftId ID del turno.
     * @return true si existe, false de lo contrario.
     */
    boolean existsByShiftIdAndIsActiveTrue(Integer shiftId);
}