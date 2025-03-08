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
            <Modal v-model:visible="isModalVisible" :message="modalMessage" :title="modalTitle" @closeModalWithRedirect="redirectToHome"/>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
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
    ticketData.value = ticket;
    orderData.value = order;
};

fetchOrderData();

const handlePayment = async () => {
    try {
        console.log(orderData.value.orderId);
        console.log(totalAmount.value);
        
        const response = await fetch('http://localhost:3002/api/payment', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                orderId: orderData.value.orderId,       // usa tu campo real para el ID de la orden
                totalAmount: totalAmount.value    // usa el valor real del total
            })
        });

        const data = await response.json();

        if (data.clientSecret) {
            // Redirigir a StripePaymentPage pasando clientSecret como parámetro
            router.push({
                name: 'StripePaymentPage',
                query: { clientSecret: data.clientSecret }
            });
        } else {
            throw new Error("No se recibió el clientSecret desde Stripe");
        }
    } catch (error) {
        modalMessage.value = "Error iniciando pago: " + error.message;
        modalTitle.value = 'Error';
        isModalVisible.value = true;
    }
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

@media (max-width: 768px) {
    .ticket-card {
        padding: 10px;
        margin-top: 40px;
    }

    .ticket-header h2 {
        font-size: 1.2rem;
    }

    .ticket-body {
        padding: 10px 0;
    }

    .product-item {
        flex-direction: column;
        align-items: flex-start;
    }

    .product-item p {
        margin: 5px 0;
    }

    .total h3 {
        font-size: 1rem;
    }
}
</style>