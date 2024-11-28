import { api_spring } from "../api";

const ProductsService = {
    async getProducts() {
        try {
            const response = await api_spring.get('/products');
            // console.log("ProductsService.js: Fetched products ->", response.data);
            return response.data.content;
        } catch (error) {
            console.error("ProductsService.js: Error fetching all products:", error);
            throw error;
        }
    },

    async getProductByRoom(room_slug, filters = {}) {
        try {
            // console.log("ProductsService.js: Sending request with filters ->", filters); // Debug

            // Construir los parámetros de consulta basados en los filtros
            const params = new URLSearchParams(filters).toString();
            const response = await api_spring.get(`/products/room/${room_slug}?${params}`);
            // console.log("Url enviada al server ->", `/products/room/${room_slug}?${params}`); // Debug
            // console.log("ProductsService.js: Response from server ->", response.data);
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