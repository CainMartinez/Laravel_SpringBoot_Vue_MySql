package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.domain.entity.ShiftEntity;

import java.time.YearMonth;
import java.util.List;

public interface ShiftService {
    List<ShiftEntity> getShiftsByMonthAndYear(YearMonth yearMonth);
}