<template>
    <div class="shift-select">
        <label for="shift">¿En qué turno?</label>
        <select :value="shift" @change="updateShift($event)" id="shift">
            <option value="Lunch">Comida</option>
            <option value="Dinner">Cena</option>
            <option value="Both">Ver todo</option>
        </select>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    selectedShift: String
});

const emit = defineEmits(['update:selectedShift']);
const shift = ref(props.selectedShift);

watch(shift, (newValue) => {
    emit('update:selectedShift', newValue);
});

const updateShift = (event) => {
    shift.value = event.target.value;
};
</script>

<style scoped>
.shift-select {
    margin: 20px 0;
}

select {
    padding: 8px;
    font-size: 16px;
    width: 100%;
    max-width: 200px;
}
</style>