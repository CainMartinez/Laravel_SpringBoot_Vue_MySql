<template>
    <h1>Gestión de la Carta</h1>
</template>
<script setup>
import { ref, computed } from 'vue';

const rooms = computed(() => store.getters['storeAdmin/getAllRooms'].data);
const products = computed(() => store.getters['adminStore/getAllProducts']);
console.log("Products");
console.log(products.value);
console.log("Rooms");
console.log(rooms.value);

</script>
<style scoped></style>