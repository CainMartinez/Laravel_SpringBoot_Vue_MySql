package com.QoRders.client.booking.domain.service;

import com.QoRders.client.booking.api.assembler.BookingAssembler;
import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.response.BookingResponse;
import com.QoRders.client.booking.domain.entity.BookingEntity;
import com.QoRders.client.booking.domain.entity.BookingWaiterEntity;
import com.QoRders.client.booking.domain.entity.RoomShiftEntity;
import com.QoRders.client.booking.domain.entity.ShiftEntity;
import com.QoRders.client.booking.domain.entity.WaiterEntity;
import com.QoRders.client.booking.domain.repository.BookingRepository;
import com.QoRders.client.booking.domain.repository.BookingWaiterRepository;
import com.QoRders.client.booking.domain.repository.RoomShiftRepository;
import com.QoRders.client.booking.domain.repository.WaiterRepository;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;

import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;


@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {

    private final BookingRepository bookingRepository;
    private final RoomShiftRepository roomShiftRepository;
    private final WaiterRepository waiterRepository;
    private final BookingWaiterRepository bookingWaiterRepository;
    private final ClientRepository clientRepository;
    private final BookingAssembler bookingAssembler;

    @Override
    @Transactional
    public BookingResponse createBooking(BookingRequest request) {
        // Verificar si el cliente ya tiene una reserva pendiente
        ClientEntity client = clientRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente no encontrado"));

        if (bookingRepository.existsByClientCustomerIdAndStatus(client.getCustomerId(), BookingEntity.Status.Pending)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya tienes una reserva pendiente");
        }

        // Buscar el turno solicitado
        RoomShiftEntity roomShift = roomShiftRepository.findByRoomRoomNameAndShiftShiftTypeAndShiftShiftDate(
                request.getRoom(),
                ShiftEntity.ShiftType.valueOf(request.getShift()),
                LocalDate.parse(request.getDate()))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Turno no encontrado"));

        // Verificar capacidad del turno
        if (roomShift.getReservedCapacity() + request.getGuest_count() > roomShift.getRoom().getMaxCapacity()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No hay capacidad disponible para este turno");
        }

        // Buscar un camarero disponible
        WaiterEntity waiter = waiterRepository.findAllByIsActiveTrue().stream()
                .filter(w -> w.getShiftDisponibility() == WaiterEntity.ShiftDisponibility.Flexible ||
                        w.getShiftDisponibility().name().equals(roomShift.getShift().getShiftType().name()))
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No hay camareros disponibles"));

        // Crear la reserva
        BookingEntity booking = new BookingEntity();
        booking.setClient(client);
        booking.setRoomShift(roomShift);
        booking.setGuestCount(request.getGuest_count());
        booking.setNotes("Reserva pendiente de confirmación");
        booking.setStatus(BookingEntity.Status.Pending);

        // Guardar la reserva
        booking = bookingRepository.save(booking);

        // Crear la relación en BookingWaiterEntity
        BookingWaiterEntity bookingWaiter = new BookingWaiterEntity();
        bookingWaiter.setBooking(booking);
        bookingWaiter.setWaiter(waiter);
        bookingWaiter.setRole(BookingWaiterEntity.Role.Lead);
        bookingWaiter.setAssignedAt(LocalDateTime.now());

        // Guardar en la tabla Booking_Waiter
        bookingWaiterRepository.save(bookingWaiter);

        // Actualizar capacidad del turno
        roomShift.setReservedCapacity(roomShift.getReservedCapacity() + request.getGuest_count());
        roomShiftRepository.save(roomShift);

        // Actualizar la reserva a confirmada
        booking.setStatus(BookingEntity.Status.Confirmed);
        bookingRepository.save(booking);

        // Convertir la reserva a BookingResponse y retornarla
        return bookingAssembler.toResponse(booking, request.getPhoneNumber());
    }
}
