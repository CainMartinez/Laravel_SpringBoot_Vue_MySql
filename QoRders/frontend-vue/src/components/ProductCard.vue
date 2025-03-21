<template>
    <div class="product-card">
        <div class="product-card-container">
            <div class="product-image-container">
                <img :src="product.imageUrl" :alt="product.name" class="product-image" />
            </div>

            <div class="product-info">
                <h3>{{ product.name }}</h3>
                <p>{{ product.description }}</p>

                <div class="quantity" v-if="userData && userData.is_seated === true">
                    <button @click="adjustQuantity(product.productId, -1)">-</button>
                    <span>{{ getProductQuantity }}</span>
                    <button @click="adjustQuantity(product.productId, 1)">+</button>
                </div>
            </div>

            <div class="price">{{ parseFloat(product.unitPrice).toFixed(2) }}€</div>
        </div>
        <div>
            <Accordion :activeIndex="null" v-if="product.allergens !== null">
                <AccordionPanel value="0">
                    <AccordionHeader>Alérgenos</AccordionHeader>
                    <AccordionContent>
                        <p class="m-0">
                            {{ product.allergens }}
                        </p>
                    </AccordionContent>
                </AccordionPanel>
            </Accordion>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const userData = computed(() => store.getters['storeAuth/getUserData']?.client);
const props = defineProps({
    product: Object
});

const emit = defineEmits(['adjustQuantity']);

// Obtener la cantidad del producto desde Vuex
const getProductQuantity = computed(() => {
    return store.getters['storeOrders/getProductQuantity'](props.product.productId) || 0;
});

const adjustQuantity = (productId, delta) => {
    const newQuantity = getProductQuantity.value + delta;
    if (newQuantity >= 0) {
        store.dispatch('storeOrders/addProductsToExistingOrder', { 
            productId, 
            quantity: newQuantity 
        });
        emit('adjustQuantity', { productId, quantity: newQuantity });
    }
};
</script>

<style scoped>
.product-card {
    width: 100%;
    background: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    padding: 20px;
    display: flex;
    flex-direction: column;
    background-color: #f3f3f3;
    color: #333;
}

.product-card-container {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.product-image-container {
    width: 50%;
}

.product-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
}

.product-info {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding-left: 10px;
    width: 100%;
}

.product-info h3 {
    font-size: 18px;
    font-weight: bold;
}

.product-info p {
    font-size: 14px;
    color: #555;
}

.quantity {
    display: flex;
    align-items: center;
}

.quantity button {
    padding: 5px;
    font-size: 16px;
    background-color: #f8f9fa;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.quantity span {
    margin: 0 10px;
    font-size: 16px;
}

.price {
    font-size: 16px;
    font-weight: bold;
    color: #333;
}

/* Sobrescritura de estilos del Accordion para forzar fondo blanco y texto negro */
::v-deep .p-accordion {
    width: 100%;
    margin-top: 10px;
    background-color: #ffffff !important;
}

::v-deep .p-accordionheader,
::v-deep .p-accordioncontent,
::v-deep .p-accordionpanel {
    font-size: 14px;
    padding: 10px;
    background-color: #ffffff !important;
    color: #333 !important;
}

/* Override para el hover y el header activo */
::v-deep .p-accordionheader:hover,
::v-deep .p-accordionheader.p-highlight {
    background-color: #e3e2e2 !important;
    color: #333 !important;
}

/* Forzamos que el contenido y su contenedor interno tengan fondo blanco */
::v-deep .p-accordioncontent {
    background-color: #ffffff !important;
    color: #333 !important;
}

::v-deep .p-accordioncontent-content {
    background-color: #ffffff !important;
}

::v-deep .p-accordion p {
    margin: 0;
    background-color: #ffffff !important;
    color: #333 !important;
}
</style>
