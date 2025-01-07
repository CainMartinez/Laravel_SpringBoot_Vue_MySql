import { api_spring } from '../api';

const QRService = {
    async validateQRCode(queryData) {
        try {
            const response = await api_spring.post(`/qr/validate?data=${queryData}`);

            if (response.data && response.data.token) {
                return {
                    token: response.data.token,
                    bookingId: response.data.bookingId
                };
            } else {
                throw new Error('No se ha podido validar el QR');
            }
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
