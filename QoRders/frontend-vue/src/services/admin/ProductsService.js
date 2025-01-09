import { api_laravel } from "../api";

const ProductsService = {
    async getAllProducts(token) {
        try {
            const response = await api_laravel.get(`/auth/manager/products`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al obtener los productos`, error);
            throw error;
        }
    },

    async getProductsByRoom(token, room) {
        try {
            const response = await api_laravel.get(`/auth/manager/products/room/${room}`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al obtener los productos`, error);
            throw error;
        }
    },

    async createProduct(token, product) {
        try {
            const response = await api_laravel.post(`/auth/manager/products`, product, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al obtener los productos`, error);
            throw error;
        }
    },

    async updateProduct(token, product) {
        try {
            const response = await api_laravel.put(`/auth/manager/products/${product.slug}`, product, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error(`Error al obtener los productos`, error);
            throw error;
        }
    },

    async enableProduct(token, slug) {
        try {
            const response = await api_laravel.put(`/auth/manager/products/${slug}/enable`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (e) {
            console.error(`Error al obtener los productos`, error);
            throw error;
        }
    },

    async disableProduct(token, slug) {
        try {
            const response = await api_laravel.put(`/auth/manager/products/${slug}/disable`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (e) {
            console.error(`Error al obtener los productos`, error);
            throw error;
        }
    }
};

export default ProductsService;