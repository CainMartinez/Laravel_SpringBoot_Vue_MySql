import { api_laravel } from "../api";

const WaiterService = {
    async getGeneralMetrics(token) {
        try {
            const response = await api_laravel.get('/auth/manager/dashboard-metrics', {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener los generalMetrics:", error);
            throw error;
        }
    }
};

export default WaiterService;