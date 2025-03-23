import OrderService from "../../services/client/OrderService";

const state = {
    orderId: parseInt(localStorage.getItem('orderId')) || 0,
    bookingId: parseInt(localStorage.getItem('bookingId')) || 0,
    products: JSON.parse(localStorage.getItem('selectedProducts') || '[]').filter(p => p.quantity > 0), // Inmediatamente filtrar productos con cantidad 0
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
        // Solo añadir si la cantidad es mayor que 0
        if (product.quantity > 0) {
            const existingProductIndex = state.products.findIndex(p => p.productId === product.productId);
            
            if (existingProductIndex >= 0) {
                state.products[existingProductIndex].quantity = product.quantity;
            } else {
                state.products.push(product);
            }
            
            // Filtrar productos con cantidad 0 antes de guardar
            const validProducts = state.products.filter(p => p.quantity > 0);
            state.products = validProducts;
            
            // Guardar en localStorage usando la clave correcta
            localStorage.setItem('selectedProducts', JSON.stringify(validProducts));
        }
    },
    removeProduct(state, productId) {
        // Filtrar el producto a eliminar
        state.products = state.products.filter(p => p.productId !== productId);
        
        // Actualizar localStorage con la clave correcta
        localStorage.setItem('selectedProducts', JSON.stringify(state.products));
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
        localStorage.removeItem('selectedProducts');
        localStorage.removeItem('orderProducts'); // También limpiar esta clave antigua por si acaso
    },
    clearLocalStorageOnly(state) {
        localStorage.removeItem('selectedProducts');
        localStorage.removeItem('orderProducts'); // También limpiar esta clave antigua por si acaso
    },
    setTicketData(state, ticketData) {
        state.ticketData = ticketData;
    },
    initializeStore(state) {
        // Recuperar productos guardados en localStorage si existen, filtrando los que tienen cantidad 0
        const savedProducts = localStorage.getItem('selectedProducts');
        if (savedProducts) {
            const parsedProducts = JSON.parse(savedProducts);
            state.products = parsedProducts.filter(p => p.quantity > 0);
            
            // Si hay productos con cantidad 0, actualizamos localStorage
            if (parsedProducts.length !== state.products.length) {
                localStorage.setItem('selectedProducts', JSON.stringify(state.products));
            }
        }
    },
    cleanupZeroQuantityProducts(state) {
        // Filtrar productos con cantidad 0
        const validProducts = state.products.filter(p => p.quantity > 0);
        
        // Actualizar el state y localStorage si hay cambios
        if (validProducts.length !== state.products.length) {
            state.products = validProducts;
            localStorage.setItem('selectedProducts', JSON.stringify(validProducts));
        }
    },
    resetProductQuantities(state) {
        // Eliminar todos los productos en lugar de establecer cantidades a 0
        state.products = [];
        localStorage.removeItem('selectedProducts');
    },
};

const actions = {
    async createOrder({ commit, state }, { bookingId, token }) {
        try {
            const response = await OrderService.createOrder(bookingId, token);
            commit('setOrderId', response.orderId);
            commit('setBookingId', response.bookingId);
            
            // Asegurarse de que los productos tengan cantidad > 0
            const validProducts = response.products.filter(p => p.quantity > 0);
            validProducts.forEach(product => {
                commit('addProductsToOrder', product);
            });
            
            return response;
        } catch (error) {
            console.error("Error creando la orden:", error);
            throw error;
        }
    },

    async addProductsToExistingOrder({ commit }, product) {
        try {
            // Solo añadir si la cantidad es mayor que 0
            if (product.quantity > 0) {
                commit('addProductsToOrder', product);
                return product;
            } else {
                // Si la cantidad es 0, eliminar el producto
                commit('removeProduct', product.productId);
                return null;
            }
        } catch (error) {
            console.error("Error añadiendo productos a la orden:", error);
            throw error;
        }
    },

    removeProduct({ commit }, productId) {
        commit('removeProduct', productId);
    },

    async submitOrder({ commit, state }, token) {
        try {
            const orderId = state.orderId;
            
            // Limpiar productos con cantidad 0 antes de enviar
            commit('cleanupZeroQuantityProducts');
            
            const validProducts = state.products.filter(p => p.quantity > 0);
            
            const response = await OrderService.submitOrder({ orderId, validProducts }, token);
            
            // Limpiar localStorage pero mantener datos en el store para el pago
            commit('clearLocalStorageOnly');
            
            return response;
        } catch (error) {
            console.error("Error enviando la orden:", error);
            throw error;
        }
    },

    clearLocalStorageOnly({ commit }) {
        commit('clearLocalStorageOnly');
    },

    clearOrder({ commit }) {
        commit('clearOrder');
    },
    
    // Acción para limpiar productos con cantidad 0
    cleanupZeroQuantityProducts({ commit }) {
        commit('cleanupZeroQuantityProducts');
    },

    // Resto de tus acciones...
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

    initializeFromLocalStorage({ commit }) {
        commit('initializeStore');
        // Limpiamos productos con cantidad 0 al inicializar
        commit('cleanupZeroQuantityProducts');
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
        return state.products.filter(p => p.quantity > 0);
    },
    getOrderProducts(state) {
        return state.products.filter(p => p.quantity > 0);
    },
    getOrderData(state) {
        return state.orderData;
    },
    getTicketData(state) {
        return state.ticketData;
    },
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