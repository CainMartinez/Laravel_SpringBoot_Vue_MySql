<template>
    <div class="people-select">
        <label for="people">¿Cuántos sois?</label>
        <InputNumber v-model="people" inputId="horizontal-buttons" showButtons buttonLayout="horizontal" :step="1" fluid
            @change="updatePeople">
            <template #incrementbuttonicon>
                <span class="pi pi-plus" />
            </template>
            <template #decrementbuttonicon>
                <span class="pi pi-minus" />
            </template>
        </InputNumber>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import InputNumber from 'primevue/inputnumber';

const people = ref(2);

const emit = defineEmits(['update:selectedPeople']);
const updatePeople = (event) => {
    emit('update:selectedPeople', event.value);
};
</script>

<style scoped>
.people-select {
    margin: 20px 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 10px;
    font-size: 18px;
}

input {
    padding: 8px;
    font-size: 16px;
    width: 100%;
    max-width: 400px;
}
</style>