<template>
    <div class="home" @scroll.passive="onScroll" ref="homeContainer">
        <Carousel />

        <!-- Separador y Flecha -->
        <div class="separator">
            <i class="pi pi-angle-double-down"></i>
            <p>Descubre más destinos</p>
            <i class="pi pi-angle-double-down"></i>
        </div>

        <!-- Cards de las salas -->
        <div class="rooms-cards">
            <RoomCard v-for="room in visibleRooms" :key="room.uuid" :room="room" size="large"/>
        </div>

        <!-- Cargando -->
        <div v-if="loading" class="loading-indicator">
            <i class="pi pi-spin pi-spinner"></i> Cargando más salas...
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import Carousel from '../components/Carousel.vue';
import RoomCard from '../components/RoomCard.vue';

const store = useStore();
const allRooms = computed(() => store.getters['storeRooms/getRooms']);

const visibleRooms = ref([]);
const currentPage = ref(0);
const pageSize = 1;
const loading = ref(false);

const loadMoreRooms = () => {
    if (loading.value) return;
    loading.value = true;

    // Simular una carga de datos con un timeout
    setTimeout(() => {
        const start = currentPage.value * pageSize;
        const end = start + pageSize;

        // Añadir más elementos a la lista visible
        visibleRooms.value.push(...allRooms.value.slice(start, end));

        currentPage.value++;
        loading.value = false;
    }, 500);
};

const onScroll = () => {
    const container = document.documentElement || document.body;
    const scrollTop = container.scrollTop;
    const scrollHeight = container.scrollHeight;
    const clientHeight = container.clientHeight;

    // Verificar si el usuario está cerca del final del scroll
    if (scrollTop + clientHeight >= scrollHeight - 100 && !loading.value) {
        loadMoreRooms();
    }
};

// Inicializar la carga de datos
onMounted(() => {
    loadMoreRooms();
});
</script>

<style scoped>
.home {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #f3f3f3;
    color: #333;
    height: 100vh; /* Necesario para habilitar el scroll */
    overflow-y: auto; /* Habilitar scroll interno */
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