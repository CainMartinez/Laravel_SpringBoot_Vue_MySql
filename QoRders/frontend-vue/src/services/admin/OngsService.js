import { api_laravel } from "../api";

const NgosService = {
    async getAllNgos(token) {
        try {
            const response = await api_laravel.get(`/auth/manager/ngos`, {
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

    async createNgos(token, ngo) {
        try {
            const response = await api_laravel.post(`/auth/manager/ngos`, ngo, {
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

    async updateNgos(token, ngo) {
        try {
            const response = await api_laravel.put(`/auth/manager/ngos/${ngo.ngo_slug}`, ngo, {
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

    async enableNgos(token, slug) {
        try {
            const response = await api_laravel.put(`/auth/manager/ngos/${slug}/enable`, {}, {
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

    async disableNgos(token, slug) {
        try {
            const response = await api_laravel.put(`/auth/manager/ngos/${slug}/disable`, {}, {
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

export default NgosService;