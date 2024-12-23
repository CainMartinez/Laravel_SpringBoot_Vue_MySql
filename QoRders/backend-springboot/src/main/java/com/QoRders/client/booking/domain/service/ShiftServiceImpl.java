package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.api.response.ShiftWithRoomShiftsDto;
import com.QoRders.client.booking.domain.entity.ShiftEntity;
import com.QoRders.client.booking.domain.repository.ShiftRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ShiftServiceImpl implements ShiftService {

    private final ShiftRepository shiftRepository;

    @Override
    public List<ShiftWithRoomShiftsDto> getShiftsWithRoomShiftsByMonthAndYear(YearMonth yearMonth) {
        // Calcular las fechas de inicio y fin del mes
        LocalDate startDate = yearMonth.atDay(1);
        LocalDate endDate = yearMonth.atEndOfMonth();

        // Buscar shifts usando el repositorio
        List<ShiftEntity> shifts = shiftRepository.findByShiftDateBetween(startDate, endDate);

        // Mapear los resultados a DTOs
        return shifts.stream().map(shift -> new ShiftWithRoomShiftsDto(
                shift.getShiftId(),
                shift.getShiftDate(),
                shift.getShiftType().name(),
                shift.getTotalRevenue(),
                shift.getIsActive(),
                shift.getRoomShifts().stream().map(roomShift -> new ShiftWithRoomShiftsDto.RoomShiftDto(
                        roomShift.getRoomShiftId(),
                        roomShift.getRoomShiftUuid(),
                        roomShift.getRoom().getRoomName(),
                        roomShift.getReservedCapacity(),
                        roomShift.getTotalRevenue(),
                        roomShift.getStatus().name()
                )).collect(Collectors.toList())
        )).collect(Collectors.toList());
    }
}