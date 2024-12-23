package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.QREntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface QRCodeRepository extends JpaRepository<QREntity, Integer> {

    /**
     * Busca un QR generado asociado a un booking ID.
     * 
     * @param bookingId El ID de la reserva.
     * @return Un Optional con la entidad QREntity si existe.
     */
    Optional<QREntity> findByBookingId(Integer bookingId);

    /**
     * Verifica si un QR con estado específico ya existe para un booking ID.
     * 
     * @param bookingId El ID de la reserva.
     * @param status    El estado del QR.
     * @return True si existe, de lo contrario false.
     */
    boolean existsByBookingIdAndStatus(Integer bookingId, QREntity.Status status);
}