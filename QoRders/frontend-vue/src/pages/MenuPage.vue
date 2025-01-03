<template>
    <div :class="room.theme.toLowerCase()" class="menu-page" :style="{ backgroundImage: 'url(' + room.imageUrl + ')' }">
        <h1>Bienvenido a {{ room.theme }}</h1>

        <!-- Filtros -->
        <Filters :selectedType="selectedType" :orderBy="orderBy" @update:selectedType="setProductType"
            @update:orderBy="setOrderBy" @resetFilters="resetFilters(room_slug.value)" />

        <!-- Productos -->
        <div class="product-list">
            <ProductCard v-for="product in filteredProducts" :key="product.id" :product="product"
                @adjustQuantity="adjustQuantity" />
        </div>

        <!-- Paginador -->
        <Paginator v-if="totalProducts > pageSize" :rows="pageSize" :totalRecords="totalProducts" :first="offset"
            @page="onPageChange" />

        <!-- Scroll to Top -->
        <ScrollTop target=".product-list" :threshold="100"
            style="--scrolltop-size: 3rem; --scrolltop-border-radius: 50%;" />
    </div>
</template>

<script setup>
import { computed, watch, ref } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';
import Filters from '../components/Filters.vue';
import ProductCard from '../components/ProductCard.vue';
import useFilters from '../composables/useFilters';
import usePagination from '../composables/usePagination';

const route = useRoute();
const room_slug = computed(() => route.params.slug);

const store = useStore();
const products = computed(() => store.getters['storeProducts/getProductsByRoom']);
const totalProducts = computed(() => store.getters['storeProducts/getTotalProducts']);
const room = computed(() => store.getters['storeRooms/getRoomBySlug']);

// Actualización de datos en Vuex
const updateStore = () => {
    if (!room_slug.value) {
        console.error("room_slug no está definido.");
        return;
    }

    const filters = {
        limit: pageSize.value,
        offset: offset.value,
        order: orderBy.value,
        productType: selectedType.value,
    };

    store.dispatch('storeProducts/fetchProductsByRoom', { room_slug: room_slug.value, filters });
};

// Filtros
const { selectedType, orderBy, filteredProducts, setProductType, setOrderBy, resetFilters } = useFilters(products, updateStore);

// Paginación
const { currentPage, pageSize, offset, onPageChange } = usePagination();

// Función para ajustar la cantidad del producto
const adjustQuantity = (product, delta) => {
    if (product.quantity + delta >= 0) {
        product.quantity += delta;
    }
};

// Watchers para los filtros y la paginación
watch([selectedType, orderBy, currentPage], updateStore);
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