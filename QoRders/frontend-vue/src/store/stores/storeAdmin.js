import AdminService from '../../services/admin/AdminService';
import ProductsService from '../../services/admin/ProductsService';
import RoomsService from '../../services/admin/RoomsService';
import NgosService from '../../services/admin/OngsService';
import { all } from 'axios';

const state = {
    generalMetrics: {},
    allProducts: [],
    allRooms: [],
    allNgos: []
};

const mutations = {
    setGeneralMetrics(state, metrics) {
        state.generalMetrics = metrics;
    },
    setProducts(state, products) {
        state.allProducts = products.data;
    },
    setAllRooms(state, rooms) {
        state.allRooms = rooms;
    },
    setAllNgos(state, ngos) {
        state.allNgos = ngos;
    }
};

const actions = {
    async fetchGetGeneralMetrics({ commit, state }) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await AdminService.getGeneralMetrics(authToken);
            commit('setGeneralMetrics', response);
        } catch (error) {
            console.error("Error al obtener las métricas generales:", error);
            throw error;
        }
    },

    async fetchGetAllProducts({ commit, state }) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await ProductsService.getAllProducts(authToken);
            commit('setGeneralMetrics', response);
        } catch (error) {
            console.error("Error al obtener las métricas generales:", error);
            throw error;
        }
    },

    async fetchCreateProduct({ commit, state }, product) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await ProductsService.createProduct(authToken, product);
            commit('setProducts', response);
        } catch (error) {
            console.error("Error al obtener las métricas generales:", error);
            throw error;
        }
    },

    async fetchUpdateProduct({ commit, state }, product) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await ProductsService.updateProduct(authToken, product);
            commit('setProducts', response);
        } catch (error) {
            console.error("Error al obtener las métricas generales:", error);
            throw error;
        }
    },

    async fetchEnableProduct({ commit, state }, slug) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await ProductsService.enableProduct(authToken, slug);
            commit('setProducts', response);
        } catch (error) {
            console.error("Error al obtener las métricas generales:", error);
            throw error;
        }
    },

    async fetchDisableProduct({ commit, state }, slug) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await ProductsService.disableProduct(authToken, slug);
            commit('setProducts', response);
        } catch (error) {
            console.error("Error al obtener las métricas generales:", error);
            throw error;
        }
    },

    async fetchGetAllRooms({ commit, state }) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await RoomsService.getAllRooms(authToken);
            commit('setAllRooms', response);
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async fetchCreateRoom({ dispatch, state }, room) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await RoomsService.createRoom(authToken, room);
            if (response.data) {
                dispatch('fetchGetAllRooms');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async updateRoom({ commit, dispatch }, room) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await RoomsService.updateRoom(authToken, room);
            if (response.data) {
                toast.add({ severity: 'success', summary: 'Sala actualizada', life: 3000 });
                dispatch('fetchGetAllRooms');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async enableRoom({ commit, dispatch }, slug) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await RoomsService.enableRoom(authToken, slug);
            if (response.data) {
                dispatch('fetchGetAllRooms');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async disableRoom({ commit, dispatch }, slug) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await RoomsService.disableRoom(authToken, slug);
            if (response.data) {
                dispatch('fetchGetAllRooms');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async fetchGetAllNgos({ commit, state }) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await NgosService.getAllNgos(authToken);
            commit('setAllNgos', response);
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async fetchCreateNgo({ dispatch, state }, ngo) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await NgosService.createNgos(authToken, ngo);
            if (response.data) {
                dispatch('fetchGetAllNgos');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async updateNgo({ commit, dispatch }, ngo) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await NgosService.updateNgos(authToken, ngo);
            if (response.data) {
                toast.add({ severity: 'success', summary: 'Sala actualizada', life: 3000 });
                dispatch('fetchGetAllNgos');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async enableNgo({ commit, dispatch }, slug) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await NgosService.enableNgos(authToken, slug);
            if (response.data) {
                dispatch('fetchGetAllNgos');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async disableNgo({ commit, dispatch }, slug) {
        try {
            let response;
            let authToken = localStorage.getItem('token');
            response = await NgosService.disableNgos(authToken, slug);
            if (response.data) {
                dispatch('fetchGetAllNgos');
            }
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    }
};

const getters = {
    getGeneralMetrics: (state) => state.generalMetrics,
    getAllProducts: (state) => state.allProducts,
    getAllRooms: (state) => {
        return state.allRooms;
    },
    getAllNgos: (state) => {
        return state.allNgos;
    }
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};
