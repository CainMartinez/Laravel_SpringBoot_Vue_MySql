<template>
    <div :class="room.theme.toLowerCase()" class="menu-page" :style="{ backgroundImage: 'url(' + room.imageUrl + ')' }">
        <h1>Bienvenido a {{ room.theme }}</h1>

        <!-- Filtros -->
        <Filters :selectedType="selectedType" @update:selectedType="selectedType = $event"
            @update:orderBy="orderBy = $event" />

        <!-- Productos -->
        <div class="product-list">
            <ProductCard v-for="product in filteredProducts" :key="product.id" :product="product"
                @adjustQuantity="adjustQuantity" />
        </div>
    </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';
import Filters from '../components/Filters.vue';
import ProductCard from '../components/ProductCard.vue';

const route = useRoute();
const room_slug = computed(() => route.params.slug);

const store = useStore();
const products = computed(() => store.getters['storeProducts/getProductsByRoom']);
const room = computed(() => store.getters['storeRooms/getRoomBySlug']);


// Filtros
const selectedType = ref(null);
const orderBy = ref('asc');

// Filtros de productos
const filteredProducts = computed(() => {
    if (!products.value) return [];

    // Si no hay filtro adicional en el frontend, devuelve los datos directamente
    if (!selectedType.value && orderBy.value === 'asc') {
        return products.value;
    }

    // Ordenar
    let sorted = [...products.value];
    if (orderBy.value === 'asc') {
        sorted = sorted.sort((a, b) => a.price - b.price);
    } else {
        sorted = sorted.sort((a, b) => b.price - a.price);
    }

    // Filtrar solo si el usuario selecciona un tipo adicional
    if (selectedType.value) {
        sorted = sorted.filter((product) => product.productType === selectedType.value);
    }

    return sorted;
});


// console.log("filteredProducts", filteredProducts.value);

// Lógica para ajustar la cantidad del producto
const adjustQuantity = (product, delta) => {
    if (product.quantity + delta >= 0) {
        product.quantity += delta;
    }
};

watch([selectedType, orderBy], ([newType, newOrderBy]) => {
    console.log("Filtros actualizados (watch - MenuPage.vue):", { newType, newOrderBy }); // Debug
    const filters = {};
    if (newOrderBy) {
        filters.order = newOrderBy;
    }
    if (newType) {
        filters.productType = newType;
    }
    store.dispatch('storeProducts/fetchProductsByRoom', {
        room_slug: room_slug.value,
        filters,
    });
});


</script>

<style scoped>
.menu-page {
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: #f7f7f7;
    background-color: rgba(255, 255, 255, 0.497);
    background-blend-mode: lighten;
    max-height: 850px;
    overflow-y: auto;
    color: #333;
}

.menu-page h1 {
    margin-top: 60px;
}

.product-list {
    display: flex;
    flex-direction: column;
    width: 80%;
    max-width: 850px;
    background: rgba(255, 255, 255, 0.9);
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    gap: 30px;
}
</style>