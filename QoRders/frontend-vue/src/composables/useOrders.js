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

    // En el composable useOrders
    const addProductsToExistingOrder = async (orderId) => {
        try {
            const productsToAdd = store.getters['storeOrders/getOrderProducts'];
            
            // Si no hay productos seleccionados, mostrar error
            if (!productsToAdd || productsToAdd.length === 0) {
                return { success: false, message: 'No hay productos seleccionados' };
            }
            
            const response = await OrderService.addProductsToOrder(orderId, productsToAdd);
            
            // Limpiar los productos seleccionados después de añadirlos
            store.commit('storeOrders/clearOrderProducts');
            
            return response;
        } catch (error) {
            console.error('Error al añadir productos a la orden:', error);
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
            const response = await store.dispatch('storeOrders/fetchOrder', { orderId, token });
            return response;
        } catch (error) {
            console.error("Error fetching order:", error);
            throw error;
        }
    };

    const getTicketData = async (bookingId) => {
        const token = store.getters['storeAuth/getToken'];
        try {
            const response = await store.dispatch('storeOrders/fetchTicketData', { bookingId, token });
            return response;
        } catch (error) {
            console.error("Error al obtener el ticket:", error);
            throw error;
        }
    };

    const makePayment = async (paymentData) => {
        const token = store.getters['storeAuth/getToken'];

        try {
            const response = await store.dispatch('storeOrders/submitPayment', { paymentData, token });
            return response.data;
        } catch (error) {
            console.error("Error al realizar el pago:", error);
            throw error;
        }
    };


    return {
        createOrder,
        addProductsToExistingOrder,
        submitOrder,
        fetchOrder,
        getTicketData,
        makePayment,
    };
}