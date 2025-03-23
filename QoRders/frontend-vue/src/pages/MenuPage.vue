<template>
    <div :class="['menu-page', room.theme.toLowerCase() + '-theme']" 
         :style="{ backgroundImage: 'url(' + room.imageUrl + ')' }">
        <div class="theme-overlay"></div>
        
        <div class="content-container">
            <h1 :class="room.theme.toLowerCase()">Bienvenido a {{ room.theme }}</h1>

            <!-- Filtros -->
            <Filters :selectedType="selectedType" 
                :orderBy="orderBy" 
                :theme="room.theme"
                @update:selectedType="setProductType"
                @update:orderBy="setOrderBy" 
                @resetFilters="resetFilters(room_slug.value)" />

            <!-- Productos -->
            <div class="product-list">
                <ProductCard v-for="product in filteredProducts" 
                            :key="product.id + '-' + refreshKey" 
                            :product="product"
                            :refresh-trigger="refreshKey"
                            @adjustQuantity="adjustQuantity" />
            </div>

            <!-- Paginador -->
            <Paginator v-if="totalProducts > pageSize" 
                :rows="pageSize" 
                :totalRecords="totalProducts" 
                :first="offset"
                :theme="room.theme"
                @page="onPageChange" 
                class="themed-paginator" />

            <div v-if="userData && userData.is_seated === true" class="order-buttons">
                <Button 
                    label="Crear un Pedido" 
                    icon="pi pi-check" 
                    @click="handleSubmitOrder"
                    :disabled="!hasProductsInCart"
                    class="order-button create-order" />
                    
                <Button 
                    label="Pagar" 
                    icon="pi pi-dollar" 
                    @click="handlePayOrder" 
                    class="order-button pay-order" />
            </div>

            <!-- Scroll to Top -->
            <ScrollTop target=".product-list" 
                      :threshold="100"
                      class="scroll-top" />

            <Modal v-model:visible="isModalVisible" 
                  :message="modalMessage" 
                  :title="modalTitle" />
        </div>
    </div>
</template>

<script setup>
import { computed, watch, ref, onMounted, nextTick } from 'vue';
import { useStore } from 'vuex';
import { useRoute, useRouter } from 'vue-router';
import Filters from '../components/Filters.vue';
import ProductCard from '../components/ProductCard.vue';
import useFilters from '../composables/useFilters';
import usePagination from '../composables/usePagination';
import useOrders from '../composables/useOrders';
import Modal from '../components/Modal.vue';

const route = useRoute();
const room_slug = computed(() => route.params.slug);

const store = useStore();
const router = useRouter();
const products = computed(() => store.getters['storeProducts/getProductsByRoom']);
const totalProducts = computed(() => store.getters['storeProducts/getTotalProducts']);
const room = computed(() => store.getters['storeRooms/getRoomBySlug']);
const userData = computed(() => store.getters['storeAuth/getUserData']?.client);
const { createOrder, addProductsToExistingOrder, submitOrder, fetchOrder } = useOrders();
const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');

// Clave para forzar la re-renderización de los componentes ProductCard
const refreshKey = ref(0);

// Estado del pedido actual para controlar los botones
const orderStatus = ref(null);
const orderProducts = ref([]);

// Comprobar si hay productos en el carrito
const hasProductsInCart = computed(() => {
    const productsInCart = store.getters['storeOrders/getOrderProducts'] || [];
    return productsInCart.length > 0;
});

// Comprobar si se puede pagar (hay un pedido entregado)
const canPayOrder = computed(() => {
    return orderStatus.value === 'Delivered';
});

// Comprobar si hay un pedido en curso
const hasActivePendingOrder = computed(() => {
    return orderStatus.value === 'Pending';
});

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

// Verificar el estado del pedido al cargar
const checkOrderStatus = async () => {
    try {
        const response = await fetchOrder();
        orderStatus.value = response.orderStatus;
        orderProducts.value = response.orderProducts || [];
    } catch (error) {
        console.error("Error al verificar el estado del pedido:", error);
    }
};

// Filtros
const { selectedType, orderBy, filteredProducts, setProductType, setOrderBy, resetFilters } = useFilters(products, updateStore);

// Paginación
const { currentPage, pageSize, offset, onPageChange } = usePagination();

// Función para ajustar la cantidad del producto
const adjustQuantity = async ({ productId, quantity }) => {
    await store.dispatch('storeOrders/addProductsToExistingOrder', { productId, quantity });
    // Forzar actualización de las tarjetas
    await forceTriggerRefresh();
};

// Función para forzar la actualización de tarjetas
const forceTriggerRefresh = async () => {
    refreshKey.value++;
    await nextTick();
};

