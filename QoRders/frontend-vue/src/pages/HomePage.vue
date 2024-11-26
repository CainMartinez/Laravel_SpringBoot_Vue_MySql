<template>
    <div class="home">
        <Carousel />

        <!-- Separador y Flecha -->
        <div class="separator">
            <i class="pi pi-angle-double-down"></i>
            <p>Descubre más destinos</p>
            <i class="pi pi-angle-double-down"></i>
        </div>

        <!-- Cards de las salas -->
        <div class="rooms-cards">
            <RoomCard v-for="room in rooms" :key="room.uuid" :room="room" size="large"/>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';
import Carousel from '../components/Carousel.vue';
import RoomCard from '../components/RoomCard.vue';

const store = useStore();
const rooms = computed(() => store.getters['storeRooms/getRooms']);

console.log("Salas", rooms);

</script>

<style scoped>
.home {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #f3f3f3;
    color: #333;
}

.separator {
    display: flex;
    flex-direction: row;
    text-align: center;
    font-size: 24px;
    justify-content: center;
    align-items: center;
    gap: 100px;
    color: #333;
}

.separator .pi {
    font-size: 1em;
    animation: slideDown 2s infinite;
}

@keyframes slideDown {
    0% {
        transform: translateY(0);
    }

    50% {
        transform: translateY(10px);
    }

    100% {
        transform: translateY(0);
    }
}

.rooms-cards {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    margin-top: 20px;
    margin-bottom: 40px;
    gap: 40px;
}
</style>