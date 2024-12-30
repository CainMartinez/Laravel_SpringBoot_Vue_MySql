<template>
    <div class="reservation-page">
        <h1>¿Dónde vas a viajar hoy?</h1>

        <!-- Selección de Sala -->
        <RoomSelect :rooms="rooms" @update:selectedRoom="changeSelectedRoom($event)" />

        <!-- Selección de Número de Personas -->
        <PeopleSelect @update:selectedPeople="changeSelectedPeople($event)" />

        <!-- Selección de Turno -->
        <ShiftSelect @update:selectedShift="changeSelectedShift($event)" />

        <!-- Calendario -->
        <Calendar v-if="selectedRoom && selectedShift" />

        <!-- Botón de Reserva -->
        <button @click="handleReservation">Hacer Reserva</button>

        <!-- Modal de Error -->
        <Modal v-if="errorMessage" :message="errorMessage" />
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import RoomSelect from '../components/RoomSelect.vue';
import PeopleSelect from '../components/PeopleSelect.vue';
import ShiftSelect from '../components/ShiftSelect.vue';
import Calendar from '../components/Calendar.vue';
import Modal from '../components/Modal.vue';

const store = useStore();

const rooms = computed(() => store.getters['storeRooms/getRooms']);
const selectedRoom = ref('');
const selectedShift = ref('');
const selectedPeople = ref(2);
const errorMessage = ref('');
const selectedDay = ref(null);

const changeSelectedShift = (shift) => {
    console.log("Se ha cambiado el turno a: " + shift);
    selectedShift.value = shift;
};

const changeSelectedRoom = (room) => {
    console.log("Se ha cambiado la habitacion a: " + room);
    selectedRoom.value = room;
};

const changeSelectedPeople = (people) => {
    console.log("Se ha cambiado el numero de personas a: " + people);
    selectedPeople.value = people;
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