import { api_spring } from "../api";

const ReservationService = {
    async fetchShifts(yearMonth) {
        try {
            const response = await api_spring.get(`/shifts?yearMonth=${yearMonth}`);
            console.log("Turnos cargados:", response.data);
            return response;
        } catch (error) {
            console.error("Error al obtener los turnos:", error);
            throw error;
        }
    },

    async makeReservation(token, reservationData) {
        try {
            console.log("Datos de la reserva:", reservationData);
            const response = await api_spring.post('/booking', reservationData, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            console.log("Reserva realizada:", response.data);
            return response;
        } catch (error) {
            console.error("Error al hacer la reserva:", error);
            throw error;
        }
    },

    async fetchReservations(token) {
        try {
            console.log("Token:", token);
            const response = await api_spring.get('client/bookings', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            console.log("Reservas cargadas:", response.data);
            return response;
        } catch (error) {
            console.error("Error al obtener las reservas:", error);
            throw error;
        }
    }
};

export default ReservationService;