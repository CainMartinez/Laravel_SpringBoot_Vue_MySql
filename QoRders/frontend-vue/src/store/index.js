import { createStore } from "vuex";

import storeProducts from "./stores/storeProducts";
import storeRooms from "./stores/storeRooms";
import storeAuth from "./stores/storeAuth";
import storeReservation from "./stores/storeReservation";
import storeOrders from "./stores/storeOrders";
import storeAdmin from "./stores/storeAdmin";
import storeWaiter from "./stores/storeWaiter";

export default createStore({
    modules: {
        storeProducts,
        storeRooms,
        storeAuth,
        storeReservation,
        storeOrders,
        storeAdmin,
        storeWaiter
    }
});