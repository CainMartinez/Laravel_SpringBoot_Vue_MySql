import RoomsService from '../../services/client/RoomsService';

const state = {
    rooms: [],
    roomBySlug: {},
}

const mutations = {
    setRooms(state, rooms) {
        state.rooms = rooms;
    },
    setRoomBySlug(state, room) {
        state.roomBySlug = room;
    }
}

const actions = {
    async fetchRooms({ commit }) {
        try {
            const roomsData = await RoomsService.getRooms();
            console.log("Salas obtenidas:", roomsData);
            commit('setRooms', roomsData);
        } catch (error) {
            console.error("Error al cargar las salas:", error);
        }
    },
    async fetchRoomBySlug({ commit }, slug) {
        try {
            const roomData = await RoomsService.getRoomBySlug(slug);
            console.log("Sala obtenida:", roomData);
            commit('setRoomBySlug', roomData);
        } catch (error) {
            console.error("Error al cargar la sala:", error);
        }
    }
}

const getters = {
    getRooms(state) {
        return state.rooms;
    },
    getRoomBySlug(state) {
        return state.roomBySlug;
    }
}

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
}
