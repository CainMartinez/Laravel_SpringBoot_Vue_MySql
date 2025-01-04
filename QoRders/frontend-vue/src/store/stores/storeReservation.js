import ReservationService from '../../services/client/ReservationService';

const state = {
    shifts: [],
    reservation: null,
    reservations: []
};

const mutations = {
    setShifts(state, shifts) {
        state.shifts = shifts;
    },
    setReservation(state, reservation) {
        state.reservation = reservation;
    },
    setReservations(state, reservations) {
        state.reservations = reservations;
    }
};

const actions = {
    async fetchShifts({ commit }, { yearMonth }) {
        try {
            const shifts = await ReservationService.fetchShifts(yearMonth);
            commit('setShifts', shifts);
        } catch (error) {
            console.error('Error al cargar los turnos:', error);
            throw error;
        }
    },

    async makeReservation({ commit }, { token, reservationData }) {
        try {
            const reservation = await ReservationService.makeReservation(token, reservationData);
            commit('setReservation', reservation);
            return reservation;
        } catch (error) {
            console.error('Error al realizar la reserva:', error);
            throw error;
        }
    },

    async fetchReservations({ commit }, token) {
        try {
            const reservations = await ReservationService.fetchReservations(token);
            commit('setReservations', reservations);
        } catch (error) {
            console.error('Error al cargar las reservas:', error);
            throw error;
        }
    }
};

const getters = {
    getShifts(state) {
        return state.shifts;
    },
    getReservation(state) {
        return state.reservation;
    },
    getReservations(state) {
        return state.reservations;
    }
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
};