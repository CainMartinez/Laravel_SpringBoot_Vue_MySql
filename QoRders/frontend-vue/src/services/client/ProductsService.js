import { api_spring } from "../api";

const ProductsService = {
    async getProducts() {
        try {
            const response = await api_spring.get('/products');
            return response.data.content;
        } catch (error) {
            console.error("ProductsService.js: Error fetching all products:", error);
            throw error;
        }
    },

    async getProductByRoom(room_slug, filters = {}) {
        try {
            const params = new URLSearchParams(filters).toString();
            const response = await api_spring.get(`/products/room/${room_slug}?${params}`);
            return {
                content: response.data.content || [],
                totalElements: response.data.totalElements || 0,
            };
        } catch (error) {
            console.error("ProductsService.js: Error fetching products by room:", error);
            throw error;
        }
    }
};

export default ProductsService;