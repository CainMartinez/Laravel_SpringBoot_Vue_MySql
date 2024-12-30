<template>
    <div>
        <DatePicker v-model="selectedDate" :show-week="true" :dateFormat="'dd-mm-yy'" :disabledDates="disabledDates"
            :eventClass="getEventClass" :inline="true"></DatePicker>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import useReservation from '../composables/useReservation';
import DatePicker from 'primevue/datepicker';

const { availableDays, loadShifts, selectedRoom } = useReservation();
const selectedDate = ref(null);

// Realizamos el filtro al cargar la página
onMounted(() => {
    loadShifts('2025-01');
});

// Obtener las clases de los días
const getEventClass = (date) => {
    const day = availableDays.value.find(day => day.date === formatDate(date));
    if (day) {
        return day.availability;
    }
    return '';
};

// Crear la lista de fechas deshabilitadas (rojas)
const disabledDates = computed(() => {
    return availableDays.value.filter(day => day.availability === 'red').map(day => day.date);
});

const formatDate = (date) => {
    return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
};
</script>

<style scoped>
.green {
    background-color: green;
}

.yellow {
    background-color: yellow;
}

.red {
    background-color: red;
}
</style>