// Función para actualizar las tarjetas de productos
const refreshProductCards = async () => {
    // Limpiar cualquier valor en localStorage que pueda interferir
    await store.dispatch('storeOrders/clearLocalStorageOnly');
    
    // Forzar a Vuex a actualizar el estado actual de productos
    await store.dispatch('storeOrders/initializeFromLocalStorage');
    
    // Incrementar la clave para forzar la re-renderización
    await forceTriggerRefresh();
};

const handleSubmitOrder = async () => {
    try {
        // Verificar si hay productos en el carrito
        if (!hasProductsInCart.value) {
            modalMessage.value = 'No hay productos seleccionados para crear un pedido';
            modalTitle.value = 'Advertencia';
            isModalVisible.value = true;
            return;
        }
        
        const response = await fetchOrder();
        orderStatus.value = response.orderStatus;
        
        // Permitir crear pedido si es el primero O si ya se entregó el anterior
        if (response.orderProducts.length === 0 || response.orderStatus === 'Delivered') {
            const order = await submitOrder();
            
            // Actualizar el estado después de crear el pedido
            await checkOrderStatus();
            
            // Refrescar las tarjetas de productos después de crear el pedido
            await refreshProductCards();
            
            modalMessage.value = order.message || 'Pedido creado con éxito';
            modalTitle.value = 'Éxito';
            isModalVisible.value = true;
        } else {
            // Si hay un pedido en curso, informar al usuario
            modalMessage.value = 'Ya tiene un pedido en curso. Espere hasta recibir todos los productos.';
            modalTitle.value = 'Información';
            isModalVisible.value = true;
        }
    } catch (error) {
        console.error("Error al crear la orden:", error);
        modalMessage.value = 'Error al crear la orden';
        modalTitle.value = 'Error';
        isModalVisible.value = true;
    }
};

const handlePayOrder = async () => {
    try {
        const response = await fetchOrder();
        orderStatus.value = response.orderStatus;
        
        if (!response || response.orderProducts.length === 0) {
            // Si no hay pedido activo
            modalMessage.value = 'No hay ningún pedido activo para pagar';
            modalTitle.value = 'Información';
            isModalVisible.value = true;
            return;
        }
        
        if (response.orderStatus === 'Delivered') {
            router.push('/payment');
        } else if (response.orderStatus === 'Pending') {
            modalMessage.value = 'Tiene un pedido en curso. Espere hasta recibir todos los productos para poder pagar.';
            modalTitle.value = 'Información';
            isModalVisible.value = true;
        } else {
            modalMessage.value = 'Estado del pedido actual: ' + response.orderStatus;
            modalTitle.value = 'Información';
            isModalVisible.value = true;
        }
    } catch (error) {
        console.error("Error al pagar la orden:", error);
        modalMessage.value = 'Error al procesar el pago';
        modalTitle.value = 'Error';
        isModalVisible.value = true;
    }
};

// Verificar el estado del pedido al montar el componente
onMounted(async () => {
    await checkOrderStatus();
    // Asegurarnos de que los productos mostrados sean correctos
    await refreshProductCards();
});

// Watchers para los filtros y la paginación
watch([selectedType, orderBy, currentPage], updateStore);
</script>

<style scoped>
/* Estilos base */
.menu-page {
    padding: 20px;
    display: flex;
    flex-direction: column;
    align-items: center;
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    position: relative;
    min-height: 100vh;
}

.theme-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1;
}

.content-container {
    position: relative;
    z-index: 2;
    width: 100%;
    max-width: 1200px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 20px;
}

