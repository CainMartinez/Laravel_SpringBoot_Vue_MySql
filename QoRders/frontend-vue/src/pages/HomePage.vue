<template>
    <div class="home">
        <Carousel :rooms="rooms" />

        <!-- Separador y Flecha -->
        <div class="separator">
            <i class="pi pi-angle-double-down"></i>
            <p>Descubre más destinos</p>
            <i class="pi pi-angle-double-down"></i>
        </div>

        <!-- Cards de todas las salas cargadas desde el inicio -->
        <div class="rooms-cards">
            <RoomCard v-for="room in rooms" :key="room.uuid" :room="room" size="large" />
        </div>
    </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { useStore } from 'vuex';
import Carousel from '../components/Carousel.vue';
import RoomCard from '../components/RoomCard.vue';

// Usar Vuex directamente en lugar del composable que está dando error
const store = useStore();
const rooms = ref([]);

// Función para cargar las salas
const fetchRooms = async () => {
    try {
        await store.dispatch('storeRooms/fetchRooms');
        rooms.value = store.getters['storeRooms/getRooms'];
    } catch (error) {
        console.error('Error al cargar las salas:', error);
    }
};

// Cargar todas las salas al montar el componente
onMounted(() => {
    fetchRooms();
});
</script>

<style scoped>
.home {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: #f3f3f3;
    color: #333;
    min-height: 100vh;
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
    margin: 20px 0;
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
    padding: 0 20px;
}

@media (max-width: 768px) {
    .separator {
        flex-direction: column;
        gap: 20px;
        font-size: 18px;
    }

    .rooms-cards {
        gap: 20px;
        margin-top: 10px;
        margin-bottom: 20px;
    }
}
</style>