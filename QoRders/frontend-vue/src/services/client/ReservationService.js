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

    async makeReservation(reservationData) {
        try {
            const response = await api_spring.post('/booking', { reservationData });
            return response.data;
        } catch (error) {
            console.error("Error al hacer la reserva:", error);
            throw error;
        }
    }
};

export default ReservationService;
