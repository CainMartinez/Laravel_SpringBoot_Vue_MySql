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
            console.log("WaiterService register");
            console.log({ firstName, lastName, email, password, repeatPassword, role });
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

    async logout() {
        try {
            const response = await api_laravel.post('/auth/waiter/logout');
            return response.data;
        } catch (error) {
            console.error("Error al cerrar sesión del camarero:", error);
            throw error;
        }
    },

    // Método para obtener los datos del camarero autenticado
    async getMe() {
        try {
            const response = await api_laravel.get('/auth/waiter/me');
            return response.data;
        } catch (error) {
            console.error("Error al obtener los datos del camarero:", error);
            throw error;
        }
    },

    async refresh() {
        try {
            const response = await api_laravel.post('/auth/waiter/refresh');
            return response.data;
        } catch (error) {
            console.error("Error al actualizar el token del camarero:", error);
            throw error;
        }
    }
};

export default WaiterService;
