import { api_laravel } from "../api";

const RoomsService = {
    async createRoom() {
        try {
            const response = await api_laravel.post('/rooms');
            console.log("Salas obtenidas:", response.data);
            return response.data;
        } catch (error) {
            console.error("Error al obtener las salas:", error);
            throw error;
        }
    },

    async updateRoom(slug, data) {
            try {
                const response = await api_laravel.put(`/rooms/${slug}`, data);
                return response.data;
            } catch (error) {
                console.error(`Error al actualizar la sala con slug: ${slug}`, error);
                throw error;
            }
        },

    async unableRoom(slug) {
        try {
            const response = await api_laravel.put(`/rooms/${slug}/unable`);
            return response.data;
        } catch (error) {
            console.error(`Error al deshabilitar la sala con slug: ${slug}`, error);
            throw error;
        }
    },

    async enableRoom(slug) {
        try {
            const response = await api_laravel.put(`/rooms/${slug}/enable`);
            return response.data;
        } catch (error) {
            console.error(`Error al habilitar la sala con slug: ${slug}`, error);
            throw error;
        }
    }
};

export default RoomsService;