import { api_spring } from "../api";

const OrderService = {
    async createOrder(bookingId, token) {
        try {
            console.log(bookingId);
            const response = await api_spring.post('/orders', { bookingId }, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                }
            });
            return response.data;
        } catch (error) {
            console.error("OrderService.js: Error creating order:", error);
            throw error;
        }
    },

    async submitOrder(products, token) {
        try {
            console.log(products); 
            const response = await api_spring.post(`/orders/products`, { products }, {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            console.log(response);
            // return response.data;
        } catch (error) {
            console.error("OrderService.js: Error submitting order:", error);
            throw error;
        }
    }
};

export default OrderService;