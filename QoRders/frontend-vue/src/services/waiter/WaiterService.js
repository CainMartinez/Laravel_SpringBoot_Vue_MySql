import { api_laravel } from "../api";

const WaiterService = {
    async getReservations(token) {
        try {
            const response = await api_laravel.get('/auth/waiter/bookings', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                },
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener las reservas:", error);
            throw error;
        }
    },
    async generateQr(token, bookingId) {
        try {
            const response = await api_laravel.put(`/auth/waiter/send-qr/${bookingId}`, {}, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json',
                },
            });
            return response.data;
        } catch (error) {
            console.error("Error en WaiterService.generateQr:", error);
            throw error;
        }
    },
    async getOrders(token, bookingId) {
        try {
            const response = await api_laravel.get(`/auth/waiter/bookings/${bookingId}/orders`, {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener los pedidos:", error);
            throw error;
        }
    },
    async changeOrderStatus(token, endpoint, orderId) {
        try {
            const response = await api_laravel.put(endpoint, {}, {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });

            return response.data;
        } catch (error) {
            console.error(`Error al cambiar el estado de la orden ${orderId}:`, error);
            throw error;
        }
    },
    async getTicket(token, bookingId) {
        try {
            const response = await api_laravel.get(`/auth/waiter/bookings/${bookingId}/ticket`, {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });

            return response.data;
        } catch (error) {
            console.error(`Error al obtener el ticket de la reserva ${bookingId}:`, error);
            throw error;
        }
    }
};

export default WaiterService;