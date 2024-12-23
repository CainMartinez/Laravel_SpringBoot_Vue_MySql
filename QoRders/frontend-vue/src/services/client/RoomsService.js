import { api_spring } from "../api";

const RoomsService = {
    async getRooms() {
        try {
            const response = await api_spring.get('/rooms');
            return response.data;
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async getRoomBySlug(room_slug) {
        try {
            const response = await api_spring.get(`/rooms/${room_slug}`);
            return response.data;
        } catch (error) {
            console.error("Error al obtener los detalles de la sala:", error);
            throw error;
        }
    }
};

export default RoomsService;
