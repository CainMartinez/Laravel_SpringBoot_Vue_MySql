import { api_spring } from './api';

const NgoService = {
    async fetchNgos() {
        try {
            const response = await api_spring.get('/ngos');
            return response.data;
        } catch (error) {
            console.error('Error al obtener los NGOs:', error);
            throw error;
        }
    },

    async fetchNgoBySlug(ngoSlug) {
        try {
            const response = await api_spring.get(`/ngos/${ngoSlug}`);
            return response.data;
        } catch (error) {
            console.error(`Error al obtener el NGO con slug: ${ngoSlug}`, error);
            throw error;
        }
    }
};

export default NgoService;