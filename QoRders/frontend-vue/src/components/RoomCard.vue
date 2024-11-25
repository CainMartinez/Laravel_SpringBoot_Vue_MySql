<template>
    <router-link :to="`/room/${room.slug}`" class="room-card">
        <div class="room-card-image-container">
            <img v-if="room.imageUrl" :src="room.imageUrl" :alt="room.name" class="room-card-image" />
            <div :class="room.theme.toLowerCase()" class="room-card-overlay">
                <h3>{{ room.name.toUpperCase() }}</h3>
            </div>
        </div>
    </router-link>
</template>

<script setup>
defineProps(['room']);
</script>

<style scoped>
.room-card {
    width: 350px;
    height: 175px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    transition: transform 0.2s;
    text-align: center;
    display: block;
    text-decoration: none;
    background-color: #f3f3f3;
    color: #333;
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