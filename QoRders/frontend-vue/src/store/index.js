import { createStore } from "vuex";

import storeProducts from "./stores/storeProducts";
import storeRooms from "./stores/storeRooms";

export default createStore({
    modules: {
        storeProducts,
        storeRooms
    }
});