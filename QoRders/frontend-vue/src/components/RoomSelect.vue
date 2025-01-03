<template>
    <div class="room-select">
        <label for="room">Selecciona tu sala:</label>
        <Select v-model="selectedRoom" :options="rooms" optionLabel="name" placeholder="Selecciona una sala"
            class="w-full md:w-56" @update:modelValue="changeRoom">
        </Select>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import Select from 'primevue/select';

const props = defineProps({
    rooms: Array
});

const selectedRoom = ref(null);

const emit = defineEmits(['update:selectedRoom']);
const changeRoom = (value) => {
    console.log(value.name);
    emit('update:selectedRoom', value.name);
};

</script>

<style scoped>
.room-select {
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