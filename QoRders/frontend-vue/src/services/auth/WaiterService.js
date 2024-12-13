import { api_laravel } from "../api";

const WaiterService = {
    async login(email, password, role) {
        try {
            const response = await api_laravel.post('/auth/login', {
                role,
                email,
                password,
            });
            return response.data;
        } catch (error) {
            console.error("Error al iniciar sesión del camarero:", error);
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
            console.error("Error al registrar al camarero:", error);
            throw error;
        }
    },

    async logout(token) {
        try {
            const response = await api_laravel.post('/auth/waiter/logout', {}, {
                headers: { Authorization: `Bearer ${token}` },
            });
            return response.data;
        } catch (error) {
            console.error("Error al cerrar sesión del camarero:", error);
            throw error;
        }
    },

    // Método para obtener los datos del camarero autenticado
    async getCurrentUser(token) {
        try {
            const response = await api_laravel.get('/auth/waiter/me', {
                headers: { Authorization: `Bearer ${token}` },
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener los datos del camarero:", error);
            throw error;
        }
    }
};

export default WaiterService;
