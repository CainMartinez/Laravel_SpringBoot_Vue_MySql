package com.QoRders.client.booking.domain.service;

import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.booking.api.assembler.BookingAssembler;
import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.response.BookingResponse;
import com.QoRders.client.booking.domain.entity.*;
import com.QoRders.client.booking.domain.repository.*;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;
import com.QoRders.client.home.domain.entity.RoomEntity;
import com.QoRders.client.home.domain.repository.RoomRepository;
import com.QoRders.client.order.domain.entity.OrderEntity;
import com.QoRders.client.order.domain.repository.OrderRepository;

import org.springframework.beans.factory.annotation.Value;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.server.ResponseStatusException;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BookingServiceImpl implements BookingService {

    private static final Logger log = LoggerFactory.getLogger(BookingServiceImpl.class);
    private final BookingRepository bookingRepository;
    private final RoomShiftRepository roomShiftRepository;
    private final ClientRepository clientRepository;
    private final BookingAssembler bookingAssembler;
    private final JwtProvider jwtProvider;
    private final WebClient webClient;
    private final QRCodeService qrCodeService;
    private final QRCodeRepository qrCodeRepository;
    private final TicketRepository ticketRepository;
    private final OrderRepository orderRepository;
    private final RoomRepository roomRepository;
    private final ShiftRepository shiftRepository;
    
    
    @Value("${aes.encryption.key}")
    private String secretKey;
        @Override
    @Transactional
    public BookingResponse createBooking(BookingRequest request, String token) {
        // Obtener el email del token
        String tokenEmail = jwtProvider.parseAccessToken(token);
    
        // Validar que el email del token coincida con el email del request
        if (!tokenEmail.equals(request.getEmail())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "El email introducido no es el de tu cuenta, si lo has olvidado accede a tu perfil para verlo.");
        }
        
        // Verificar si el cliente ya tiene una reserva para este día
        LocalDate requestDate = LocalDate.parse(request.getDate());
        
        boolean existsBookingForSameDay = bookingRepository.existsByClientEmailAndRoomShiftShiftShiftDate(
            tokenEmail, 
            requestDate
        );
        
        if (existsBookingForSameDay) {
            throw new ResponseStatusException(
                HttpStatus.CONFLICT, 
                "Ya tienes una reserva para este día. Solo se permite una reserva por día."
            );
        }
        
        // El resto del código permanece igual...
        // Buscar la sala y el turno
        RoomEntity room = roomRepository.findByRoomSlug(request.getRoom_slug())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "La sala no existe."));
                
        ShiftEntity shift;
        try {
            ShiftEntity.ShiftType shiftType = ShiftEntity.ShiftType.valueOf(request.getShift());
            LocalDate shiftDate = LocalDate.parse(request.getDate());
            
            shift = shiftRepository.findByShiftDateAndShiftType(shiftDate, shiftType)
                    .stream()
                    .findFirst()
                    .orElseGet(() -> {
                        // Si el turno no existe, lo creamos automáticamente
                        ShiftEntity newShift = new ShiftEntity();
                        newShift.setShiftDate(shiftDate);
                        newShift.setShiftType(shiftType);
                        newShift.setIsActive(true);
                        // Generar UUID para shift_uuid
                        newShift.setShiftUuid(UUID.randomUUID().toString());
                        // Inicializar totalRevenue si es necesario
                        newShift.setTotalRevenue(BigDecimal.ZERO);
                        return shiftRepository.save(newShift);
                    });
        } catch (Exception e) {
            log.error("Error al procesar la fecha o el tipo de turno: {}", e.getMessage(), e);
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Error al procesar la fecha o el tipo de turno: " + e.getMessage());
        }
        
        // Buscar o crear el RoomShift
        RoomShiftEntity roomShift = roomShiftRepository
                .findByRoomRoomSlugAndShiftShiftTypeAndShiftShiftDate(
                        request.getRoom_slug(),
                        ShiftEntity.ShiftType.valueOf(request.getShift()),
                        LocalDate.parse(request.getDate()))
                .orElseGet(() -> {
                    // Si no existe el RoomShift, lo creamos automáticamente
                    RoomShiftEntity newRoomShift = new RoomShiftEntity();
                    newRoomShift.setRoom(room);
                    newRoomShift.setShift(shift);
                    newRoomShift.setReservedCapacity(0);
                    newRoomShift.setIsActive(true);
                    // Generar UUID para room_shift_uuid - Este era el campo que faltaba
                    newRoomShift.setRoomShiftUuid(UUID.randomUUID().toString());
                    newRoomShift.setStatus(RoomShiftEntity.RoomShiftStatus.Active);
                    // Inicializar total_revenue si es necesario
                    newRoomShift.setTotalRevenue(BigDecimal.ZERO);
                    return roomShiftRepository.save(newRoomShift);
                });
        
        // Verificar capacidad disponible
        int capacidadDisponible = room.getMaxCapacity() - roomShift.getReservedCapacity();
        if (capacidadDisponible < request.getGuest_count()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No hay suficientes plazas disponibles.");
        }
        
        // Crear la reserva
        BookingEntity booking = new BookingEntity();
        booking.setClient(clientRepository.findByEmail(tokenEmail)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Cliente no encontrado")));
        booking.setRoomShift(roomShift);
        booking.setGuestCount(request.getGuest_count());
        booking.setNotes(request.getNotes());
        booking.setStatus(BookingEntity.Status.Pending);
        Date bookingDate = Date.valueOf(LocalDate.parse(request.getDate()));
        booking.setBookingDate(bookingDate);
        booking = bookingRepository.save(booking);

        // -------- Deprecated ------------

        // Map<String, Object> bookingData = new HashMap<>();
        // bookingData.put("bookingId", booking.getId());
        // bookingData.put("email", tokenEmail);
        // bookingData.put("roomShift", roomShift);
        // bookingData.put("guestCount", request.getGuest_count());
        // bookingData.put("status", booking.getStatus().toString());
        // bookingData.put("token", token);
        // redisService.save(redisKey, bookingData, 3600)
        // Buscar un camarero disponible
        // WaiterEntity waiter = waiterRepository.findAllByIsActiveTrue().stream()
        //         .filter(w -> w.getShiftDisponibility() == WaiterEntity.ShiftDisponibility.Flexible ||
        //                 w.getShiftDisponibility().name().equals(roomShift.getShift().getShiftType().name()))
        //         .findFirst()
        //         .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No hay camareros disponibles"));
        // BookingWaiterEntity bookingWaiter = new BookingWaiterEntity();
        // bookingWaiter.setBooking(booking);
        // bookingWaiter.setWaiter(waiter);
        // bookingWaiter.setRole(BookingWaiterEntity.Role.Lead);
        // bookingWaiter.setAssignedAt(LocalDateTime.now());
        // bookingWaiterRepository.save(bookingWaiter);

        roomShift.setReservedCapacity(roomShift.getReservedCapacity() + request.getGuest_count());
        roomShiftRepository.save(roomShift);

        booking.setStatus(BookingEntity.Status.Confirmed);
        bookingRepository.save(booking);
        log.info("Entrando al service QR");

        String qrUrl = qrCodeService.generateQRCodeUrl(booking.getId(), tokenEmail, secretKey);
        System.out.println("QR URL Generada: " + qrUrl);
        log.info("QR URL Generada: " + qrUrl);
        // Guardar el QR en la base de datos
        QREntity qrEntity = new QREntity();
        qrEntity.setBookingId(booking.getId());
        qrEntity.setUrl(qrUrl);
        qrEntity.setStatus(QREntity.Status.Generated);
        qrCodeRepository.save(qrEntity);
        // Nueva lógica para enviar OTP cuando la reserva está confirmada
        String shiftOtp = request.getShift();
        String translatedShift;
        
        if ("Dinner".equals(shiftOtp)) {
            translatedShift = "cena";
        } else if ("Lunch".equals(shiftOtp)) {
            translatedShift = "comida";
        } else {
            translatedShift = shiftOtp;
        }
        
        String otpMessage = request.getDate() + " turno de " + translatedShift;
        sendOtpMessage("+34" + request.getPhoneNumber(), otpMessage);
        return bookingAssembler.toResponse(booking, request.getPhoneNumber());
    }

    // Método para enviar el mensaje OTP
    private void sendOtpMessage(String phoneNumber, String otp) {
        Map<String, String> otpRequest = new HashMap<>();
        otpRequest.put("phone", phoneNumber);
        otpRequest.put("otp", otp);

        webClient.post()
                .uri("http://host.docker.internal:3001/api/otp/send")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(otpRequest)
                .retrieve()
                .toBodilessEntity()
                .doOnError(error -> {
                    throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error enviando el mensaje OTP");
                })
                .subscribe();
    }

    @Override
    @Transactional
    public String finalizeBookingPayment(Integer bookingId, String paymentMethod) {
        // Verificar si existe el booking
        BookingEntity booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No se encuentra la reserva."));

        // Verificar si hay tickets asociados
        TicketEntity ticket = booking.getTickets().stream()
                .filter(t -> t.getPaymentStatus() != TicketEntity.PaymentStatus.Paid)
                .findFirst()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Esta reserva no tiene tickets pendientes de pago."));

        String clientSecret = null;

        if ("card".equalsIgnoreCase(paymentMethod)) {
            String stripeUrl = "http://host.docker.internal:3002/api/payment";
            WebClient webClient = WebClient.create();

            Map<String, Object> request = Map.of(
                    "bookingId", bookingId,
                    "totalAmount", ticket.getTotalAmount() // Usar el monto del ticket
            );

            @SuppressWarnings("unchecked")
            Map<String, String> stripeResponse = webClient.post()
                    .uri(stripeUrl)
                    .header("Content-Type", "application/json")
                    .bodyValue(request)
                    .retrieve()
                    .bodyToMono(Map.class)
                    .block();

            if (stripeResponse == null || !"Success".equalsIgnoreCase((String) stripeResponse.get("status"))) {
                throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Payment failed");
            }

            clientSecret = stripeResponse.get("clientSecret");
            ticket.setPaymentStatus(TicketEntity.PaymentStatus.Paid); // Marcar el ticket como pagado
        }

        // Marcar el booking como completado si aplica
        booking.setStatus(BookingEntity.Status.Completed);
        bookingRepository.save(booking);

        ClientEntity client = booking.getClient();
        client.setIs_seated(false); // Cambiar is_seated a false
        clientRepository.save(client);

        return clientSecret; // Devuelve el clientSecret si aplica
    }

    @Override
    @Transactional(readOnly = true)
    public BookingEntity getBookingById(Integer bookingId) {
        return bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));
    }

    @Override
    @Transactional
    public TicketEntity generateTicket(Integer bookingId) {
        // Verificar que el booking exista
        bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Booking not found"));

        // Verificar que todas las órdenes estén en estado Delivered
        List<OrderEntity> nonDeliveredOrders = orderRepository.findByBookingIdAndOrderStatus(
                bookingId, OrderEntity.OrderStatus.Delivered
        );

        if (nonDeliveredOrders.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "No se han efectuado pedidos o todavía hay alguno por entregar.");
        }

        // Sumar el total de todas las órdenes asociadas al booking
        BigDecimal totalAmount = orderRepository.findByBookingId(bookingId).stream()
                .map(OrderEntity::getTotalAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Crear y guardar el ticket
        TicketEntity ticket = new TicketEntity();
        ticket.setBookingId(bookingId);
        ticket.setTotalAmount(totalAmount);
        ticket.setAmountToPay(totalAmount);
        ticket.setDonatedAmount(BigDecimal.ZERO);
        ticket.setPaymentStatus(TicketEntity.PaymentStatus.Pending);
        ticket.setTicketUuid(UUID.randomUUID().toString());
        ticketRepository.save(ticket);
        return ticket;
    }
}