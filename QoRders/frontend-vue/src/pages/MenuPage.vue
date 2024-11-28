<template>
    <div :class="room.theme.toLowerCase()" class="menu-page" :style="{ backgroundImage: 'url(' + room.imageUrl + ')' }">
        <h1>Bienvenido a {{ room.theme }}</h1>

        <!-- Filtros -->
        <Filters 
            :selectedType="selectedType" 
            @update:selectedType="selectedType = $event"
            @update:orderBy="orderBy = $event" 
        />

        <!-- Productos -->
        <div class="product-list">
            <ProductCard 
                v-for="product in productsByRoom" 
                :key="product.id" 
                :product="product" 
                @adjustQuantity="adjustQuantity" 
            />
        </div>

        <!-- Paginador -->
        <Paginator 
            :rows="pageSize" 
            :totalRecords="totalProducts" 
            :first="offset" 
            @page="onPageChange" 
        />

        <!-- Scroll to Top -->
        <ScrollTop target=".product-list" :threshold="100" style="--scrolltop-size: 3rem; --scrolltop-border-radius: 50%;" />
    </div>
</template>

<script setup>
import { computed, ref, watch } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';
import Filters from '../components/Filters.vue';
import ProductCard from '../components/ProductCard.vue';
import Paginator from 'primevue/paginator';

const route = useRoute();
const room_slug = computed(() => route.params.slug);

const store = useStore();
const productsByRoom = computed(() => store.getters['storeProducts/getProductsByRoom']);
const totalProducts = computed(() => store.getters['storeProducts/getTotalProducts']);
const room = computed(() => store.getters['storeRooms/getRoomBySlug']);

// Filtros
const selectedType = ref(null);
const orderBy = ref(null);

// Paginación
const currentPage = ref(0);
const pageSize = ref(10);
const offset = computed(() => currentPage.value * pageSize.value);

const onPageChange = (event) => {
    currentPage.value = event.page;
};

// Ver cambios en filtros o paginación
watch([room_slug, currentPage, pageSize, orderBy, selectedType], ([newSlug, newPage, newSize, newOrder, newType]) => {
    const limit = newSize;
    const offsetValue = newPage * newSize;

    store.dispatch('storeProducts/fetchProductsByRoom', {
        room_slug: newSlug,
        filters: {
            limit,
            offset: offsetValue,
            order: newOrder,
            productType: newType,
        },
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