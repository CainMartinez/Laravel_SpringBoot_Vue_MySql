import OrderService from "../../services/client/OrderService";

const state = {
    orderId: 0,
    bookingId: null,
    products: [],
};

const mutations = {
    setOrderId(state, orderId) {
        state.orderId = orderId;
    },
    setBookingId(state, bookingId) {
        state.bookingId = bookingId;
    },
    addProductsToOrder(state, product) {
        const existingProduct = state.products.find(p => p.productId === product.productId);
        if (existingProduct) {
            existingProduct.quantity = product.quantity;
        } else {
            state.products.push(product);
        }
    },
    clearOrder(state) {
        state.orderId = 0;
        state.products = [];
    }
};

const actions = {
    async createOrder({ commit, state }) {
        try {
            const orderData = {
                bookingId: state.bookingId,
                notes: "",
            };
            const response = await OrderService.createOrder(orderData);
            commit('setOrderId', response.orderId);
            commit('setBookingId', response.bookingId);
            commit('addProductsToOrder', response.products);
            return response;
        } catch (error) {
            console.error("Error creando la orden:", error);
            throw error;
        }
    },

    async addProductsToExistingOrder({ commit }, product) {
        try {
            commit('addProductsToOrder', product);
        } catch (error) {
            console.error("Error añadiendo productos a la orden:", error);
            throw error;
        }
    },

    async submitOrder({ commit, state }) {
        try {
            const orderId = state.orderId;
            const products = state.products;
            const token = store.getters['storeAuth/getToken'];
            const response = await OrderService.submitOrder({ orderId, products }, token);
            commit('clearOrder');
            return response;
        } catch (error) {
            console.error("Error enviando la orden:", error);
            throw error;
        }
    },

    clearOrder({ commit }) {
        commit('clearOrder');
    }
};

const getters = {
    getOrderId(state) {
        return state.orderId;
    },
    getOrder(state) {
        return state;
    },
    getBookingId(state) {
        return state.bookingId;
    },
    getProducts(state) {
        return state.products;
    }
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
};