import { api_spring } from '../api';

export const getNgos = async () => {
    try {
        const response = await api_spring.get('/ngos');
        return response.data;
    } catch (error) {
        console.error('Error al obtener los NGOs', error);
        throw error;
    }
};

export const getNgoBySlug = async (ngoSlug) => {
    try {
        const response = await api_spring.get(`/ngos/${ngoSlug}`);
        return response.data;
    } catch (error) {
        console.error(`Error al obtener el NGO con slug: ${ngoSlug}`, error);
        throw error;
    }
};

export default { getNgos, getNgoBySlug };