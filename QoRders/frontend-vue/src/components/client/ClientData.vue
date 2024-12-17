<template>
    <div class="personal-data">
        <h1>Datos Personales</h1>

        <div class="data-container">
            <p><strong>Nombre:</strong> {{ userData.firstName }} {{ userData.lastName }}</p>
            <p><strong>Email:</strong> {{ userData.email }}</p>
            <p><strong>Edad:</strong> {{ userData.age }}</p>
            <p><strong>Dirección:</strong> {{ userData.address }}</p>
            <p><strong>Bio:</strong> {{ userData.bio }}</p>
        </div>
    </div>
    <div class="metrics-data">
        <p><strong>Reservas Realizadas:</strong> {{ userMetrics.reservations }}</p>
        <p><strong>Dinero Donado:</strong> {{ userMetrics.donatedMoney }}€</p>
        <p><strong>Feedback:</strong> {{ userMetrics.feedbackCount }}</p>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

// Datos del usuario
const userData = computed(() => store.getters['storeAuth/getUserData'].client);
console.log(userData.value);

// Métricas del cliente
const userMetrics = computed(() => ({
    reservations: store.getters['storeMetrics/getReservationsCount'],
    donatedMoney: store.getters['storeMetrics/getDonatedMoney'],
    feedbackCount: store.getters['storeMetrics/getFeedbackCount']
}));
</script>

<style scoped>
.personal-data {
    padding: 20px;
}

.data-container p {
    font-size: 16px;
    margin: 10px 0;
}

.metrics-data {
    padding: 20px;
}
</style>