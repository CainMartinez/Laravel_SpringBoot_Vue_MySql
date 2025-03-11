import OrderService from "../../services/client/OrderService";

const state = {
    orderId: parseInt(localStorage.getItem('orderId')) || 0,
    bookingId: parseInt(localStorage.getItem('bookingId')) || 0,
    products: JSON.parse(localStorage.getItem('orderProducts')) || [],
    orderData: {},
    ticketData: {},
};

const mutations = {
    setOrderId(state, orderId) {
        state.orderId = orderId;
        localStorage.setItem('orderId', orderId);
    },
    setBookingId(state, bookingId) {
        state.bookingId = bookingId;
        localStorage.setItem('bookingId', bookingId);
    },
    addProductsToOrder(state, product) {
        const existingProduct = state.products.find(p => p.productId === product.productId);
        if (existingProduct) {
            existingProduct.quantity = product.quantity;
        } else {
            state.products.push(product);
        }
        
        // Opcional: también guardar en localStorage para mayor persistencia
        localStorage.setItem('orderProducts', JSON.stringify(state.products));
    },
    setOrderData(state, orderData) {
        state.orderData = orderData;
    },
    clearOrder(state) {
        state.orderId = 0;
        state.bookingId = null;
        state.products = [];
        state.orderData = {
            orderId: null,
            orderStatus: null,
            products: [],
        };
        
        // Limpiar también localStorage
        localStorage.removeItem('orderId');
        localStorage.removeItem('bookingId');
        localStorage.removeItem('orderProducts');
    },
    setTicketData(state, ticketData) {
        state.ticketData = ticketData;
    },
    // Recuperar productos de localStorage al iniciar (opcional)
    initializeStore(state) {
        // Recuperar productos guardados en localStorage si existen
        const savedProducts = localStorage.getItem('orderProducts');
        if (savedProducts) {
            state.products = JSON.parse(savedProducts);
        }
    },
    resetProductQuantities(state) {
        // Mantener los productos pero establecer todas las cantidades a 0
        state.products.forEach(product => {
            product.quantity = 0;
        });
        
        // Actualizar localStorage para reflejar las cantidades reseteadas
        localStorage.setItem('orderProducts', JSON.stringify(state.products));
    },
};

const actions = {
    async createOrder({ commit, state }, { bookingId, token }) {
        try {
            const response = await OrderService.createOrder(bookingId, token);
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
            return product;
        } catch (error) {
            console.error("Error añadiendo productos a la orden:", error);
            throw error;
        }
    },

    async submitOrder({ commit, state }, token) {
        try {
            const orderId = state.orderId;
            const products = state.products;
            const response = await OrderService.submitOrder({ orderId, products }, token);
            // No llamamos a clearOrder aquí, se manejará después de recibir respuesta
            return response;
        } catch (error) {
            console.error("Error enviando la orden:", error);
            throw error;
        }
    },

    clearOrder({ commit }) {
        commit('clearOrder');
    },

    async fetchOrder({ commit }, { orderId, token }) {
        try {
            const response = await OrderService.fetchOrder(orderId, token);
            commit('setOrderData', response);
            return response;
        } catch (error) {
            console.error("Error fetching order:", error);
            throw error;
        }
    },

    async fetchTicketData({ commit, state }, { bookingId, token }) {
        try {
            const response = await OrderService.getTicket(bookingId, token);
            commit('setTicketData', response);
            return response;
        } catch (error) {
            console.error("Error al obtener el ticket:", error);
            throw error;
        }
    },

    async submitPayment({ commit }, { paymentData, token }) {
        try {
            const response = await OrderService.makePayment(paymentData, token);
            commit('setTicketData', response.data);
            return response;
        } catch (error) {
            console.error("Error al procesar el pago:", error);
            throw error;
        }
    },

    // Acción para inicializar el estado desde localStorage
    initializeFromLocalStorage({ commit }) {
        commit('initializeStore');
    },
    resetProductQuantities({ commit }) {
        commit('resetProductQuantities');
    },
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
    },
    getOrderData(state) {
        return state.orderData;
    },
    getTicketData(state) {
        return state.ticketData;
    },
    // Getter para obtener la cantidad de un producto específico
    getProductQuantity: (state) => (productId) => {
        const product = state.products.find(p => p.productId === productId);
        return product ? product.quantity : 0;
    }
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
};