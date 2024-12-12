import ProductsService from '../../services/client/ProductsService';

const state = {
    productsByRoom: [],
    totalProducts: 0,
};

const mutations = {
    setProductsByRoom(state, { products, total }) {
        state.productsByRoom = products;
        state.totalProducts = total;
    },
};

const actions = {
    async fetchProductsByRoom({ commit }, { room_slug, filters }) {
        if (!room_slug) {
            console.error("storeProducts.js: room_slug is not defined.");
            return;
        }
        try {
            const productsData = await ProductsService.getProductByRoom(room_slug, filters);

            commit('setProductsByRoom', {
                products: productsData.content,
                total: productsData.totalElements,
            });
        } catch (error) {
            console.error("storeProducts.js: Error fetching products by room:", error);
        }
    },
};

const getters = {
    getProductsByRoom(state) {
        return state.productsByRoom;
    },
    getTotalProducts(state) {
        return state.totalProducts;
    },
};

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters,
};