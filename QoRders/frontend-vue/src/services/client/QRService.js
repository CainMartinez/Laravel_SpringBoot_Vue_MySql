import { api_spring } from '../api';

const QRService = {
    async validateQRCode(queryData) {
        try {
            const response = await api_spring.post(`/qr/validate?data=${queryData}`);
            console.log(response.data);
            return response.data;
        } catch (error) {
            console.error("Error al validar el QR:", error);
            throw error;
        }
    },
    async validateBooking(bookingId) {
        try {
            const response = await api_spring.get(`/booking/${bookingId}`);
            return response;
        } catch (error) {
            console.error("Error al validar la reserva:", error);
            throw error;
        }
    }
};

export default QRService;
