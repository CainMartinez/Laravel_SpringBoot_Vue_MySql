<template>
    <h1>Gestión de la Carta</h1>
</template>
<script setup>
import { ref, computed } from 'vue';

const products = computed(() => store.getters['adminStore/getAllProducts']);

console.log("Products" + products.value);
</script>
<style scoped></style>