<template>
    <div class="shift-select">
        <label for="shift">¿En qué turno?</label>
        <select :value="shift" @change="updateShift($event)" id="shift">
            <option disabled value="">Selecciona un turno</option>
            <option value="Lunch">Comida</option>
            <option value="Dinner">Cena</option>
        </select>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const shift = ref(null);

const emit = defineEmits(['update:selectedShift']);
const updateShift = (event) => {
    emit('update:selectedShift', event.target.value);
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