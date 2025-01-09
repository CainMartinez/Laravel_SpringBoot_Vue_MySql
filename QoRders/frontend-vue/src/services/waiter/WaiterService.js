import { api_laravel } from "../api";

const WaiterService = {
    async getReservations(token) {
        try {
            const response = await api_laravel.get('/auth/waiter/bookings', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                },
            });
            return response.data; // Retorna las reservas
        } catch (error) {
            console.error("Error al obtener las reservas:", error);
            throw error;
        }
    },
    async generateQr(token, bookingId) {
        try {
            console.log("Enviando solicitud al backend para QR con ID:", bookingId); // Log inicial
            console.log("Token:", token); // Log del token
            const response = await api_laravel.put(`/auth/waiter/send-qr/${bookingId}`,{}, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json',
                },
            });
            console.log("Respuesta del backend para QR:", response.data); // Log de la respuesta del backend
            return response.data; // Retorna la URL del QR
        } catch (error) {
            console.error("Error en WaiterService.generateQr:", error);
            throw error;
        }
    }
};

export default WaiterService;