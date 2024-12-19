package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.RoomShiftEntity;
import com.QoRders.client.booking.domain.entity.ShiftEntity;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface RoomShiftRepository extends JpaRepository<RoomShiftEntity, Integer> {

    /**
     * Busca un turno por nombre de sala, tipo de turno y fecha.
     * 
     * @param roomSlug Nombre de la sala.
     * @param shiftType Tipo de turno (almuerzo o cena).
     * @param shiftDate Fecha del turno.
     * @return Un Optional con el turno si existe.
     */
    Optional<RoomShiftEntity> findByRoomRoomSlugAndShiftShiftTypeAndShiftShiftDate(
            String roomSlug,
            ShiftEntity.ShiftType shiftType,
            LocalDate shiftDate);
}