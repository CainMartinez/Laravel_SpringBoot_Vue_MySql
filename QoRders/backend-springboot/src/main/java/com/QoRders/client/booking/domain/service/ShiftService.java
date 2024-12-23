package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.api.response.ShiftWithRoomShiftsDto;

import java.time.YearMonth;
import java.util.List;

public interface ShiftService {
    List<ShiftWithRoomShiftsDto> getShiftsWithRoomShiftsByMonthAndYear(YearMonth yearMonth);
}