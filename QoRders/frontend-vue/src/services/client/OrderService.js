import { api_spring } from "../api";

const OrderService = {
    async createOrder(bookingId, token) {
        try {
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

    async submitOrder(order, token) {
        try {
            const orderData = {
                orderId: order.orderId,
                products: order.products.map(product => ({
                    productId: product.productId,
                    quantity: product.quantity
                }))
            };
            const response = await api_spring.post(`/orders/products`, orderData, {
                headers: { 'Authorization': `Bearer ${token}` }
            });
            return response.data;
        } catch (error) {
            console.error("OrderService.js: Error submitting order:", error);
            throw error;
        }
    },

    async fetchOrder(orderId, token) {
        try {
            const response = await api_spring.get(`/orders/${orderId}`, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
            return response.data;
        } catch (error) {
            console.error("OrderService.js: Error fetching order:", error);
            throw error;
        }
    },

    async getTicket(bookingId, token) {
        try {
            const response = await api_spring.post(`/booking/${bookingId}/ticket`, {}, {
                headers: {
                    'Authorization': `Bearer ${token}`,
                }
            });
            return response.data;
        } catch (error) {
            console.error("Error al obtener el ticket:", error);
            throw error;
        }
    },

    async makePayment(paymentData) {
        try {
            console.log('OrderService - Enviando datos de pago:', paymentData);
            const response = await api_spring.post('/booking/pay', paymentData, {
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            console.log('OrderService - Respuesta recibida:', response.data);
            return response.data;
        } catch (error) {
            console.error("Error al realizar el pago:", error);
            if (error.response) {
                console.error("Detalles del error:", error.response.data);
                console.error("Estado HTTP:", error.response.status);
                console.error("Headers:", error.response.headers);
            }
            throw error;
        }
    },
};

export default OrderService;