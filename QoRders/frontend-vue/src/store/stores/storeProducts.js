import ProductsService from '../../services/client/ProductsService';


const state = {
    products: [],
    productsByRoom: []
}

const mutations = {
    setProducts(state, products) {
        state.products = products;
    },
    setProductsByRoom(state, products) {
        state.productsByRoom = products;
    }
}

const actions = {
    async fetchProducts({ commit }) {
        try {
            const productsData = await ProductsService.getProducts();
            commit('setProducts', productsData);
        } catch (error) {
            console.error("Error al obtener los productos:", error);
        }
    },
    async fetchProductsByRoom({ commit }, room_slug) {
        try {
            const productsData = await ProductsService.getProductByRoom(room_slug);
            // console.log("Productos de la sala:", productsData);
            commit('setProductsByRoom', productsData);
        } catch (error) {
            console.error("Error al obtener los productos de la sala:", error);
        }
    }
}

const getters = {
    products(state) {
        return state.products;
    },
    getProductsByRoom(state) {
        return state.productsByRoom;
    },
}

export default {
    namespaced: true,
    state,
    mutations,
    actions,
    getters
}
