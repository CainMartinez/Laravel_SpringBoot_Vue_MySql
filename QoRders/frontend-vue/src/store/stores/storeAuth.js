

const state = {
    userType: null,
    isAuthenticated: false,
}

const mutations = {
    setUserType(state, type) {
        state.userType = type;
    },
    setAuthenticated(state, status) {
        state.isAuthenticated = status;
    }
}

const actions = {
    async login({ commit }, { email, password }) {
        // Simulación de un login
        commit('setAuthenticated', true);
        commit('setUserType', 'cliente');  // Asignar tipo de usuario por defecto
    },
    async register({ commit }, { email, password }) {
        // Simulación de un registro
        commit('setAuthenticated', true);
        commit('setUserType', 'cliente');  // Asignar tipo de usuario por defecto
    }
}

const getters = {
    getUserType(state) {
        return state.userType;
    },
    getIsAuthenticated(state) {
        return state.isAuthenticated;
    }
}

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
}
