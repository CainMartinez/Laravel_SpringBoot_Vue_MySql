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
            const response = await store.dispatch('storeReservation/makeReservation', reservationData);
            return response;
        } catch (error) {
            console.error('Error al realizar la reserva:', error);
            throw error;
        }
    };

    return {
        shifts,
        loadShifts,
        makeReservation
    };
}