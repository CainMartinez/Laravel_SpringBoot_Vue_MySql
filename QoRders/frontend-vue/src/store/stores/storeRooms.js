import RoomsService from '../../services/client/RoomsService';

const state = {
    rooms: [],
}

const mutations = {
    setRooms(state, rooms) {
        state.rooms = rooms;
    }
}

const actions = {
    async fetchRooms({ commit }) {
        try {
            const roomsData = await RoomsService.getRooms();
            commit('setRooms', roomsData);
        } catch (error) {
            console.error("Error al cargar las salas:", error);
        }
    }
}

const getters = {
    rooms(state) {
        return state.rooms;
    }
}

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
}
