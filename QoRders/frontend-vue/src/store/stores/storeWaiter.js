import WaiterService from '../../services/waiter/WaiterService';

const state = {
    reservations: [], // Almacena las reservas cargadas
    qrUrl: null, // URL del QR generado
};

const mutations = {
    setReservations(state, reservations) {
        state.reservations = reservations;
    },
    setQrUrl(state, url) {
        state.qrUrl = url;
    },
};

const actions = {
    async fetchReservations({ commit }) {
        try {
            const authToken = localStorage.getItem('token');
            const response = await WaiterService.getReservations(authToken);

            // Si los datos necesitan un mapeo
            const mappedReservations = response.data.map(reservation => ({
                id: reservation.booking_id,
                clientName: reservation.client_name || reservation.email,
                date: reservation.date || reservation.booking_date,
                guestCount: reservation.guest_count,
                notes: reservation.notes || "Sin notas"
            }));

            console.log("Reservas mapeadas:", mappedReservations);
            commit('setReservations', mappedReservations);
        } catch (error) {
            console.error("Error al obtener las reservas:", error);
            throw error;
        }
    },
    async fetchGenerateQr({ commit }, bookingId) {
        console.log("Action fetchGenerateQr ejecutado con ID:", bookingId);
        try {
            const authToken = localStorage.getItem('token');
            const response = await WaiterService.generateQr(authToken, bookingId);
            console.log("Respuesta del servicio para el QR:", response);
            commit('setQrUrl', response.data.url);
        } catch (error) {
            console.error("Error al generar el QR en el store:", error);
            throw error;
        }
    },
};

const getters = {
    getQrUrl: (state) => state.qrUrl,
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};