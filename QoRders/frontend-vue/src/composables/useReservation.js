import { ref } from 'vue';
import { useStore } from 'vuex';

export default function useReservation() {
    const store = useStore();

    const shifts = ref([]);
    const availableDays = ref([]);
    const selectedShift = ref('');
    const selectedRoom = ref('');

    const loadShifts = async (yearMonth) => {
        try {
            const response = await store.dispatch('storeReservation/fetchShifts', { yearMonth });
            const data = response; // Assuming response is already parsed
            shifts.value = data;
            filterAvailableDays();
        } catch (error) {
            console.error("Error loading shifts", error);
        }
    };

    const makeReservation = async ({ date, room_slug, firstName, shift, guest_count, email, phoneNumber, notes }) => {
        try {
            const reservationData = { date, room_slug, firstName, shift, guest_count, email, phoneNumber, notes };
            await store.dispatch('storeReservation/makeReservation', reservationData);
        } catch (error) {
            console.error('Error al realizar la reserva:', error);
            throw error;
        }
    };

    const filterAvailableDays = () => {
        if (!shifts.value) return;

        const roomShifts = shifts.value.filter(shift => shift.roomName === selectedRoom.value);

        const days = roomShifts.map(shift => ({
            date: shift.shiftDate,
            availability: shift.totalRevenue < shift.capacity ? 'green' : 'red',
        }));

        availableDays.value = days;
    };

    return {
        shifts,
        availableDays,
        loadShifts,
        makeReservation,
        filterAvailableDays,
        selectedShift,
        selectedRoom,
    };
}