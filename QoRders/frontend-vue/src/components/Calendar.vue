<template>
    <div>
        <DatePicker v-model="selectedDate" :dateFormat="'dd-mm-yy'" :inline="true">
            <template #date="slotProps">
                <div v-if="checkGreenDay(slotProps.date)" class="availableDay"
                    @click="selectDay(slotProps.date, false)">
                    {{ slotProps.date.day }}</div>
                <div v-tooltip.top="'Hay disponibilidad en otras salas'" v-else-if="checkYellowDay(slotProps.date)"
                    class="otherRoom" @click="selectDay('', true)">
                    {{ slotProps.date.day }}</div>
                <div v-tooltip.top="'No hay disponibilidad para hoy'" v-else-if="checkRedDay(slotProps.date)"
                    class="unavailable" @click="selectDay('', true)">{{
                        slotProps.date.day }}</div>
                <div v-else>{{ slotProps.date.day }}</div>
            </template>
        </DatePicker>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';

const props = defineProps({
    roomCapacity: Number,
    selectedRoom: String,
    selectedShift: String,
    selectedPeople: Number
});

const emit = defineEmits(['update:selectedDay']);
const selectedDate = ref(null);
const store = useStore();
const shifts = computed(() => store.getters['storeReservation/getShifts'].data);

const translateDate = (date) => {
    const padZero = (num) => (num < 10 ? '0' + num : num);

    const year = date.year;
    const month = padZero(date.month + 1);
    const day = padZero(date.day);

    return `${year}-${month}-${day}`;
};

const today = new Date();
const todayString = translateDate({
    year: today.getFullYear(),
    month: today.getMonth(),
    day: today.getDate()
});

const checkGreenDay = (date) => {
    if (translateDate(date) < todayString) return false;

    let dayShifts = shifts.value.filter(s => s.shiftDate === translateDate(date));
    if (dayShifts.length === 0) return false;
    let shiftSelected = dayShifts.find(s => s.shiftType === props.selectedShift);
    let roomAvailability = props.roomCapacity - shiftSelected.roomShifts.find(r => r.roomName === props.selectedRoom).reservedCapacity;
    if (roomAvailability >= props.selectedPeople) return true;
    return false;
};

const checkYellowDay = (date) => {
    if (translateDate(date) < todayString) return false;

    let dayShifts = shifts.value.filter(s => s.shiftDate === translateDate(date));
    if (dayShifts.length === 0) return false;
    let shiftSelected = dayShifts.find(s => s.shiftType === props.selectedShift);

    return shiftSelected.roomShifts.some(r => {
        let roomAvailability = props.roomCapacity - r.reservedCapacity;
        if (roomAvailability >= props.selectedPeople) {
            return true;
        }
        return false;
    });
};

const checkRedDay = (date) => {
    if (translateDate(date) < todayString) return false;

    let dayShifts = shifts.value.filter(s => s.shiftDate === translateDate(date));
    if (dayShifts.length === 0) return false;
    let shiftSelected = dayShifts.find(s => s.shiftType === props.selectedShift);
    return shiftSelected.roomShifts.some(r => {
        let roomAvailability = props.roomCapacity - r.reservedCapacity;
        if (roomAvailability >= props.selectedPeople) {
            return false;
        }

        return true;
    });
};

const selectDay = (date, isDisabled) => {
    const translatedDate = translateDate(date);
    const dayInfo = {
        day: translatedDate,
        isDisabled: isDisabled
    };
    emit('update:selectedDay', dayInfo);
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
    cursor: not-allowed;
}

.unavailable {
    background-color: #e48383;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: not-allowed;
}
</style>