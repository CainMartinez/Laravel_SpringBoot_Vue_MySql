import { api_spring } from '../api';
import { api_laravel } from '../api';

export const getNgos = async () => {
    try {
        const response = await api_laravel.get('/ngos');
        console.log('getNgos', response.data.data);
        return response.data.data;
    } catch (error) {
        console.error('Error al obtener los NGOs', error);
        throw error;
    }
};

export const getNgoBySlug = async (ngo_slug) => {
    try {
        const response = await api_laravel.get(`/ngos/${ngo_slug}`);
        return response.data;
    } catch (error) {
        console.error(`Error al obtener la ONG con slug: ${ngo_slug}`, error.message);
        throw error;
    }
};

export default { getNgos, getNgoBySlug };