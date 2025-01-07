<template>
    <div class="qr-page">
        <!-- Pantalla de Carga -->
        <div v-if="loading" class="waiting-screen">
            <p>Escaneando QR. Validando, por favor espere.</p>
            <ProgressSpinner />
        </div>

        <!-- Pantalla de Bienvenida -->
        <div v-else class="welcome-screen">
            <div class="welcome-content">
                <h1>Bienvenido a {{ roomName }}</h1>
                <div class="room-image-container">
                    <img :src="roomImageUrl" alt="Imagen de la sala" />
                </div>
                <button @click="redirectToCard" :value="roomSlug.value">Ir a la carta</button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import useQR from '../composables/useQR';


const router = useRouter();

const loading = ref(true);
const roomName = ref('');
const roomSlug = ref('');
const roomImageUrl = ref('');
const bookingData = ref(null);

// Usamos el composable que ya implementamos para el QR
const { loading: qrLoading, bookingId, validateQRCode, validateBooking } = useQR();

onMounted(async () => {
    // Obtener los datos del QR del URL
    const queryParams = new URLSearchParams(window.location.search);
    const qrData = queryParams.get('data');

    if (qrData) {
        await validateQRCode(qrData);
        if (!qrLoading.value && bookingId.value) {
            bookingData.value = await validateBooking(bookingId);
            console.log(bookingData.value);
            // roomName.value = bookingData.value.roomName;
            // roomSlug.value = bookingData.value.roomSlug; 
            // roomImageUrl.value = bookingData.value.roomImageUrl;
            loading.value = false;
        }
    }
});

const redirectToCard = () => {
    // router.push(`/room/${roomName.value}`);
    console.log('Redirigiendo a la carta de:' + bookingData.value);
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
}

@keyframes slideInUp {
    from {
        transform: translateY(100%);
    }

    to {
        transform: translateY(0);
    }
}

@keyframes slideInDown {
    from {
        transform: translateY(-100%);
    }

    to {
        transform: translateY(0);
    }
}

.welcome-content {
    text-align: center;
}

.room-image-container img {
    max-width: 100%;
    height: auto;
    margin-top: 20px;
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