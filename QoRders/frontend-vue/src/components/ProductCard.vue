<template>
    <div class="product-card" :class="originClass">
        <div class="product-image-container">
            <img :src="product.imageUrl" :alt="product.name" class="product-image" />
            <div class="price-tag">{{ parseFloat(product.unitPrice).toFixed(2) }}€</div>
            <div class="origin-badge" v-if="product.origin">{{ product.origin }}</div>
        </div>

        <div class="product-content">
            <div class="product-header">
                <h3 :class="countryFontClass">{{ product.name }}</h3>
                <p class="product-description">{{ product.description }}</p>
            </div>

            <div class="product-footer">
                <!-- Alérgenos a la izquierda -->
                <div class="allergens-container" v-if="product.allergens">
                    <button class="allergens-button" @click="showAllergens = !showAllergens">
                        <i class="pi pi-exclamation-triangle"></i>
                        <span>Alérgenos</span>
                    </button>
                    <div class="allergens-content" v-if="showAllergens">
                        {{ product.allergens }}
                    </div>
                </div>
                
                <!-- Espaciador flexible que empuja los controles a la derecha -->
                <div class="flex-spacer"></div>
                
                <!-- Controles de cantidad a la derecha -->
                <div class="quantity-control" v-if="userData && userData.is_seated === true">
                    <button 
                        class="quantity-button decrease" 
                        @click="adjustQuantity(product.productId, -1)"
                        :disabled="getProductQuantity === 0"
                    >
                        <i class="pi pi-minus"></i>
                    </button>
                    <span class="quantity-display">{{ getProductQuantity }}</span>
                    <button 
                        class="quantity-button increase" 
                        @click="adjustQuantity(product.productId, 1)"
                    >
                        <i class="pi pi-plus"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, ref, onMounted, onBeforeUnmount } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const userData = computed(() => store.getters['storeAuth/getUserData']?.client);
const props = defineProps({
    product: Object
});

const emit = defineEmits(['adjustQuantity']);
const showAllergens = ref(false);

// Clase condicional basada en el origen del producto
const originClass = computed(() => {
    if (!props.product.origin) return '';
    
    const origin = props.product.origin.toLowerCase();
    if (origin.includes('españa') || origin.includes('espana')) return 'spain-theme';
    if (origin.includes('méxico') || origin.includes('mexico')) return 'mexico-theme';
    if (origin.includes('india')) return 'india-theme';
    if (origin.includes('japón') || origin.includes('japon')) return 'japan-theme';
    if (origin.includes('turquía') || origin.includes('turquia')) return 'turkey-theme';
    if (origin.includes('italia')) return 'italy-theme';
    
    return '';
});

// Clase de fuente basada en el origen del producto
const countryFontClass = computed(() => {
    if (!props.product.origin) return '';
    
    const origin = props.product.origin.toLowerCase();
    if (origin.includes('españa') || origin.includes('espana')) return 'españa';
    if (origin.includes('méxico') || origin.includes('mexico')) return 'méxico';
    if (origin.includes('india')) return 'india';
    if (origin.includes('japón') || origin.includes('japon')) return 'japón';
    if (origin.includes('turquía') || origin.includes('turquia')) return 'turquía';
    if (origin.includes('italia')) return 'italia';
    
    return '';
});

// Obtener la cantidad del producto desde Vuex
const getProductQuantity = computed(() => {
    return store.getters['storeOrders/getProductQuantity'](props.product.productId) || 0;
});

const adjustQuantity = (productId, delta) => {
    const newQuantity = getProductQuantity.value + delta;

    if (newQuantity > 0) {
        // Actualizar store cuando la cantidad es > 0
        store.dispatch('storeOrders/addProductsToExistingOrder', { 
            productId, 
            quantity: newQuantity 
        });
        
        // Emitir el evento para que el componente padre actualice también
        emit('adjustQuantity', { productId, quantity: newQuantity });
    } else if (newQuantity === 0) {
        // Eliminar producto del store cuando cantidad = 0
        store.dispatch('storeOrders/removeProduct', productId);
        
        // Emitir el evento para que el componente padre actualice también
        emit('adjustQuantity', { productId, quantity: 0 });
    }
};

