package com.QoRders.client.booking.domain.service;

import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.booking.api.assembler.BookingAssembler;
import com.QoRders.client.booking.api.request.BookingRequest;
import com.QoRders.client.booking.api.response.BookingResponse;
import com.QoRders.client.booking.domain.entity.*;
import com.QoRders.client.booking.domain.repository.*;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;
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

        // Verificar si ya existe una reserva para el mismo día
        boolean existsBooking = bookingRepository.existsByClientEmailAndRoomShiftShiftShiftDate(
            tokenEmail,
            LocalDate.parse(request.getDate())
        );

        if (existsBooking) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Ya tienes una reserva para este día.");
        }
        // Buscar el turno solicitado usando room_slug
        RoomShiftEntity roomShift = roomShiftRepository.findByRoomRoomSlugAndShiftShiftTypeAndShiftShiftDate(
        request.getRoom_slug(),
        ShiftEntity.ShiftType.valueOf(request.getShift()),
        LocalDate.parse(request.getDate()))
        .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "No hay turnos disponibles para este día."));


        if (roomShift.getReservedCapacity() + request.getGuest_count() > roomShift.getRoom().getMaxCapacity()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "No hay capacidad disponible para este turno.");
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
        String shift = request.getShift();
        String translatedShift;
        
        if ("Dinner".equals(shift)) {
            translatedShift = "cena";
        } else if ("Lunch".equals(shift)) {
            translatedShift = "comida";
        } else {
            translatedShift = shift;
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