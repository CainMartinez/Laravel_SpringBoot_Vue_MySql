import { api_spring } from "../api";

const ClientService = {
    async login(email, password, role) {
        try {
            const response = await api_spring.post('/auth/login', {
                role,
                email,
                password,
            });
            return response.data;
        } catch (error) {
            console.error("Error al iniciar sesión:", error);
            throw error;
        }
    },

    async register(firstName, lastName, email, password, repeatPassword, role) {
        try {
            const response = await api_spring.post('/auth/register', {
                role,
                firstName,
                lastName,
                email,
                password,
                repeatPassword,
            });
            return response.data;
        } catch (error) {
            console.error("Error al registrar:", error);
            throw error;
        }
    },

    async logout(token) {
        try {
            const response = await api_spring.post('auth/client/logout', {}, {
                headers: { Authorization: `Bearer ${token}` },
            });
            return response.data;
        } catch (error) {
            console.error("Error al cerrar sesión del cliente:", error);
            if (error.response && error.response.status === 401) {
                console.error("Token inválido o expirado.");
            }
            throw error;
        }
    },

    async getCurrentUser(token) {
        try {
            const response = await api_spring.get('/client', {
                headers: { Authorization: `Bearer ${token}` },
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener el usuario actual:", error);
            throw error;
        }
    },

    async update(userData) {
        try {
            const response = await api_spring.put('/client', userData, {
                headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
            });
            return response.data;
        } catch (error) {
            console.error('Error al actualizar los datos del cliente:', error);
            throw error;
        }
    },
};

export default ClientService;
