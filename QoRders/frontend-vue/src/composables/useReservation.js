import { ref } from 'vue';
import { useStore } from 'vuex';

export default function useReservation() {
    const store = useStore();
    const shifts = ref([]);

    const loadShifts = async (yearMonth) => {
        try {
            const response = await store.dispatch('storeReservation/fetchShifts', { yearMonth });
            const data = response;
            shifts.value = data;
            filterAvailableDays();
        } catch (error) {
            console.error("Error loading shifts", error);
        }
    };

    const makeReservation = async (reservationData) => {
        try {
            const token = store.getters['storeAuth/getToken'];
            console.log('Token:', token);
            const response = await store.dispatch('storeReservation/makeReservation', { token, reservationData });
            return response;
        } catch (error) {
            console.error('Error al realizar la reserva:', error);
            throw error;
        }
    };

    const loadReservations = async () => {
        try {
            const token = store.getters['storeAuth/getToken'];
            console.log('Token:', token);
            await store.dispatch('storeReservation/fetchReservations', token);
        } catch (error) {
            console.error('Error al cargar las reservas:', error);
        }
    };

    return {
        shifts,
        loadShifts,
        makeReservation,
        loadReservations
    };
}