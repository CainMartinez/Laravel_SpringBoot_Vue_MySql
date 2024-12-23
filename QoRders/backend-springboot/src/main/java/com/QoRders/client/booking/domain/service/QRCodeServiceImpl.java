package com.QoRders.client.booking.domain.service;

import com.QoRders.client.auth.api.security.jwt.JwtProvider;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

@Service
public class QRCodeServiceImpl implements QRCodeService {

    private static final Logger log = LoggerFactory.getLogger(QRCodeServiceImpl.class);
    private static final String ENCRYPTION_ALGORITHM = "AES";
    private final JwtProvider jwtProvider;

    public QRCodeServiceImpl(JwtProvider jwtProvider) {
        this.jwtProvider = jwtProvider; // Inyección de dependencia
    }

    @Override
    public String generateQRCodeUrl(Integer bookingId, String email, String secretKey) {
        log.info("Iniciando generación de QR URL para bookingId: {} y email: {}", bookingId, email);
        try {
            // Generar un Access Token temporal válido por 2 horas
            String tempToken = jwtProvider.generateTemporalAccessToken(email, 2 * 60 * 60 * 1000L); // 2 horas en milisegundos
            log.info("Token temporal generado: {}", tempToken);

            // Crear el JSON con las credenciales
            Map<String, Object> credentials = new HashMap<>();
            credentials.put("bookingId", bookingId);
            credentials.put("email", email);
            credentials.put("tempToken", tempToken); // Token temporal

            log.info("Credenciales para QR generadas: {}", credentials);

            // Convertir el mapa a JSON
            ObjectMapper objectMapper = new ObjectMapper();
            String jsonCredentials = objectMapper.writeValueAsString(credentials);

            log.info("JSON de credenciales generado: {}", jsonCredentials);

            // Encriptar el JSON
            String encryptedCredentials = encrypt(jsonCredentials, secretKey);

            log.info("Credenciales encriptadas: {}", encryptedCredentials);

            // Construir la URL del QR
            String qrUrl = "http://localhost:8090/spring/api/qr/validate?data=" + URLEncoder.encode(encryptedCredentials, StandardCharsets.UTF_8);
            log.info("QR URL generada: {}", qrUrl);

            return qrUrl;
        } catch (Exception e) {
            log.error("Error generando la URL del QR para bookingId: {} y email: {}", bookingId, email, e);
            throw new RuntimeException("Error generando la URL del QR", e);
        }
    }

    @SuppressWarnings("unchecked")
    @Override
    public Map<String, Object> decryptQRCodeData(String encryptedData, String secretKey) {
        log.info("Iniciando desencriptación de datos del QR");
        try {
            log.info("Desencriptando datos: {}", encryptedData);
            String decryptedData = decrypt(encryptedData, secretKey);
            log.info("Datos desencriptados: {}", decryptedData);
            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.readValue(decryptedData, Map.class);
        } catch (Exception e) {
            log.error("Error desencriptando los datos del QR", e);
            throw new RuntimeException("Error desencriptando los datos del QR", e);
        }
    }

    private String encrypt(String data, String secretKey) throws Exception {
        log.info("Iniciando encriptación de datos");
        SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), ENCRYPTION_ALGORITHM);
        Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, keySpec);
        byte[] encryptedBytes = cipher.doFinal(data.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }

    private String decrypt(String encryptedData, String secretKey) throws Exception {
        log.info("Iniciando desencriptación de datos");
        SecretKeySpec keySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), ENCRYPTION_ALGORITHM);
        Cipher cipher = Cipher.getInstance(ENCRYPTION_ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, keySpec);
        byte[] decodedBytes = Base64.getDecoder().decode(encryptedData);
        return new String(cipher.doFinal(decodedBytes), StandardCharsets.UTF_8);
    }
}