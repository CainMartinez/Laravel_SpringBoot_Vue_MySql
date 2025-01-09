<template>
    <div class="qr-page">
        <!-- Pantalla de Carga -->
        <div v-if="loading" class="waiting-screen">
            <p>Escaneando QR. Validando, por favor espere.</p>
            <ProgressSpinner />
        </div>

        <!-- Pantalla de Bienvenida -->
        <div v-else class="welcome-screen" :style="{ backgroundImage: 'url(' + roomImageUrl + ')' }">
            <div class="welcome-content">
                <h1>Bienvenido a {{ roomName }}</h1>
                <p>Gracias por reservar con nosotros. </p>
                <p>Recuerda que dispone de una reserva con una duración de <b>dos horas</b>
                    para disfrutar de tu viaje gastronómico.</p>
                <button @click="redirectToCard" :value="roomSlug.value">Ir a la carta</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import useQR from '../composables/useQR';
import useOrders from '../composables/useOrders';

const loading = ref(true);
const roomName = ref('');
const roomSlug = ref('');
const roomImageUrl = ref('');
const bookingData = ref(null);

const { loading: qrLoading, validateQRCode, getRoomData } = useQR();
const { createOrder } = useOrders();

onMounted(async () => {
    const queryParams = new URLSearchParams(window.location.search);
    const qrData = queryParams.get('data');

    if (qrData) {
        bookingData.value = await validateQRCode(qrData);

        if (!qrLoading.value && bookingData.value) {
            roomName.value = bookingData.value.data.roomName;
            roomSlug.value = bookingData.value.data.roomSlug;
            const roomData = await getRoomData(roomSlug.value);
            roomImageUrl.value = roomData.imageUrl;
            loading.value = false;
        }
    }
});

const redirectToCard = async () => {
    const orderData = await createOrder(bookingData.value.data.bookingId);
    localStorage.setItem('bookingId', bookingData.value.data.bookingId);
    window.location.href = `/room/${roomSlug.value}`;
};
</script>

<style scoped>
.qr-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100vh;
    width: 100%;
}

.waiting-screen,
.welcome-screen {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;
    transition: transform 0.5s ease-in-out;
}

.waiting-screen {
    animation: slideInUp 1s forwards;
}

.welcome-screen {
    animation: slideInDown 1s forwards;
    background-size: cover;
    background-position: center;
    width: 100%;
    height: 100%;
    position: relative;
}

.welcome-content {
    text-align: center;
    background-color: rgba(0, 0, 0, 0.5);
    padding: 20px;
    border-radius: 10px;
    color: white;
}

button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    margin-top: 20px;
}

button:hover {
    background-color: #45a049;
}
</style>