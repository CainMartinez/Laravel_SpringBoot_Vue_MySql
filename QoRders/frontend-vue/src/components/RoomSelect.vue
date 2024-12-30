<template>
    <div class="room-select">
        <label for="room">Selecciona tu sala:</label>
        <select v-model="selectedRoom" id="room">
            <option disabled value="">Selecciona una sala</option>
            <option v-for="room in rooms" :key="room.slug" :value="room.slug">{{ room.name }}</option>
        </select>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    rooms: Array
});

const emit = defineEmits(['update:modelValue']);
const selectedRoom = ref('');

watch(selectedRoom, (newValue) => {
    emit('update:modelValue', newValue);
});
</script>

<style scoped>
.room-select {
    margin: 20px 0;
}

select {
    padding: 8px;
    font-size: 16px;
    width: 100%;
    max-width: 300px;
}
</style>