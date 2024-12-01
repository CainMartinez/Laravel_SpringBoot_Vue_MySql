<template>
    <div class="home" @scroll.passive="onScroll" ref="homeContainer">
        <Carousel :rooms="allRooms" />

        <!-- Separador y Flecha -->
        <div class="separator">
            <i class="pi pi-angle-double-down"></i>
            <p>Descubre más destinos</p>
            <i class="pi pi-angle-double-down"></i>
        </div>

        <!-- Cards de las salas -->
        <div class="rooms-cards">
            <RoomCard v-for="room in visibleRooms" :key="room.uuid" :room="room" size="large" />
        </div>

        <!-- Cargando -->
        <div v-if="loading" class="loading-indicator">
            <i class="pi pi-spin pi-spinner"></i> Cargando más salas...
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRooms } from '../composables/useRooms';
import useScroll from '../composables/useScroll';
import Carousel from '../components/Carousel.vue';
import RoomCard from '../components/RoomCard.vue';

const { allRooms } = useRooms();
const { visibleItems, loadMoreItems, loading } = useScroll({ totalItems: allRooms, pageSize: 1 });

const visibleRooms = ref([]);
visibleRooms.value = visibleItems.value;

const onScroll = () => {
    const container = document.documentElement || document.body;
    const scrollTop = container.scrollTop;
    const scrollHeight = container.scrollHeight;
    const clientHeight = container.clientHeight;

    if (scrollTop + clientHeight >= scrollHeight - 100 && !loading.value) {
        loadMoreItems();
    }
};

onMounted(() => {
    loadMoreItems();
});
</script>

<style scoped>
.home {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #f3f3f3;
    color: #333;
    height: 100vh;
    overflow-y: auto;
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

.loading-indicator {
    text-align: center;
    margin: 20px;
    font-size: 16px;
    color: #666;
}
</style>