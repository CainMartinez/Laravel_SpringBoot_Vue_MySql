import ReservationService from '../../services/client/ReservationService';

const state = {
    shifts: [],
    reservation: null,
};

const mutations = {
    setShifts(state, shifts) {
        state.shifts = shifts;
    },
    setReservation(state, reservation) {
        state.reservation = reservation;
        console.log("Reserva guardada en la store:", reservation);
    },
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
    }
};

const getters = {
    getShifts(state) {
        return state.shifts;
    },
    getReservation(state) {
        return state.reservation;
    }
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
};