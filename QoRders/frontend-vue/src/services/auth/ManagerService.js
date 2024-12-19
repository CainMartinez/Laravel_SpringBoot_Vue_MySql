import { api_laravel } from "../api";

const ManagerService = {
    async login(email, password, role) {
        try {
            const response = await api_laravel.post('/auth/login', {
                role,
                email,
                password,
            });
            return response.data;
        } catch (error) {
            console.error("Error al iniciar sesión del gerente:", error);
            throw error;
        }
    },

    async register(firstName, lastName, email, password, repeatPassword, role) {
        try {
            const response = await api_laravel.post('/auth/register', {
                role,
                firstName,
                lastName,
                email,
                password,
                repeatPassword,
            });
            return response.data;
        } catch (error) {
            console.error("Error al registrar al gerente:", error);
            throw error;
        }
    },

    async logout(token) {
        try {
            const response = await api_laravel.post('/auth/manager/logout', {}, {
                headers: { Authorization: `Bearer ${token}` },
            });
            return response.data;
        } catch (error) {
            console.error("Error al cerrar sesión del manager:", error);
            throw error;
        }
    },

    async getCurrentUser(token) {
        try {
            const response = await api_laravel.get('/auth/manager/me', {
                headers: { Authorization: `Bearer ${token}` },
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener los datos del gerente:", error);
            throw error;
        }
    },

    async update(userData) {
        try {
            const response = await api_laravel.put('/auth/manager/update', userData, {
                headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
            });
            return response.data;
        } catch (error) {
            console.error('Error al actualizar los datos del cliente:', error);
            throw error;
        }
    },
};

export default ManagerService;
