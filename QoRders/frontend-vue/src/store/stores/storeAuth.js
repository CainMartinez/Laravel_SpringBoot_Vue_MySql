import ClientService from '../../services/auth/ClientService';
import WaiterService from '../../services/auth/WaiterService';
import ManagerService from '../../services/auth/ManagerService';

const state = {
    userType: null,
    isAuthenticated: false,
    userData: null,
    accessToken: null,
};

const mutations = {
    setUserType(state, type) {
        state.userType = type;
    },
    setAuthenticated(state, status) {
        state.isAuthenticated = status;
    },
    setUserData(state, userData) {
        state.userData = userData;
    },
    setAccessToken(state, token) {
        state.accessToken = token;
    }
};

const actions = {
    // Login
    async login({ commit, dispatch }, { email, password, role }) {
        console.log('Login:', email, password, role);
        try {
            let response;
            switch (role) {
                case 'client':
                    response = await ClientService.login(email, password, role);
                    break;
                case 'waiter':
                    response = await WaiterService.login(email, password, role);
                    console.log('Login response');
                    break;
                case 'manager':
                    response = await ManagerService.login(email, password, role);
                    break;
            }
            console.log('Login response:', response);
            await dispatch('handleResponse', { response, role });
        } catch (error) {
            console.error('Error en el login:', error.message);
            throw error;
        }
    },

    // Registro
    async register({ commit, dispatch }, { firstName, lastName, email, password, repeatPassword, role }) {
        console.log('Register:', firstName, lastName, email, password, repeatPassword, role);
        try {
            let response;
            switch (role) {
                case 'client':
                    response = await ClientService.register(firstName, lastName, email, password, repeatPassword, role);
                    await dispatch('handleResponse', { response, role });
                    break;
                case 'waiter':
                    response = await WaiterService.register(firstName, lastName, email, password, repeatPassword, role);
                    console.log('Register response:', response);
                    await dispatch('handleResponse', { response, role });
                    break;
                case 'manager':
                    response = await ManagerService.register(firstName, lastName, email, password, repeatPassword, role);
                    await dispatch('handleResponse', { response, role });
                    break;
            }
        } catch (error) {
            console.error('Error en el registro:', error.message);
            throw error;
        }
    },

    // Handle Response
    handleResponse({ commit }, { response, role }) {
        commit('setAuthenticated', true);
        commit('setUserType', role);
        commit('setUserData', response.user);
        console.log('User data:', response.user);
        commit('setAccessToken', response.token);
        console.log('Token:', response.token);
        localStorage.setItem('token', response.token);
    },

    // Logout
    logout({ commit }) {
        commit('setAuthenticated', false);
        commit('setUserType', null);
        commit('setUserData', null);
        commit('setAccessToken', null);
        localStorage.removeItem('token');
    }
};

const getters = {
    getUserType(state) {
        return state.userType;
    },
    getIsAuthenticated(state) {
        return state.isAuthenticated;
    },
    getUserData(state) {
        return state.userData;
    },
    getAccessToken(state) {
        return state.accessToken;
    }
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
};
