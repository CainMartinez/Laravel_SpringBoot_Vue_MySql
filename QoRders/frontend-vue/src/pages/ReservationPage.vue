<template>
    <div class="reservation-page">
        <h1>¿Dónde vas a viajar hoy?</h1>

        <!-- Selección de Sala -->
        <RoomSelect :rooms="rooms" v-model="selectedRoom" />

        <!-- Selección de Número de Personas -->
        <PeopleSelect v-model="guestCount" />

        <!-- Selección de Turno -->
        <ShiftSelect :selectedShift="selectedShift" @update:selectedShift="filterAvailableDays" />

        <!-- Calendario -->
        <Calendar :availableDays="availableDays" @selectDay="handleSelectDay" />

        <!-- Botón de Reserva -->
        <button @click="handleReservation">Hacer Reserva</button>

        <!-- Modal de Error -->
        <Modal v-if="errorMessage" :message="errorMessage" />
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import useReservation from '../composables/useReservation';
import RoomSelect from '../components/RoomSelect.vue';
import PeopleSelect from '../components/PeopleSelect.vue';
import ShiftSelect from '../components/ShiftSelect.vue';
import Calendar from '../components/Calendar.vue';
import Modal from '../components/Modal.vue';

const store = useStore();
const { loadShifts, makeReservation, filterAvailableDays, shifts, availableDays, selectedShift } = useReservation();

const rooms = ref([]);
const selectedRoom = ref('');
const guestCount = ref(2);
const errorMessage = ref('');
const selectedDay = ref(null);

onMounted(async () => {
    loadShifts('2025-01');
    await store.dispatch('storeRooms/fetchRooms');
    rooms.value = store.getters['storeRooms/getRooms'];
});

const handleReservation = async () => {
    try {
        // Datos de la reserva
        const reservationData = {
            date: selectedDay.value,
            room_slug: selectedRoom.value,
            firstName: 'Yolanda',
            shift: selectedShift.value,
            guest_count: guestCount.value,
            email: 'yomogan@gmail.com',
            phoneNumber: '622095840',
            notes: 'Silla para niño pequeño.'
        };

        await makeReservation(reservationData);
    } catch (error) {
        errorMessage.value = 'Hubo un error al realizar la reserva. Inténtalo de nuevo.';
    }
};

const handleSelectDay = (day) => {
    selectedDay.value = day.date;
};
</script>

<style scoped>
.reservation-page {
    padding: 20px;
    text-align: center;
}

h1 {
    margin-top: 80px;
}

button {
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #0056b3;
}
</style>