// Escuchar eventos de reset
onMounted(() => {
    window.addEventListener('reset-product-quantities', resetQuantity);
});

onBeforeUnmount(() => {
    window.removeEventListener('reset-product-quantities', resetQuantity);
});

const resetQuantity = () => {
    if (props.product && props.product.productId) {
        store.dispatch('storeOrders/removeProduct', props.product.productId);
    }
};
</script>

<style scoped>
/* Estilos base */
.product-card {
    width: 100%;
    background: white;
    border-radius: 12px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    position: relative;
}

.product-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 25px rgba(0, 0, 0, 0.1);
}

.product-image-container {
    position: relative;
    width: 100%;
    height: 180px;
    overflow: hidden;
}

.product-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.product-card:hover .product-image {
    transform: scale(1.05);
}

.origin-badge {
    position: absolute;
    bottom: 8px;
    left: 8px;
    padding: 4px 10px;
    border-radius: 15px;
    font-size: 0.8rem;
    font-weight: 600;
    background: rgba(255, 255, 255, 0.85);
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.price-tag {
    position: absolute;
    top: 12px;
    right: 12px;
    background-color: #FF9F1C;
    color: white;
    padding: 6px 12px;
    border-radius: 20px;
    font-weight: 600;
    font-size: 14px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.product-content {
    padding: 20px;
    display: flex;
    flex-direction: column;
    height: 100%;
}

.product-header {
    margin-bottom: 15px;
}

.product-header h3 {
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 8px;
    color: #333;
}

/* Aplicación de las fuentes específicas por país */
.product-header h3.españa {
    font-family: var(--font-spain);
    letter-spacing: 2px;
}

.product-header h3.méxico {
    font-family: var(--font-mexico);
    letter-spacing: 2px;
}

.product-header h3.india {
    font-family: var(--font-india);
    letter-spacing: 1px;
}

.product-header h3.japón {
    font-family: var(--font-japan);
    letter-spacing: 1px;
}

.product-header h3.turquía {
    font-family: var(--font-turkey);
    letter-spacing: 1px;
}

.product-header h3.italia {
    font-family: var(--font-italy);
    letter-spacing: 1px;
}

.product-description {
    font-size: 14px;
    color: #666;
    line-height: 1.4;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.product-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.allergens-container {
    position: relative;
}

.allergens-button {
    display: flex;
    align-items: center;
    background: #f3f3f3;
    border: none;
    padding: 6px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
    transition: background-color 0.2s;
}

.allergens-button:hover {
    background-color: #e8e8e8;
}

.allergens-button i {
    margin-right: 5px;
    color: #e67e22;
}

.allergens-content {
    position: absolute;
    bottom: 100%;
    left: 0;
    background: white;
    padding: 12px;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    width: 200px;
    margin-bottom: 8px;
    font-size: 13px;
    color: #333;
    z-index: 10;
}

.quantity-control {
    display: flex;
    align-items: center;
    background: #f8f9fa;
    border-radius: 8px;
    padding: 2px;
}

.quantity-button {
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border: none;
    background: transparent;
    cursor: pointer;
    color: #333;
    border-radius: 6px;
    transition: all 0.2s;
}

.quantity-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.quantity-button.increase {
    background-color: #4CAF50;
    color: white;
}

.quantity-button.decrease {
    background-color: #f44336;
    color: white;
}

.quantity-button:hover:not(:disabled) {
    transform: scale(1.05);
}

.quantity-display {
    min-width: 30px;
    text-align: center;
    font-weight: 600;
    font-size: 16px;
}

/* Estilos temáticos por país */

/* España */
.spain-theme {
    background: linear-gradient(to bottom, #fff9f0, #fff);
    border: 1px solid #ffcc00;
}

.spain-theme .product-content {
    background-color: #fff9f0;
}

.spain-theme .price-tag {
    background-color: #c60b1e;
}

.spain-theme .quantity-control {
    background-color: #f5e7cc;
}

.spain-theme .quantity-button.increase {
    background-color: #c60b1e;
}

.spain-theme .allergens-button {
    background-color: #ffde59;
    color: #9e161b;
}

.spain-theme .origin-badge {
    background-color: rgba(255, 223, 89, 0.9);
    color: #9e161b;
}

.spain-theme::after {
    content: "";
    position: absolute;
    top: 0;
    right: 0;
    border-width: 0 20px 20px 0;
    border-style: solid;
    border-color: #c60b1e #fff;
}

/* México */
.mexico-theme {
    background: linear-gradient(to bottom, #fcf6ee, #fff);
    border: 1px solid #006341;
}

.mexico-theme .product-content {
    background-color: #fcf6ee;
}

.mexico-theme .price-tag {
    background-color: #ce1126;
}

.mexico-theme .quantity-control {
    background-color: #f3e9d7;
}

.mexico-theme .quantity-button.increase {
    background-color: #006341;
}

.mexico-theme .allergens-button {
    background-color: #fbfbfb;
    color: #006341;
    border: 1px solid #006341;
}

.mexico-theme .origin-badge {
    background-color: rgba(0, 99, 65, 0.9);
    color: white;
}

.mexico-theme::after {
    content: "";
    position: absolute;
    top: 0;
    right: 0;
    width: 30px;
    height: 30px;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="%23ce1126"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>');
    background-size: contain;
}

/* India */
.india-theme {
    background: linear-gradient(to bottom, #f8f1e5, #fff);
    border: 1px solid #f93;
}

.india-theme .product-content {
    background-color: #f8f1e5;
}

.india-theme .price-tag {
    background-color: #f93;
}

.india-theme .quantity-control {
    background-color: #e6dacb;
}

.india-theme .quantity-button.increase {
    background-color: #138808;
}

.india-theme .allergens-button {
    background-color: #f8f8f8;
    color: #000080;
    border: 1px solid #f93;
}

.india-theme .origin-badge {
    background-color: rgba(255, 153, 51, 0.9);
    color: #000080;
}

.india-theme::before {
    content: "";
    position: absolute;
    width: 40px;
    height: 40px;
    background-image: radial-gradient(circle, transparent 60%, #f93 60%);
    background-size: 10px 10px;
    top: 10px;
    left: 10px;
    z-index: 1;
    opacity: 0.7;
}

/* Japón */
.japan-theme {
    background-color: #ffffff;
    border: 1px solid #e5e5e5;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.japan-theme .product-content {
    background-color: #ffffff;
}

.japan-theme .price-tag {
    background-color: #bc002d;
}

.japan-theme .quantity-control {
    background-color: #f5f5f5;
    border: 1px solid #ddd;
}

.japan-theme .quantity-button.increase {
    background-color: #bc002d;
}

.japan-theme .allergens-button {
    background-color: #f0f0f0;
    color: #333;
}

.japan-theme .origin-badge {
    background-color: rgba(188, 0, 45, 0.9);
    color: white;
}

.japan-theme .product-header h3 {
    border-bottom: 1px solid #eee;
    padding-bottom: 5px;
}

/* Turquía */
.turkey-theme {
    background: linear-gradient(to bottom, #f5f1e9, #fff);
    border: 1px solid #e30a17;
}

.turkey-theme .product-content {
    background-color: #f5f1e9;
}

.turkey-theme .price-tag {
    background-color: #e30a17;
}

.turkey-theme .quantity-control {
    background-color: #e8e2d3;
}

.turkey-theme .quantity-button.increase {
    background-color: #1d5ea8;
}

.turkey-theme .allergens-button {
    background-color: #f5f5f5;
    color: #e30a17;
    border: 1px solid #c7c7c7;
}

.turkey-theme .origin-badge {
    background-color: rgba(227, 10, 23, 0.9);
    color: white;
}

.turkey-theme::after {
    content: "";
    position: absolute;
    bottom: 0;
    right: 0;
    width: 50px;
    height: 50px;
    background-image: radial-gradient(circle at center, #e30a17 30%, transparent 31%);
    background-size: 15px 15px;
    opacity: 0.2;
}

/* Italia */
.italy-theme {
    background: linear-gradient(to bottom, #f7f3ee, #fff);
    border: 1px solid #008C45;
}

.italy-theme .product-content {
    background-color: #f7f3ee;
}

.italy-theme .price-tag {
    background-color: #cd212a;
}

.italy-theme .quantity-control {
    background-color: #ece7de;
}

.italy-theme .quantity-button.increase {
    background-color: #008C45;
}

.italy-theme .allergens-button {
    background-color: #f2f2f2;
    color: #cd212a;
}

.italy-theme .origin-badge {
    background-color: rgba(0, 140, 69, 0.9);
    color: white;
}

.italy-theme::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    border-width: 15px 15px 0 0;
    border-style: solid;
    border-color: #cd212a transparent;
}
.product-footer {
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    width: 100%;
}

.flex-spacer {
    flex: 1;
}

/* Si solo hay alérgenos, alinear a la izquierda */
.product-footer:has(.allergens-container:only-child) {
    justify-content: flex-start;
}

/* Si solo hay controles de cantidad, alinear a la derecha */
.product-footer:has(.quantity-control:only-child) {
    justify-content: flex-end;
}

/* Ajuste para navegadores que no soportan :has() */
@supports not (selector(:has(.allergens-container))) {
    .allergens-container:only-child {
        margin-right: auto;
    }
    
    .quantity-control:only-child {
        margin-left: auto;
    }
}

/* Mejoras en el diseño responsive para móviles */
@media (max-width: 768px) {
    .product-card {
        flex-direction: row;
        height: auto;
        min-height: 120px;
    }
    .product-footer {
        flex-wrap: wrap;
        gap: 8px;
    }
    
    /* Asegurar que en móviles, los controles estén a la derecha si no hay alérgenos */
    .quantity-control:only-child {
        margin-left: auto;
    }
    .product-image-container {
        width: 120px;
        height: 120px;
        min-width: 120px; /* Evita que se comprima */
    }
    
    .product-content {
        width: calc(100% - 120px);
        padding: 12px;
        justify-content: space-between;
    }
    
    .product-header {
        margin-bottom: 8px;
    }
    
    .product-header h3 {
        font-size: 16px;
        margin-bottom: 4px;
    }
    
    .product-description {
        -webkit-line-clamp: 2;
        font-size: 12px;
        margin-bottom: 8px;
    }
    
    .quantity-button {
        width: 28px;
        height: 28px;
    }
    
    .allergens-button {
        padding: 4px 8px;
        font-size: 11px;
    }
    
    .allergens-button span {
        display: none;
    }
    
    .allergens-button i {
        margin-right: 0;
    }
    
    .allergens-content {
        width: 150px;
        font-size: 11px;
        right: 0;
        left: auto;
    }
    
    .price-tag {
        top: 8px;
        right: 8px;
        padding: 4px 8px;
        font-size: 12px;
    }
    
    .origin-badge {
        bottom: 5px;
        left: 5px;
        padding: 2px 8px;
        font-size: 0.75rem;
    }
}

/* Para pantallas muy pequeñas */
@media (max-width: 375px) {
    .product-image-container {
        width: 100px;
        height: 100px;
        min-width: 100px;
    }
    
    .product-content {
        width: calc(100% - 100px);
        padding: 8px;
    }
    .product-footer:has(.allergens-container):has(.quantity-control) {
            flex-direction: column;
            align-items: flex-start;
            gap: 10px;
        }
        
    .product-footer:has(.allergens-container):has(.quantity-control) .quantity-control {
        align-self: flex-end;
    }
}
</style>