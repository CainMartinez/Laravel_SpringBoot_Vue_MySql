<template>
    <div>
        <DatePicker v-model="selectedDate" :dateFormat="'dd-mm-yy'" :inline="true">
            <template #date="slotProps">
                <div v-if="checkGreenDay(slotProps.date)" class="availableDay" @click="selectedDay(slotProps.date)">{{
                    slotProps.date.day }}</div>
                <div v-tooltip.top="'Hay disponibilidad en otras salas'" v-else-if="checkYellowDay(slotProps.date)"
                    class="otherRoom">
                    {{ slotProps.date.day }}</div>
                <div v-else-if="checkRedDay(slotProps.date)" class="unavailable">{{ slotProps.date.day }}</div>
                <div v-else>{{ slotProps.date.day }}</div>
            </template>
        </DatePicker>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import DatePicker from 'primevue/datepicker';

const props = defineProps({
    roomCapacity: Number,
    selectedRoom: String,
    selectedShift: String,
    selectedPeople: Number
});

const selectedDate = ref(null);
const store = useStore();
const shifts = computed(() => store.getters['storeReservation/getShifts'].data);

const checkGreenDay = (date) => {
    let dayShifts = shifts.value.filter(s => s.shiftDate === translateDate(date));
    if (dayShifts.length === 0) return false;
    let shiftSelected = dayShifts.find(s => s.shiftType === props.selectedShift);
    let roomAvailability = props.roomCapacity - shiftSelected.roomShifts.find(r => r.roomName === props.selectedRoom).reservedCapacity;
    if (roomAvailability >= props.selectedPeople) return true;
    return false;
};

const checkYellowDay = (date) => {
    let dayShifts = shifts.value.filter(s => s.shiftDate === translateDate(date));
    if (dayShifts.length === 0) return false;
    let shiftSelected = dayShifts.find(s => s.shiftType === props.selectedShift);

    return shiftSelected.roomShifts.some(r => {
        let roomAvailability = props.roomCapacity - r.reservedCapacity;
        if (roomAvailability >= props.selectedPeople) {
            console.log("vamos a devolver amarillo para la fecha " + translateDate(date));
            return true;
        }
        return false;
    });
};

const checkRedDay = (date) => {
    let dayShifts = shifts.value.filter(s => s.shiftDate === translateDate(date));
    if (dayShifts.length === 0) return false;
    let shiftSelected = dayShifts.find(s => s.shiftType === props.selectedShift);
    return shiftSelected.roomShifts.some(r => {
        let roomAvailability = props.roomCapacity - r.reservedCapacity;
        if (roomAvailability >= props.selectedPeople) {
            console.log("vamos a devolver amarillo para la fecha " + translateDate(date));
            return false;
        }

        return true;
    });
};

const translateDate = (date) => {
    const padZero = (num) => (num < 10 ? '0' + num : num);

    const year = date.year;
    const month = padZero(date.month + 1);
    const day = padZero(date.day);

    return `${year}-${month}-${day}`;
};

const selectedDay = (date) => {
    console.log("Se ha seleccionado la fecha: " + date);
    diaReserva.value = date;
};


</script>

<style scoped>
.availableDay {
    background-color: #80cc80;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.otherRoom {
    background-color: #ecec60;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.unavailable {
    background-color: #e48383;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>