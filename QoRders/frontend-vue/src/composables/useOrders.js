import { useStore } from 'vuex';
import OrderService from '../services/client/OrderService';

export default function useOrders() {
    const store = useStore();

    const createOrder = async (bookingId) => {
        try {
            const token = store.getters['storeAuth/getToken'];
            const response = await OrderService.createOrder(bookingId, token);
            localStorage.setItem('orderId', response.orderId);
            return response;
        } catch (error) {
            console.error("Error creando la orden:", error);
            throw error;
        }
    };

    const addProductsToExistingOrder = async (productId, quantity) => {
        try {
            const product = { productId, quantity };
            store.dispatch('storeOrders/addProductsToExistingOrder', product);
        } catch (error) {
            console.error("Error añadiendo productos a la orden:", error);
            throw error;
        }
    };

    const submitOrder = async () => {
        try {
            const orderId = store.getters['storeOrders/getOrderId'];
            const products = store.getters['storeOrders/getProducts'];
            const token = store.getters['storeAuth/getToken'];
            const response = await OrderService.submitOrder({ orderId, products }, token);
            return response;
        } catch (error) {
            console.error("Error enviando la orden:", error);
            throw error;
        }
    };

    const fetchOrder = async () => {
        try {
            const orderId = store.getters['storeOrders/getOrderId'];
            const token = store.getters['storeAuth/getToken'];
            const response = await OrderService.fetchOrder(orderId, token);
            return response;
        } catch (error) {
            console.error("Error fetching order:", error);
            throw error;
        }
    };

    return {
        createOrder,
        addProductsToExistingOrder,
        submitOrder,
        fetchOrder
    };
}