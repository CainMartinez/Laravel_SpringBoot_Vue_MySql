package com.QoRders.client.booking.api.response;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@AllArgsConstructor
public class ShiftWithRoomShiftsDto {

    private Integer shiftId;
    private LocalDate shiftDate;
    private String shiftType;
    private BigDecimal totalRevenue;
    private Boolean isActive;
    private List<RoomShiftDto> roomShifts;

    @Getter
    @Setter
    @AllArgsConstructor
    public static class RoomShiftDto {
        private Integer roomShiftId;
        private String roomShiftUuid;
        private String roomName;
        private Integer reservedCapacity;
        private BigDecimal totalRevenue;
        private String status;
    }
}