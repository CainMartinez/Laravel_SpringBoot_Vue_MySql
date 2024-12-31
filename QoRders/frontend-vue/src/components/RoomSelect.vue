<template>
    <div class="room-select">
        <label for="room">Selecciona tu sala:</label>
        <select :value="selectedRoom" id="room" @change="changeRoom($event)">
            <option disabled value="">Selecciona una sala</option>
            <option v-for="room in rooms" :key="room.slug" :value="room.name">{{ room.name }}</option>
        </select>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const props = defineProps({
    rooms: Array
});

const selectedRoom = ref(null);

const emit = defineEmits(['update:selectedRoom']);
const changeRoom = (event) => {
    emit('update:selectedRoom', event.target.value);
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