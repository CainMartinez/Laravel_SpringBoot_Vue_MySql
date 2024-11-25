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

    async updateNgo(slug, data) {
        try {
            const response = await api_laravel.put(`/ngos/${slug}`, data);
            return response.data;
        } catch (error) {
            console.error(`Error al actualizar el NGO con slug: ${slug}`, error);
            throw error;
        }
    },

    async unableNgo(slug) {
        try {
            const response = await api_laravel.put(`/ngos/${slug}/unable`);
            return response.data;
        } catch (error) {
            console.error(`Error al deshabilitar el NGO con slug: ${slug}`, error);
            throw error;
        }
    },

    async enableNgo(slug) {
        try {
            const response = await api_laravel.put(`/ngos/${slug}/enable`);
            return response.data;
        } catch (error) {
            console.error(`Error al habilitar el NGO con slug: ${slug}`, error);
            throw error;
        }
    }
};

export default NgoService;