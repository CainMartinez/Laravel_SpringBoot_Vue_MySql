import { createStore } from "vuex";

import storeProducts from "./stores/storeProducts";
import storeRooms from "./stores/storeRooms";
import storeAuth from "./stores/storeAuth";

export default createStore({
    modules: {
        storeProducts,
        storeRooms,
        storeAuth
    }
});