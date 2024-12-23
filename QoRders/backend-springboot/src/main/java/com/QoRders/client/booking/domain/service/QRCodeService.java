package com.QoRders.client.booking.domain.service;

import java.util.Map;

public interface QRCodeService {

    /**
     * Genera la URL del QR con las credenciales de inicio de sesión del usuario encriptadas.
     *
     * @param bookingId ID de la reserva asociada al QR.
     * @param email     Email del usuario que generará la URL.
     * @param secretKey Llave secreta para encriptar las credenciales.
     * @return URL generada.
     */
    String generateQRCodeUrl(Integer bookingId, String email, String secretKey);
    Map<String, Object> decryptQRCodeData(String encryptedData, String secretKey);
}