// store.js
import { createStore } from 'vuex';
import RoomsService from '../services/client/RoomsService';

const store = createStore({
    state: {
        rooms: []
    },
    mutations: {
        setRooms(state, rooms) {
            state.rooms = rooms;
        }
    },
    actions: {
        async fetchRooms({ commit }) {
            try {
                const roomsData = await RoomsService.getRooms();
                commit('setRooms', roomsData);
            } catch (error) {
                console.error("Error al cargar las salas:", error);
            }
        }
    },
    getters: {
        rooms(state) {
            return state.rooms;
        }
    }
});

export default store;
