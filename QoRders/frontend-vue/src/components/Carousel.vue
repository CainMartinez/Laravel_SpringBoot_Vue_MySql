<template>
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
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const rooms = computed(() => store.getters['storeRooms/getRooms']);
</script>

<style scoped>
.carousel-container {
    margin-bottom: 1em;
    width: 100%;
    height: 90vh;
    position: relative;
    background-color: #f3f3f3;
    color: #333;
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
</style>