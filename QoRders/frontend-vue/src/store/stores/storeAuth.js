import ClientService from '../../services/auth/ClientService';
import WaiterService from '../../services/auth/WaiterService';
import ManagerService from '../../services/auth/ManagerService';

const state = {
    userType: localStorage.getItem('userType') || null,
    isAuthenticated: localStorage.getItem('token') ? true : false,
    userData: null,
    accessToken: localStorage.getItem('token') || null,
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
    setToken(state, token) {
        state.accessToken = token;
        localStorage.setItem('token', token);
    },
    logout(state) {
        state.userType = null;
        state.isAuthenticated = false;
        state.userData = null;
        state.accessToken = null;
        localStorage.removeItem('token');
        localStorage.removeItem('userType');
    },
    UPDATE_CLIENT_DATA(state, clientData) {
        if (state.userData && state.userData.client) {
            state.userData.client = {
                ...state.userData.client,
                ...clientData
            };
        }
    }
};

const actions = {
    async populate({ commit, state }) {
        if (state.accessToken) {
            try {
                let response;
                switch (state.userType) {
                    case 'client':
                        response = await ClientService.getCurrentUser(state.accessToken);
                        commit('setUserData', response);
                        break;
                    case 'waiter':
                        response = await WaiterService.getCurrentUser(state.accessToken);
                        commit('setUserData', response.waiter);
                        break;
                    case 'manager':
                        response = await ManagerService.getCurrentUser(state.accessToken);
                        commit('setUserData', response.manager);
                        break;
                    default:
                        throw new Error('Rol de usuario no válido');
                }

                commit('setAuthenticated', true);
                commit('setUserType', state.userType);
                commit('setToken', state.accessToken);

            } catch (error) {
                console.error('Error al verificar el token:', error.message);
                commit('logout');
                window.location.href = '/login';
            }
        }
    },
    async generateCoupon({ commit, rootGetters }) {
        try {
            const userId = rootGetters['storeAuth/getUserData'].id;
            const response = await axios.post('/api/clients/generate-coupon', { user_id: userId });
            
            if (response.data.success) {
            // Actualizar el estado del usuario en el store
            commit('storeAuth/UPDATE_USER_COUPON_STATUS', true, { root: true });
            return response.data;
            }
        } catch (error) {
            console.error('Error generando cupón:', error);
            throw error;
        }
    },
    async login({ commit }, { email, password, role }) {
        try {
            let response;
            switch (role) {
                case 'client':
                    response = await ClientService.login(email, password, role);
                    break;
                case 'waiter':
                    response = await WaiterService.login(email, password, role);
                    break;
                case 'manager':
                    response = await ManagerService.login(email, password, role);
                    break;
                default:
                    throw new Error("Invalid role");
            }

            const token = response;

            localStorage.setItem('token', token);
            localStorage.setItem('userType', role);

            switch (role) {
                case 'client':
                    window.location.href = '/home';
                    break;
                case 'waiter':
                    window.location.href = '/dashboard-waiter';
                    break;
                case 'manager':
                    window.location.href = '/dashboard-manager';
                    break;
                default:
                    break;
            }

            return response;
        } catch (error) {
            console.error('Error en el login:', error.message);
            throw error;
        }
    },

    async register({ commit }, { firstName, lastName, email, password, repeatPassword, role }) {
        try {
            let response;
            switch (role) {
                case 'client':
                    response = await ClientService.register(firstName, lastName, email, password, repeatPassword, role);
                    break;
                case 'waiter':
                    response = await WaiterService.register(firstName, lastName, email, password, repeatPassword, role);
                    break;
                case 'manager':
                    response = await ManagerService.register(firstName, lastName, email, password, repeatPassword, role);
                    break;
                default:
                    throw new Error("Invalid role");
            }

            window.location.href = '/login';

            return response;
        } catch (error) {
            console.error('Error en el registro:', error.message);
            throw error;
        }
    },

    async logout({ commit }, state) {
        try {
            let response;
            switch (state.userType) {
                case 'client':
                    response = await ClientService.logout(state.accessToken);
                    break;
                case 'waiter':
                    response = await WaiterService.logout(state.accessToken);
                    break;
                case 'manager':
                    response = await ManagerService.logout(state.accessToken);
                    break;
            }

            commit('logout');
            localStorage.removeItem('token');
            localStorage.removeItem('userType');
            window.location.href = '/login';
        } catch (error) {
            console.error('Error during logout:', error.message);
            throw error;
        }
    },
    async updateUser({ commit, state }, userData) {
        try {
            let response;
            switch (state.userType) {
                case 'client':
                    response = await ClientService.update(userData);
                    break;
                case 'waiter':
                    response = await WaiterService.update(userData);
                    break;
                case 'manager':
                    response = await ManagerService.update(userData);
                    break;
            }
            commit('setUserData', response);
        } catch (error) {
            console.error('Error al actualizar los datos:', error);
            throw error;
        }
    },


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
    getToken(state) {
        return state.accessToken;
    },
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};
