<template>
    <div>
        <DatePicker v-model="selectedDate" :dateFormat="'dd-mm-yy'" :inline="true">
            <template #date="slotProps">
                <div :class="{'selectable-day': isFutureDate(slotProps.date), 'disabled-day': !isFutureDate(slotProps.date)}"
                    @click="selectDay(slotProps.date)">
                    {{ slotProps.date.day }}
                </div>
            </template>
        </DatePicker>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const emit = defineEmits(['update:selectedDay']);
const selectedDate = ref(null);

// Función para convertir la fecha a formato YYYY-MM-DD
const translateDate = (date) => {
    const padZero = (num) => (num < 10 ? '0' + num : num);
    return `${date.year}-${padZero(date.month + 1)}-${padZero(date.day)}`;
};

// Obtener la fecha actual en formato YYYY-MM-DD
const today = new Date();
const todayString = translateDate({
    year: today.getFullYear(),
    month: today.getMonth(),
    day: today.getDate()
});

// Verifica si la fecha es hoy o en el futuro
const isFutureDate = (date) => {
    return translateDate(date) >= todayString;
};

// Emitir la fecha seleccionada solo si es hoy o en el futuro
const selectDay = (date) => {
    const translatedDate = translateDate(date);
    if (isFutureDate(date)) {
        emit('update:selectedDay', { day: translatedDate, isDisabled: false });
    }
};
</script>

<style scoped>
.selectable-day {
    background-color: #80cc80;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
}

.selectable-day:hover {
    background-color: #66a366;
}

.disabled-day {
    background-color: #e48383;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    cursor: not-allowed;
    opacity: 0.6;
}
</style>
