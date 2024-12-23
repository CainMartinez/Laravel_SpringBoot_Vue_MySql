package com.QoRders.client.booking.domain.repository;

import com.QoRders.client.booking.domain.entity.ShiftEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ShiftRepository extends JpaRepository<ShiftEntity, Integer> {
    List<ShiftEntity> findByShiftDateAndShiftType(LocalDate shiftDate, ShiftEntity.ShiftType shiftType);
    boolean existsByShiftIdAndIsActiveTrue(Integer shiftId);
    List<ShiftEntity> findByShiftDateBetween(LocalDate startDate, LocalDate endDate);
}