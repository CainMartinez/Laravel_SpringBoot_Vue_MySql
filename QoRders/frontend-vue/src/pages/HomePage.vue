<template>
    <div class="home">
        <!-- Carousel -->
        <div class="carousel-container" v-if="rooms.length">
            <Carousel :value="rooms" :numVisible="1" :numScroll="1" :showNavigators="false" :showIndicators="false"
                :autoplayInterval="5000" :circular="true">
                <template #item="slotProps">
                    <div class="carousel-image-container">
                        <img :src="slotProps.data.imageUrl" alt="Imagen de la sala" class="carousel-image" />
                        <div :class="slotProps.data.theme.toLowerCase()" class="carousel-overlay">
                            <h2>¿Quieres viajar a {{ slotProps.data.theme }}?</h2>
                        </div>
                    </div>
                </template>
            </Carousel>
        </div>

        <!-- Separador y Flecha -->
        <div class="separator">
            <i class="pi pi-angle-double-down"></i>
            <p>Descubre más destinos</p>
            <i class="pi pi-angle-double-down"></i>
        </div>

        <!-- Cards de las salas -->
        <div class="rooms-cards">
            <router-link v-for="room in rooms" :key="room.uuid" :to="`/sala/${room.slug}`" class="room-card">
                <div class="room-card-image-container">
                    <img v-if="room.imageUrl" :src="room.imageUrl" :alt="room.name" class="room-card-image" />
                    <div :class="room.theme.toLowerCase()" class="room-card-overlay">
                        <h3>{{ room.name.toUpperCase() }}</h3>
                    </div>
                </div>
            </router-link>
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

.room-card {
    width: 500px;
    height: 300px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    background-color: white;
    transition: transform 0.2s;
    text-align: center;
    display: block;
    text-decoration: none;
}

.room-card:hover {
    transform: scale(1.05);
}

.room-card-image-container {
    position: relative;
    width: 100%;
    height: 100%;
}

.room-card-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.room-card-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.4);
    display: flex;
    justify-content: center;
    align-items: center;
}

.room-card-overlay h3 {
    color: white;
    font-size: 30px;
    font-weight: bold;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
    letter-spacing: 2px;
}

.room-card-link {
    display: block;
    text-decoration: none;
    color: inherit;
}
</style>