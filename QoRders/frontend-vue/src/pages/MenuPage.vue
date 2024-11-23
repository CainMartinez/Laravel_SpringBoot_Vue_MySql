<template>
    <div class="menu-page">
        <h1>Bienvenido a {{ countryName }}</h1>

        <!-- Filtros -->
        <div class="filters">
            <div>
                <label for="price">Precio</label>
                <input type="range" id="price" min="0" max="50" v-model="priceRange" />
                <span>{{ priceRange }}€</span>
            </div>
            <div>
                <label>Tipo de producto</label>
                <div>
                    <input type="radio" id="entrantes" value="entrantes" v-model="selectedType" />
                    <label for="entrantes">Entrantes</label>
                </div>
                <div>
                    <input type="radio" id="principales" value="principales" v-model="selectedType" />
                    <label for="principales">Principales</label>
                </div>
                <div>
                    <input type="radio" id="postres" value="postres" v-model="selectedType" />
                    <label for="postres">Postres</label>
                </div>
                <div>
                    <input type="radio" id="bebidas" value="bebidas" v-model="selectedType" />
                    <label for="bebidas">Bebidas</label>
                </div>
            </div>
        </div>

        <!-- Productos -->
        <div class="product-list">
            <div v-for="product in products" :key="product.id" class="product-card">
                <img :src="product.imageUrl" :alt="product.name" class="product-image" />
                <div class="product-info">
                    <h3>{{ product.name }}</h3>
                    <p>{{ product.description }}</p>
                    <p>{{ product.price }}€</p>
                    <div> <!-- Solo se muestra si hay usuario -->
                        <button @click="adjustQuantity(product, -1)">-</button>
                        <span>{{ product.quantity }}</span>
                        <button @click="adjustQuantity(product, 1)">+</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useRoute } from 'vue-router';

const route = useRoute();
const room_slug = computed(() => route.params.slug);

const store = useStore();
const products = computed(() => store.getters['storeProducts/getProductsByRoom']);
console.log("products", products.value);

const countryName = ref('España');

// Filtros
const priceRange = ref(50);
const selectedType = ref(null);

// Filtros de productos
const filteredProducts = computed(() => {
    return products.value.filter(product => {
        const matchesType = selectedType.value ? product.type === selectedType.value : true;
        const matchesPrice = product.price <= priceRange.value;
        return matchesType && matchesPrice;
    });
});

// Lógica para ajustar la cantidad del producto
const adjustQuantity = (product, delta) => {
    if (product.quantity + delta >= 0) {
        product.quantity += delta;
    }
};

onMounted(() => {

});

</script>

<style scoped>
.menu-page {
    padding: 20px;
}

.menu-page h1 {
    margin-top: 60px;
}

.filters {
    margin-bottom: 20px;
}

.filters input[type="range"] {
    width: 100%;
}

.product-list {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
}

.product-card {
    width: 250px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    padding: 10px;
}

.product-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
}

.product-info {
    padding: 10px;
}

.product-info h3 {
    font-size: 18px;
}

.product-info p {
    font-size: 14px;
}

button {
    margin: 5px;
    padding: 5px 10px;
}
</style>