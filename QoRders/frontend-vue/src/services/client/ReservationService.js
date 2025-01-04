import { api_spring } from "../api";

const ReservationService = {
    async fetchShifts(yearMonth) {
        try {
            const response = await api_spring.get(`/shifts?yearMonth=${yearMonth}`);
            return response;
        } catch (error) {
            console.error("Error al obtener los turnos:", error);
            throw error;
        }
    },

    async makeReservation(token, reservationData) {
        try {
            const response = await api_spring.post('/booking', reservationData, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response;
        } catch (error) {
            console.error("Error al hacer la reserva:", error);
            throw error;
        }
    },

    async fetchReservations(token) {
        try {
            const response = await api_spring.get('client/bookings', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response;
        } catch (error) {
            console.error("Error al obtener las reservas:", error);
            throw error;
        }
    }
};

export default ReservationService;