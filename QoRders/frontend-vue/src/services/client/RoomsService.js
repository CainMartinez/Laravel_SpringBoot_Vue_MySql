import { api_spring, api_laravel } from "../api";

export default {
    async getRooms() {
        try {
            const response = await api_spring.get('/rooms');
            console.log("Salas obtenidas:", response.data);
            return response.data;
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    }
}
