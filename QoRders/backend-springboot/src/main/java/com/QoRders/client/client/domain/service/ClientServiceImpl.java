package com.QoRders.client.client.domain.service;

import com.QoRders.client.auth.api.security.utils.AuthUtils;
import com.QoRders.client.booking.api.request.TicketDto;
import com.QoRders.client.booking.api.response.BookingWithTicketsResponse;
import com.QoRders.client.booking.domain.entity.BookingEntity;
import com.QoRders.client.booking.domain.repository.BookingRepository;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.exceptions.ClientNotAuthenticatedException;
import com.QoRders.client.client.domain.exceptions.ClientNotFoundException;
import com.QoRders.client.client.domain.repository.ClientRepository;
import com.QoRders.client.redis.RedisService;
import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClientServiceImpl implements ClientService {

    private final ClientRepository clientRepository;
    private final Argon2PasswordEncoder passwordEncoder;
    private final AuthUtils authUtils;
    private final RedisService redisService;
    private final JwtProvider jwtProvider;
    private final BookingRepository bookingRepository;

    @Override
    public Map<String, Object> getProfile(String token) {
        // Extraer el email desde el token
        String email = extractEmailFromToken(token);

        // Generar la clave de Redis
        String redisKey = "springboot_logged_client_" + email;

        // Intentar obtener los datos de Redis
        @SuppressWarnings("unchecked")
        Map<String, Object> redisData = (Map<String, Object>) redisService.get(redisKey);

        if (redisData == null) {
            // Si no hay datos en Redis, buscar en la base de datos
            ClientEntity client = clientRepository.findByEmail(email)
                    .orElseThrow(() -> new ClientNotFoundException("Client not found for email: " + email));

            // Convertir los datos del cliente en un mapa para devolverlo en el mismo formato
            redisData = new HashMap<>();
            redisData.put("client", client);
            redisData.put("token", token);

            // Guardar los datos en Redis para futuras consultas
            long ttl = jwtProvider.getAccessTokenExpirationInSeconds();
            redisService.save(redisKey, redisData, ttl);
        }

        // Retornar los datos sin @class
        return cleanRedisData(redisData);
    }

    /**
     * Elimina las referencias a @class del mapa de Redis.
     *
     * @param redisData Datos obtenidos desde Redis.
     * @return Datos limpios sin referencias a @class.
     */
    @SuppressWarnings("unchecked")
    private Map<String, Object> cleanRedisData(Map<String, Object> redisData) {
        // Crear un mapa limpio
        Map<String, Object> cleanData = new HashMap<>();

        redisData.forEach((key, value) -> {
            if (value instanceof Map) {
                cleanData.put(key, cleanRedisData((Map<String, Object>) value)); // Limpiar mapas anidados
            } else {
                cleanData.put(key, value);
            }
        });

        return cleanData;
    }

    /**
     * Extrae el email del token JWT.
     *
     * @param token El token JWT.
     * @return El email extraído del token.
     */
    private String extractEmailFromToken(String token) {
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }
        return jwtProvider.parseAccessToken(token);
    }

    @Override
    @Transactional
    public Map<String, Object> updateProfile(ClientEntity client, String token) {
        // Actualizar el cliente en la base de datos
        var updatedClient = clientRepository.save(client);

        // Sobrescribir los datos en Redis
        String redisKey = "springboot_logged_client_" + client.getEmail();
        Map<String, Object> redisData = new HashMap<>();
        redisData.put("client", updatedClient);
        redisData.put("token", token);
        long ttl = jwtProvider.getAccessTokenExpirationInSeconds();

        redisService.save(redisKey, redisData, ttl);

        // Retornar los datos actualizados
        return redisData;
    }

    @Override
    public ClientEntity registerClient(ClientEntity client) {
        String hashedPassword = passwordEncoder.encode(client.getPassword());
        client.setPassword(hashedPassword);
        return clientRepository.save(client);
    }

    @Override
    public Optional<ClientEntity> findClientByEmail(String email) {
        return clientRepository.findByEmail(email);
    }

    @Override
    public boolean validatePassword(String rawPassword, String hashedPassword) {
        return passwordEncoder.matches(rawPassword, hashedPassword);
    }

    @Override
    @Transactional
    public void deleteClientById(Integer id) {
        clientRepository.deleteById(id);
    }

    @Override
    public ClientEntity getCurrentClient() {
        String email = authUtils.getCurrentClientEmail();

        if ("anonymousUser".equals(email)) {
            throw new ClientNotAuthenticatedException("No client authenticated");
        }

        return clientRepository.findByEmail(email)
                .orElseThrow(() -> new ClientNotFoundException("Client not found with email: " + email));
    }

    @Override
    @Transactional(readOnly = true)
    public List<BookingWithTicketsResponse> getBookingsWithTickets(String clientEmail) {
        List<BookingEntity> bookings = bookingRepository.findByClientEmail(clientEmail);

        return bookings.stream().map(booking -> {
            List<TicketDto> tickets = booking.getTickets().stream()
                .map(ticket -> new TicketDto(
                    ticket.getTicketId(),
                    ticket.getTotalAmount(),
                    ticket.getAmountToPay(),
                    ticket.getPaymentStatus().toString(),
                    ticket.getCreatedAt()
                ))
                .toList();

            return new BookingWithTicketsResponse(
                booking.getId(),
                booking.getRoomShift().getRoom().getRoomName(),
                booking.getGuestCount(),
                booking.getStatus().toString(),
                booking.getNotes(),
                booking.getBookingDate(),
                tickets
            );
        }).toList();
    }
}