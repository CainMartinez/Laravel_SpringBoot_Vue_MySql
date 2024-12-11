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
};

const actions = {
    async populate({ commit, state }) {
        console.log('Populating storeAuth');
        if (state.accessToken) {
            try {
                let response;
                switch (state.userType) {
                    case 'client':
                        response = await ClientService.getCurrentUser(state.accessToken);
                        commit('setUserData', response);
                        console.log('Client data:', state.userData);
                        break;
                    case 'waiter':
                        response = await WaiterService.getCurrentUser(state.accessToken);
                        commit('setUserData', response.waiter);
                        console.log('Waiter data:', state.userData);
                        break;
                    case 'manager':
                        response = await ManagerService.getCurrentUser(state.accessToken);
                        commit('setUserData', response.manager);
                        console.log('Manager data:', state.userData);
                        break;
                    default:
                        throw new Error('Rol de usuario no válido');
                }

                // Si la respuesta es exitosa, actualizamos el store
                commit('setAuthenticated', true);
                commit('setUserType', state.userType);
                commit('setToken', state.accessToken);
                console.log('Token:', state.accessToken);
                console.log('User type:', state.userType);
                console.log('User authenticated:', state.isAuthenticated);

            } catch (error) {
                // Si el token es inválido o ha expirado, hacemos logout
                console.error('Error al verificar el token:', error.message);
                // commit('logout');
                // window.location.href = '/login';
            }
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
            console.log('Login successful, token:', token);

            localStorage.setItem('token', token);
            localStorage.setItem('userType', role);

            switch (role) {
                case 'client':
                    window.location.href = '/home';
                    break;
                case 'waiter':
                    // window.location.href = '/dashboard-waiter';
                    break;
                case 'manager':
                    // window.location.href = '/dashboard-manager';
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
        console.log('Registrando usuario:', firstName, lastName, email, password, repeatPassword, role);
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

            console.log('Registration successful:', response.message);

            return response;
        } catch (error) {
            console.error('Error en el registro:', error.message);
            throw error;
        }
    },

    async logout({ commit }) {
        try {
            let response;
            switch (state.userType) {
                case 'client':
                    response = await ClientService.logout();
                    break;
                case 'waiter':
                    response = await WaiterService.logout();
                    break;
                case 'manager':
                    response = await ManagerService.logout();
                    break;
            }

            commit('logout');
            localStorage.removeItem('token');
            window.location.href = '/login';
            console.log('Logged out successfully');
        } catch (error) {
            console.error('Error during logout:', error.message);
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
