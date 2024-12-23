package com.QoRders.client.booking.api.controller;

import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.QoRders.client.booking.domain.entity.QREntity;
import com.QoRders.client.booking.domain.repository.QRCodeRepository;
import com.QoRders.client.booking.domain.service.QRCodeService;
import com.QoRders.client.client.domain.entity.ClientEntity;
import com.QoRders.client.client.domain.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/qr")
public class QRController {

    private static final Logger log = LoggerFactory.getLogger(QRController.class);
    private final QRCodeService qrCodeService;
    private final ClientRepository clientRepository;
    private final JwtProvider jwtProvider;
    private final QRCodeRepository qrRepository;

    @Value("${aes.encryption.key}")
    private String SECRET_KEY;

    @PostMapping("/validate")
    public ResponseEntity<?> validateQRCode(@RequestParam("data") String encryptedData) {
        try {
            // Desencriptar los datos
            Map<String, Object> credentials = qrCodeService.decryptQRCodeData(encryptedData, SECRET_KEY);
            String email = (String) credentials.get("email");
            String tempToken = (String) credentials.get("tempToken");
            Integer bookingId = (Integer) credentials.get("bookingId");

            // Validar el token temporal
            if (!jwtProvider.isValid(tempToken)) {
                log.error("Token temporal inválido o expirado para email: {}", email);
                updateQRStatus(bookingId, QREntity.Status.Expired); // Cambiar estado a expirado
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("El QR no es válido o ha expirado.");
            }

            // Generar un nuevo Access Token regular
            String newAccessToken = jwtProvider.generateAccessToken(email);
            log.info("Nuevo Access Token generado para email: {}", email);

            // Actualizar el estado del cliente a `is_seated`
            ClientEntity client = clientRepository.findByEmail(email)
                    .orElseThrow(() -> new IllegalArgumentException("Cliente no encontrado."));
            client.setIs_seated(true);
            clientRepository.save(client);

            updateQRStatus(bookingId, QREntity.Status.In_progress);
            
            return ResponseEntity.ok(Map.of(
                    "accessToken", newAccessToken,
                    "message", "Login automático exitoso. Cliente ahora está sentado."
            ));
        } catch (Exception e) {
            log.error("Error validando el QR: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error validando el QR: " + e.getMessage());
        }
    }
    private void updateQRStatus(Integer bookingId, QREntity.Status status) {
        QREntity qrEntity = qrRepository.findByBookingId(bookingId)
                .orElseThrow(() -> new IllegalArgumentException("QR no encontrado."));
        qrEntity.setStatus(status);
        qrEntity.setUpdatedAt(LocalDateTime.now()); // Actualizar la fecha de modificación
        qrRepository.save(qrEntity);
        log.info("Estado del QR actualizado a {} para bookingId: {}", status, bookingId);
    }
}