<template>
    <div class="reservation-page">
        <h1>¿Dónde vas a viajar hoy?</h1>

        <div class="reservation-container">
            <div class="form-container">
                <!-- Selección de Sala -->
                <RoomSelect :rooms="rooms" @update:selectedRoom="changeSelectedRoom($event)" />

                <!-- Selección de Número de Personas -->
                <PeopleSelect @update:selectedPeople="changeSelectedPeople($event)" />

                <!-- Selección de Turno -->
                <ShiftSelect @update:selectedShift="changeSelectedShift($event)" />
            </div>

            <div v-if="selectedRoom && selectedShift" class="calendar-container">
                <!-- Calendario -->
                <Calendar :selectedRoom="selectedRoom" :selectedPeople="selectedPeople" :selectedShift="selectedShift"
                    :roomCapacity="roomCapacity" @update:selectedDay="changeSelectedDay($event)" />
            </div>
        </div>
        <!-- Observaciones -->
        <p>*Si desea trona o viene con carrito, debe incluirlo como 1 persona más.</p>

        <!-- Botón de Reserva -->
        <button @click="handleReservation" :disabled="isDisabled">Hacer Reserva</button>

        <!-- Modal de Error -->
        <Modal :visible="modalVisible" :message="modalMessage" title="Reserva"
            @update:visible="modalVisible = $event" />
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import RoomSelect from '../components/RoomSelect.vue';
import PeopleSelect from '../components/PeopleSelect.vue';
import ShiftSelect from '../components/ShiftSelect.vue';
import Calendar from '../components/Calendar.vue';
import Modal from '../components/Modal.vue';
// import { useReservation } from '../composables/useReservation';

// const { makeReservation } = useReservation();
const store = useStore();

const rooms = computed(() => store.getters['storeRooms/getRooms']);
const selectedRoom = ref(null);
const roomCapacity = ref(0);
const selectedShift = ref('');
const selectedPeople = ref(2);
const modalMessage = ref('');
const selectedDay = ref('');
const isDisabled = ref(true);
const modalVisible = ref(false);

const changeSelectedShift = (shift) => {
    selectedShift.value = shift;
};

const changeSelectedRoom = (room) => {
    selectedRoom.value = room;
    roomCapacity.value = rooms.value.find(r => r.name === room).maxCapacity;
};

const changeSelectedPeople = (people) => {
    selectedPeople.value = people;
};

const changeSelectedDay = (dayInfo) => {
    selectedDay.value = dayInfo.day;
    isDisabled.value = dayInfo.isDisabled;
};

const handleReservation = () => {
    const reserva = { selectedDay, selectedRoom, selectedShift, selectedPeople };
    if (selectedDay.value && selectedRoom.value && selectedShift.value && selectedPeople.value) {
        console.log(reserva);
        modalMessage.value = `Reserva realizada para el día ${selectedDay.value} en la sala ${selectedRoom.value} para ${selectedPeople.value} personas en el turno ${selectedShift.value}.`;
        // makeReservation(reserva);
    } else {
        modalMessage.value = "Por favor, completa todos los datos.";
    }
    modalVisible.value = true;
};
</script>

<style scoped>
.reservation-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background-color: #f7f7f7;
    color: #333;
    font-family: Arial, sans-serif;
    min-height: 100vh;
}

h1 {
    font-size: 2.5em;
    margin-bottom: 30px;
    margin-top: 100px;
}

.reservation-container {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 20px;
}

.form-container {
    display: flex;
    flex-direction: column;
    padding: 20px;
    border-radius: 8px;
    width: 100%;
    max-width: 400px;
    margin-bottom: 20px;
}

.calendar-container {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
}

button {
    padding: 10px 20px;
    font-size: 16px;
    background-color: #333;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

button:hover {
    background-color: #555;
}

button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}
</style>