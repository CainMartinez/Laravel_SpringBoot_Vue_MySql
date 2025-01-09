<template>
    <div class="payment-page">
        <!-- Ticket Card -->
        <div class="ticket-card">
            <div class="ticket-header">
                <h2>Ticket de Pago</h2>
                <p>Reserva #{{ orderData.orderUuid }}</p>
            </div>

            <!-- Productos -->
            <div class="ticket-body">
                <div class="product-list">
                    <div v-for="(product, index) in orderData.orderProducts" :key="index" class="product-item">
                        <p>{{ product.productName }} (x{{ product.quantity }})</p>
                        <p>{{ (product.unitPrice * product.quantity).toFixed(2) }}€</p>
                    </div>
                </div>
            </div>

            <!-- Total -->
            <div class="ticket-footer">
                <div class="total">
                    <h3>Total: {{ totalAmount }}€</h3>
                    <Button label="Pagar" icon="pi pi-credit-card" @click="handlePayment" />
                </div>
            </div>
            <Modal v-model:visible="isModalVisible" :message="modalMessage" :title="modalTitle" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useRouter } from 'vue-router';
import useOrders from '../composables/useOrders';
import Modal from '../components/Modal.vue';

const store = useStore();
const router = useRouter();

const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');

// Variables de estado
const loading = ref(true);
const ticketData = ref(null);
const orderData = ref(null);
const isProcessing = ref(false);

// Variables del ticket
const totalAmount = computed(() => {
    return ticketData.value?.totalAmount || 0;
});
const formattedDate = computed(() => {
    const date = new Date(ticketData.value?.createdAt);
    return date.toLocaleDateString('es-ES');
});

// Llamada al composable y métodos
const { makePayment } = useOrders();

const fetchOrderData = async () => {
    const order = store.getters['storeOrders/getOrderData'];
    const ticket = store.getters['storeOrders/getTicketData'];
    console.log('order', order);
    console.log('ticket', ticket);
    ticketData.value = ticket;
    orderData.value = order;
};

fetchOrderData();

const handlePayment = async () => {
    isProcessing.value = true;

    try {
        const paymentData = {
            bookingId: store.getters['storeOrders/getBookingId'],
            paymentMethod: 'card',
        };

        const response = await makePayment(paymentData);
        modalMessage.value = "El pago se ha realizado con éxito. ¡Gracias por tu compra!";
        modalTitle.value = 'Éxito';
        isModalVisible.value = true;
        redirectToHome();
    } catch (error) {
        console.error("Error al procesar el pago:", error);
        modalMessage.value = 'Ha ocurrido un error al procesar el pago. Por favor, inténtalo de nuevo.';
        modalTitle.value = 'Información';
        isModalVisible.value = true;
    } finally {
        isProcessing.value = false;
    }
};

const redirectToHome = () => {
    window.location.href = '/';
};

</script>

<style scoped>
.payment-page {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
    background-color: #f3f3f3;
}

.ticket-card {
    margin-top: 80px;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 500px;
    overflow: hidden;
    position: relative;
    padding: 20px;
}

.ticket-header {
    text-align: center;
    padding-bottom: 10px;
    border-bottom: 1px solid #ddd;
}

.ticket-header h2 {
    font-size: 1.5rem;
    margin: 0;
}

.ticket-body {
    padding: 20px 0;
}

.product-list {
    list-style-type: none;
    padding: 0;
}

.product-item {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
}

.ticket-footer {
    text-align: center;
    padding-top: 20px;
    border-top: 1px solid #ddd;
}

.total h3 {
    font-size: 1.2rem;
    font-weight: bold;
    margin-bottom: 10px;
}
</style>