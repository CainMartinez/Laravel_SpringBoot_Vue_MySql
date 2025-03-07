<template>
    <div class="carta-page">
        <h1>Elige tu destino</h1>
        <div class="rooms-cards">
            <RoomCard v-for="room in rooms" :key="room.uuid" :room="room" size="medium" />
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRooms } from '../composables/useRooms';
import RoomCard from '../components/RoomCard.vue';

const { allRooms } = useRooms();

const rooms = computed(() => allRooms.value);
</script>

<style scoped>
.carta-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px;
    background-color: #f3f3f3;
    color: #333;
}

.carta-page h1 {
    font-size: 2em;
    margin-top: 60px;
}

.rooms-cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-top: 10px;
    width: 100%;
}

@media (max-width: 1024px) {
    .rooms-cards {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .carta-page {
        padding: 10px;
    }

    .carta-page h1 {
        font-size: 1.5em;
        margin-top: 30px;
    }

    .rooms-cards {
        grid-template-columns: 1fr;
        gap: 10px;
    }
}
</style>