.menu-page h1 {
    color: white;
    margin-top: 60px;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
    font-size: 2.5rem;
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

.order-buttons {
    display: flex;
    gap: 10px;
    margin-top: 20px;
    margin-bottom: 30px;
}

.order-button {
    padding: 12px 24px;
    font-weight: bold;
    transition: transform 0.2s, box-shadow 0.2s;
    border: none;
}

.order-button:not(:disabled):hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.order-button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.scroll-top {
    --scrolltop-size: 3rem;
    --scrolltop-border-radius: 50%;
}

/* Tema España */
.españa-theme .theme-overlay {
    background-color: rgba(198, 11, 30, 0.3);
}

.españa-theme h1 {
    color: #ffcc00;
}

.españa-theme .product-list {
    background: rgba(255, 250, 240, 0.95);
    border: 2px solid #ffcc00;
    box-shadow: 0 8px 20px rgba(198, 11, 30, 0.2);
}

.españa-theme .order-button.create-order {
    background-color: #c60b1e;
    color: white;
}

.españa-theme .order-button.pay-order {
    background-color: #ffcc00;
    color: #c60b1e;
}

/* Tema México */
.méxico-theme .theme-overlay {
    background-color: rgba(0, 99, 65, 0.3);
}

.méxico-theme h1 {
    color: white;
    text-shadow: 0 2px 4px rgba(206, 17, 38, 0.8);
}

.méxico-theme .product-list {
    background: rgba(252, 246, 238, 0.95);
    border: 2px solid #ce1126;
    box-shadow: 0 8px 20px rgba(0, 99, 65, 0.2);
}

.méxico-theme .order-button.create-order {
    background-color: #006341;
    color: white;
}

.méxico-theme .order-button.pay-order {
    background-color: #ce1126;
    color: white;
}

/* Tema India */
.india-theme .theme-overlay {
    background-color: rgba(255, 153, 51, 0.3);
}

.india-theme h1 {
    color: white;
    text-shadow: 0 2px 4px rgba(0, 0, 128, 0.8);
}

.india-theme .product-list {
    background: rgba(248, 241, 229, 0.95);
    border: 2px solid #ff9933;
    box-shadow: 0 8px 20px rgba(19, 136, 8, 0.2);
}

.india-theme .order-button.create-order {
    background-color: #138808;
    color: white;
}

.india-theme .order-button.pay-order {
    background-color: #ff9933;
    color: #000080;
}

/* Tema Japón */
.japón-theme .theme-overlay {
    background-color: rgba(0, 0, 0, 0.4);
}

.japón-theme h1 {
    color: white;
    letter-spacing: 1px;
}

.japón-theme .product-list {
    background: rgba(255, 255, 255, 0.95);
    border: 1px solid #ddd;
    box-shadow: 0 8px 20px rgba(188, 0, 45, 0.15);
}

.japón-theme .order-button.create-order {
    background-color: #bc002d;
    color: white;
}

.japón-theme .order-button.pay-order {
    background-color: #333;
    color: white;
}

/* Tema Turquía */
.turquía-theme .theme-overlay {
    background-color: rgba(227, 10, 23, 0.3);
}

.turquía-theme h1 {
    color: white;
    text-shadow: 0 2px 4px rgba(29, 94, 168, 0.8);
}

.turquía-theme .product-list {
    background: rgba(245, 241, 233, 0.95);
    border: 2px solid #e30a17;
    box-shadow: 0 8px 20px rgba(29, 94, 168, 0.2);
}

.turquía-theme .order-button.create-order {
    background-color: #1d5ea8;
    color: white;
}

.turquía-theme .order-button.pay-order {
    background-color: #e30a17;
    color: white;
}

/* Tema Italia */
.italia-theme .theme-overlay {
    background-color: rgba(0, 140, 69, 0.3);
}

.italia-theme h1 {
    color: white;
    text-shadow: 0 2px 4px rgba(205, 33, 42, 0.8);
}

.italia-theme .product-list {
    background: rgba(247, 243, 238, 0.95);
    border: 2px solid #008C45;
    box-shadow: 0 8px 20px rgba(205, 33, 42, 0.2);
}

.italia-theme .order-button.create-order {
    background-color: #008C45;
    color: white;
}

.italia-theme .order-button.pay-order {
    background-color: #cd212a;
    color: white;
}

/* Asegúrate de que los nombres de clase coincidan con las variaciones en minúsculas */
.espana-theme {
    composes: españa-theme;
}

.mexico-theme {
    composes: méxico-theme;
}

.japon-theme {
    composes: japón-theme;
}

.turquia-theme {
    composes: turquía-theme;
}
:deep(.themed-paginator) {
    margin: 20px 0;
}

/* España */
.españa-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(255, 250, 240, 0.95);
    border: 1px solid #ffcc00;
}

.españa-theme :deep(.themed-paginator .p-paginator .p-paginator-element) {
    color: #c60b1e;
}

.españa-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background-color: #c60b1e;
    color: white;
}

/* México */
.méxico-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(252, 246, 238, 0.95);
    border: 1px solid #ce1126;
}

.méxico-theme :deep(.themed-paginator .p-paginator .p-paginator-element) {
    color: #006341;
}

.méxico-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background-color: #006341;
    color: white;
}

/* India */
.india-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(248, 241, 229, 0.95);
    border: 1px solid #ff9933;
}

.india-theme :deep(.themed-paginator .p-paginator .p-paginator-element) {
    color: #138808;
}

.india-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background-color: #138808;
    color: white;
}

/* Japón */
.japón-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #ddd;
}

.japón-theme :deep(.themed-paginator .p-paginator .p-paginator-element) {
    color: #bc002d;
}

.japón-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background-color: #bc002d;
    color: white;
}

