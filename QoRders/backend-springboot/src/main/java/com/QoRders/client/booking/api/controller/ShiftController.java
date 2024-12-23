package com.QoRders.client.booking.api.controller;

import com.QoRders.client.booking.domain.entity.ShiftEntity;
import com.QoRders.client.booking.domain.service.ShiftService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.YearMonth;
import java.util.List;

@RestController
@RequestMapping("/api/shifts")
@RequiredArgsConstructor
public class ShiftController {

    private final ShiftService shiftService;

    /**
     * Obtiene todas las shifts para un mes y año específicos.
     *
     * @param yearMonth Mes y año en formato YYYY-MM.
     * @return Lista de shifts dentro del mes especificado.
     */
    @GetMapping
    public ResponseEntity<List<ShiftEntity>> getShiftsByMonthAndYear(
            @RequestParam("yearMonth") @DateTimeFormat(pattern = "yyyy-MM") YearMonth yearMonth) {
        List<ShiftEntity> shifts = shiftService.getShiftsByMonthAndYear(yearMonth);
        return ResponseEntity.ok(shifts);
    }
}