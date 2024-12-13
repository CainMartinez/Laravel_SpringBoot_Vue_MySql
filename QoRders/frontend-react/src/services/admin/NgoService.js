import { api_laravel } from './api';

const NgoService = {
    async createNgo(data) {
        try {
            const response = await api_laravel.post('/ngos', data);
            return response.data;
        } catch (error) {
            console.error('Error al crear el NGO:', error);
            throw error;
        }
    },

    async updateNgo(ngo_slug, data) {
        try {
            const response = await api_laravel.put(`/ngos/${ngo_slug}`, data);
            return response.data;
        } catch (error) {
            console.error(`Error al actualizar el NGO con slug: ${ngo_slug}`, error);
            throw error;
        }
    },

    async unableNgo(ngo_slug) {
        try {
            const response = await api_laravel.put(`/ngos/${ngo_slug}/unable`);
            return response.data;
        } catch (error) {
            console.error(`Error al deshabilitar el NGO con slug: ${ngo_slug}`, error);
            throw error;
        }
    },

    async enableNgo(ngo_slug) {
        try {
            const response = await api_laravel.put(`/ngos/${ngo_slug}/enable`);
            return response.data;
        } catch (error) {
            console.error(`Error al habilitar el NGO con slug: ${ngo_slug}`, error);
            throw error;
        }
    }
};

export default NgoService;