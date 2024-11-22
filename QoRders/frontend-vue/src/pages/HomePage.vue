<template>
    <div class="home">
        <!-- Carousel -->
        <div class="carousel-container" v-if="rooms.length">
            <Carousel :value="rooms" :numVisible="1" :numScroll="1" :showNavigators="false" :showIndicators="false"
                :autoplayInterval="3000">
                <template #item="slotProps">
                    <div class="carousel-image-container">
                        <img :src="slotProps.data.imageUrl" alt="Imagen de la sala" class="carousel-image" />
                        <div class="carousel-overlay">
                            <h2>¿Quieres viajar a {{ slotProps.data.theme }}?</h2>
                        </div>
                    </div>
                </template>
            </Carousel>
        </div>

        <!-- Separador y Flecha -->
        <div class="separator">
            <p>Descubre más destinos</p>
            <i class="pi pi-arrow-down"></i>
        </div>

        <!-- Cards de las salas -->
        <div class="rooms-cards">
            <div v-for="room in rooms" :key="room.id" class="room-card">
                <img v-if="room.imageUrl" :src="room.imageUrl" :alt="room.name" class="room-card-image" />
                <div class="room-card-info">
                    <h1>{{ room.name }}</h1>
                    <router-link :to="`/sala/${room.slug}`" class="room-card-link">Ver Carta</router-link>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const rooms = computed(() => store.getters.rooms);

console.log("Salas", rooms);

onMounted(() => {
    store.dispatch('fetchRooms');
});
</script>

<style scoped>
.home {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.carousel-container {
    margin-bottom: 1em;
    width: 100%;
    height: 90vh;
    position: relative;
}

.carousel-image-container {
    position: relative;
    width: 100%;
    height: 90vh;
}

.carousel-image {
    width: 100%;
    height: 90vh;
    object-fit: cover;
}

.carousel-overlay {
    position: absolute;
    bottom: 20px;
    left: 50%;
    transform: translateX(-50%);
    background-color: rgba(0, 0, 0, 0.6);
    color: white;
    font-size: 2rem;
    text-align: center;
    width: 100%;
}

.separator {
    text-align: center;
    margin-top: 20px;
}

.rooms-cards {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    margin-top: 20px;
    gap: 20px;
}

.room-card {
    width: 250px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    background-color: white;
    transition: transform 0.2s;
    text-align: center;
}

.room-card:hover {
    transform: scale(1.05);
}

.room-card-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
}

.room-card-info {
    padding: 10px;
}

.room-card-info h1 {
    font-size: 24px;
    margin-bottom: 10px;
}

.room-card-link {
    text-decoration: none;
    color: #007bff;
    font-weight: bold;
}

.room-card-link:hover {
    text-decoration: underline;
}
</style>