/* Turquía */
.turquía-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(245, 241, 233, 0.95);
    border: 1px solid #e30a17;
}

.turquía-theme :deep(.themed-paginator .p-paginator .p-paginator-element) {
    color: #1d5ea8;
}

.turquía-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background-color: #1d5ea8;
    color: white;
}

/* Italia */
.italia-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(247, 243, 238, 0.95);
    border: 1px solid #008C45;
}

.italia-theme :deep(.themed-paginator .p-paginator .p-paginator-element) {
    color: #cd212a;
}

.italia-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background-color: #008C45;
    color: white;
}
:deep(.themed-paginator) {
    margin: 25px 0;
    font-family: var(--font-default);
}

:deep(.themed-paginator .p-paginator) {
    background-color: transparent;
    border: none;
    padding: 0.75rem 1rem;
    border-radius: 8px;
    display: flex;
    justify-content: center;
    align-items: center;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

:deep(.themed-paginator .p-paginator .p-paginator-element) {
    margin: 0 2px;
    width: 38px;
    height: 38px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 500;
    transition: all 0.2s ease;
}

:deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(0, 0, 0, 0.05);
}

:deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    font-weight: 700;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

:deep(.themed-paginator .p-paginator .p-paginator-first),
:deep(.themed-paginator .p-paginator .p-paginator-prev),
:deep(.themed-paginator .p-paginator .p-paginator-next),
:deep(.themed-paginator .p-paginator .p-paginator-last) {
    border: 1px solid rgba(0, 0, 0, 0.1);
}

/* España */
.españa-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(255, 250, 240, 0.95);
    border: 1px solid #ffcc00;
}

.españa-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight)) {
    color: #c60b1e;
}

.españa-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background: linear-gradient(135deg, #c60b1e, #d01c2d);
    color: white;
    border: 1px solid #c60b1e;
}

.españa-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(198, 11, 30, 0.08);
}

/* México */
.méxico-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(252, 246, 238, 0.95);
    border: 1px solid #ce1126;
}

.méxico-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight)) {
    color: #006341;
}

.méxico-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background: linear-gradient(135deg, #006341, #007a4f);
    color: white;
    border: 1px solid #006341;
}

.méxico-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(0, 99, 65, 0.08);
}

/* India */
.india-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(248, 241, 229, 0.95);
    border: 1px solid #ff9933;
}

.india-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight)) {
    color: #138808;
}

.india-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background: linear-gradient(135deg, #138808, #1ba00f);
    color: white;
    border: 1px solid #138808;
}

.india-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(19, 136, 8, 0.08);
}

/* Japón */
.japón-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(255, 255, 255, 0.95);
    border: 1px solid #e7e7e7;
}

.japón-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight)) {
    color: #bc002d;
}

.japón-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background: linear-gradient(135deg, #bc002d, #d2002d);
    color: white;
    border: 1px solid #bc002d;
}

.japón-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(188, 0, 45, 0.08);
}

/* Turquía */
.turquía-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(245, 241, 233, 0.95);
    border: 1px solid #e30a17;
}

.turquía-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight)) {
    color: #1d5ea8;
}

.turquía-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background: linear-gradient(135deg, #1d5ea8, #236ac0);
    color: white;
    border: 1px solid #1d5ea8;
}

.turquía-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(29, 94, 168, 0.08);
}

/* Italia */
.italia-theme :deep(.themed-paginator .p-paginator) {
    background-color: rgba(247, 243, 238, 0.95);
    border: 1px solid #008C45;
}

.italia-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight)) {
    color: #cd212a;
}

.italia-theme :deep(.themed-paginator .p-paginator .p-paginator-element.p-highlight) {
    background: linear-gradient(135deg, #008C45, #00a04e);
    color: white;
    border: 1px solid #008C45;
}

.italia-theme :deep(.themed-paginator .p-paginator .p-paginator-element:not(.p-highlight):not(.p-disabled):hover) {
    background-color: rgba(0, 140, 69, 0.08);
}
/* Responsive */
@media (max-width: 768px) {
    .menu-page {
        padding: 10px;
    }

    .menu-page h1 {
        margin-top: 30px;
        font-size: 1.8rem;
    }

    .product-list {
        width: 95%;
        padding: 15px;
        gap: 20px;
    }

    .order-buttons {
        flex-direction: column;
        width: 90%;
        gap: 10px;
    }

    .order-button {
        width: 100%;
        padding: 12px;
    }
}

@media (max-width: 480px) {
    .menu-page h1 {
        font-size: 1.5rem;
        margin-top: 20px;
    }

    .product-list {
        padding: 10px;
    }
}
</style>