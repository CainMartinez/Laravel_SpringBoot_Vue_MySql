import { api_laravel } from "../api";

const ProductsService = {
    async createProduct() {
        try {
            const response = await api_laravel.post('/products');
            return response.data;
        } catch (error) {
            console.error("Error al obtener los productos:", error);
            throw error;
        }
    },

    async updateProduct(slug, data) {
            try {
                const response = await api_laravel.put(`/products/${slug}`, data);
                return response.data;
            } catch (error) {
                console.error(`Error al actualizar el producto con slug: ${slug}`, error);
                throw error;
            }
        },

    async unableProduct(slug) {
        try {
            const response = await api_laravel.put(`/products/${slug}/unable`);
            return response.data;
        } catch (error) {
            console.error(`Error al deshabilitar el producto con slug: ${slug}`, error);
            throw error;
        }
    },

    async enableProduct(slug) {
        try {
            const response = await api_laravel.put(`/products/${slug}/enable`);
            return response.data;
        } catch (error) {
            console.error(`Error al habilitar el producto con slug: ${slug}`, error);
            throw error;
        }
    }
};

export default ProductsService;