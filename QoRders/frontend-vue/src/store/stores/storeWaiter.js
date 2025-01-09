import WaiterService from '../../services/waiter/WaiterService';

const state = {
    reservations: [],
    qrUrl: null,
};

const mutations = {
    setReservations(state, reservations) {
        state.reservations = reservations;
    },
    setQrUrl(state, url) {
        state.qrUrl = url;
    },
};

const actions = {
    async fetchReservations({ commit }) {
        try {
            const authToken = localStorage.getItem("token");
            const response = await WaiterService.getReservations(authToken);

            const mappedReservations = response.data.map((reservation) => ({
                id: reservation.booking_id,
                clientName: reservation.email,
                date: reservation.booking_date,
                guestCount: reservation.guest_count,
                notes: reservation.notes || "Sin notas",
                status: reservation.status,
            }));

            commit("setReservations", mappedReservations);
        } catch (error) {
            console.error("Error al obtener las reservas:", error);
            throw error;
        }
    },
    async fetchOrders(_, bookingId) {
        try {
            const authToken = localStorage.getItem("token");
            const response = await WaiterService.getOrders(authToken, bookingId);

            // Mapea las órdenes y sus productos
            const mappedOrders = response.data.map((order) => ({
                id: order.order_id,
                status: order.order_status,
                products: order.products.map((product) => ({
                    name: product.product_name,
                    quantity: product.quantity,
                })),
            }));

            return mappedOrders;
        } catch (error) {
            console.error("Error al obtener las órdenes:", error);
            throw error;
        }
    },
    async fetchGenerateQr({ commit }, bookingId) {
        try {
            const authToken = localStorage.getItem('token');
            const response = await WaiterService.generateQr(authToken, bookingId);
            commit('setQrUrl', response.data.url);
        } catch (error) {
            console.error("Error al generar el QR en el store:", error);
            throw error;
        }
    },
    async changeOrderStatus(_, { endpoint, orderId }) {
        try {
            const authToken = localStorage.getItem("token");
            const response = await WaiterService.changeOrderStatus(authToken, endpoint, orderId);

            return response.data;
        } catch (error) {
            console.error("Error al cambiar el estado de la orden:", error);
            throw error;
        }
    },
    async fetchTicketFromStore(_, bookingId) {
        try {
            const authToken = localStorage.getItem("token");
            const response = await WaiterService.getTicket(authToken, bookingId);

            return response.data;
        } catch (error) {
            console.error("Error al obtener el ticket:", error);
            throw error;
        }
    }
};

const getters = {
    getQrUrl: (state) => state.qrUrl,
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};