import { api_spring } from "../api";

const ClientService = {
    async login(email, password, role) {
        try {
            console.log("ClientService login");
            console.log({ email, password, role });
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
            console.log("ClientService register");
            console.log({ firstName, lastName, email, password, repeatPassword, role });
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

    async logout() {
        try {
            const response = await api_spring.post('/auth/logout');
            return response.data;
        } catch (error) {
            console.error("Error al cerrar sesión:", error);
            throw error;
        }
    }
};

export default ClientService;
