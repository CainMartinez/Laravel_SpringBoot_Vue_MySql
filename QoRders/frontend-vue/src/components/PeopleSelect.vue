<template>
    <div class="people-select">
        <label for="people">¿Cuántos sois?</label>
        <input type="number" :value="people" @change="updatePeople($event)" min="2" max="10" id="people" />
    </div>
</template>

<script setup>
import { ref } from 'vue';

const people = ref(2);

const emit = defineEmits(['update:selectedPeople']);
const updatePeople = (event) => {
    emit('update:selectedPeople', event.target.value);
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