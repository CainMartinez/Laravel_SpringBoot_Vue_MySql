const API_BASE_URL = 'http://localhost:8081/api';

export const fetchNgos = async () => {
    const response = await fetch(`${API_BASE_URL}/ngos`);
    if (!response.ok) {
        throw new Error('Failed to fetch NGOs');
    }
    return response.json();
};