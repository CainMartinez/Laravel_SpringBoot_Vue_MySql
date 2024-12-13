import { api_laravel } from '../api';

export const submitDonation = async (donationData) => {
    try {
        const response = await api_laravel.post('/donations', donationData);
        return response.data;
    } catch (error) {
        console.error('Error al realizar la donación:', error);
        throw error.response?.data || { message: 'Error al conectar con el servidor' };
    }
};

export default { submitDonation };