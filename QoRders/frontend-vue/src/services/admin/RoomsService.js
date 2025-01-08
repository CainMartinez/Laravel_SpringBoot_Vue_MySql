import { api_laravel } from "../api";

const RoomsService = {
    async getAllRooms(token) {
        try {
            const response = await api_laravel.get(`/auth/manager/rooms`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al obtener las salas`, error);
            throw error;
        }
    },

    async createRoom(token, room) {
        try {
            const response = await api_laravel.post(`/auth/manager/rooms`, room, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al crear la sala`, error);
            throw error;
        }
    },

    async updateRoom(token, room) {
        try {
            const response = await api_laravel.put(`/auth/manager/rooms/${room.room_slug}`, room, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al actualizar la sala`, error);
            throw error;
        }
    },

    async enableRoom(token, slug) {
        try {
            const response = await api_laravel.put(`/auth/manager/rooms/${slug}/enable`, {}, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (e) {
            console.error(`Error al habilitar la sala`, error);
            throw error;
        }
    },

    async disableRoom(token, slug) {
        try {
            const response = await api_laravel.put(`/auth/manager/rooms/${slug}/disable`, {}, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (e) {
            console.error(`Error al deshabilitar la sala`, error);
            throw error;
        }
    }
};

export default RoomsService;