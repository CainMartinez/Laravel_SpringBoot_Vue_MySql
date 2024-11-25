import { api_spring } from "../api";

const ProductsService = {
    async getProducts() {
        try {
            const response = await api_spring.get('/products');
            return response.data;
        } catch (error) {
            console.error("Error al obtener los productos:", error);
            throw error;
        }
    },

    async getProductByRoom(room_slug) {
        try {
            const response = await api_spring.get(`/products/room/${room_slug}`);
            return response.data;
        } catch (error) {
            console.error("Error al obtener los productos de la sala:", error);
            throw error;
        }
    }
};

export default ProductsService;
