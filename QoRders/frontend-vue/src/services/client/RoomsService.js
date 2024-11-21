import { api } from "../api";

export default {

    async getRooms() {
        return api.get('/api/rooms');
    }

}