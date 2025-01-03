<template>
    <div class="card flex justify-center">
        <label for="room">Selecciona un turno:</label>
        <Select v-model="selectedShift" :options="shifts" optionLabel="name" placeholder="Selecciona un turno"
            class="w-full md:w-56" @change="updateShift" />
    </div>
</template>

<script setup>
import { ref } from 'vue';

const selectedShift = ref(null);
const shifts = ref([
    { name: 'Comida', code: 'Lunch' },
    { name: 'Cena', code: 'Dinner' }
]);

const emit = defineEmits(['update:selectedShift']);
const updateShift = (event) => {
    emit('update:selectedShift', event.value);
};
</script>

<style scoped>
.card {
    margin: 20px 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 10px;
    font-size: 18px;
}

select {
    padding: 8px;
    font-size: 16px;
    width: 100%;
    max-width: 400px;
}
</style>