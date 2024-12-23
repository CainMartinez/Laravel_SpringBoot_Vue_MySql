package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.domain.entity.ShiftEntity;
import com.QoRders.client.booking.domain.repository.ShiftRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ShiftServiceImpl implements ShiftService {

    private final ShiftRepository shiftRepository;

    @Override
    public List<ShiftEntity> getShiftsByMonthAndYear(YearMonth yearMonth) {
        LocalDate startDate = yearMonth.atDay(1);
        LocalDate endDate = yearMonth.atEndOfMonth();

        return shiftRepository.findByShiftDateBetween(startDate, endDate);
    }
}