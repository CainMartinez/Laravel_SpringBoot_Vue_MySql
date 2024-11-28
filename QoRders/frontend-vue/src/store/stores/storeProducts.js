import ProductsService from '../../services/client/ProductsService';

const state = {
    productsByRoom: [],
    totalProducts: 0,
};

const mutations = {
    setProductsByRoom(state, { products, total }) {
        // console.log("storeProducts.js: Mutating productsByRoom ->", products, "Total products:", total); // Debug
        state.productsByRoom = products;
        state.totalProducts = total;
    },
};

const actions = {
    async fetchProductsByRoom({ commit }, { room_slug, filters }) {
        if (!room_slug) {
            console.error("storeProducts.js: room_slug is not defined."); // Debug
            return;
        }
        try {
            // console.log("storeProducts.js: Fetching products for room:", room_slug, "with filters:", filters); // Debug
            const productsData = await ProductsService.getProductByRoom(room_slug, filters);

            // console.log("storeProducts.js: Fetched products for room ->", productsData); // Debug
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
        // console.log("storeProducts.js: Getter productsByRoom ->", state.productsByRoom); // Debug
        return state.productsByRoom;
    },
    getTotalProducts(state) {
        // console.log("storeProducts.js: Getter totalProducts ->", state.totalProducts); // Debug
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