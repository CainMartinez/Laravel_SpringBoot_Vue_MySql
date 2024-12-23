package com.QoRders.client.booking.api.controller;

import com.QoRders.client.booking.api.response.ShiftWithRoomShiftsDto;
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

    @GetMapping
    public ResponseEntity<List<ShiftWithRoomShiftsDto>> getShiftsByMonthAndYear(
            @RequestParam("yearMonth") @DateTimeFormat(pattern = "yyyy-MM") YearMonth yearMonth) {
        List<ShiftWithRoomShiftsDto> shifts = shiftService.getShiftsWithRoomShiftsByMonthAndYear(yearMonth);
        return ResponseEntity.ok(shifts);
    }
}