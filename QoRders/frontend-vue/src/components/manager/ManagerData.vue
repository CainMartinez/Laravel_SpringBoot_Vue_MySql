<template>
    <div class="personal-data">
        <h1>Datos del Camarero</h1>

        <div class="data-container">
            <p><strong>Nombre:</strong> {{ userData.firstName }} {{ userData.lastName }}</p>
            <p><strong>Email:</strong> {{ userData.email }}</p>
            <p><strong>Bio:</strong> {{ userData.bio }}</p>
            <p><strong>Número de Teléfono:</strong> {{ userData.phone_number }}</p>
            <p><strong>Salario:</strong> {{ userData.salary }} €</p>
        </div>
    </div>
    <div class="metrics-data">
        <p><strong>Reservas Realizadas:</strong> {{ generalMetrics?.data?.bookings?.confirmed }} en total.</p>
        <p><strong>Pedidos Atendidos:</strong> {{ generalMetrics?.data?.bookings?.completed }} en total.</p>
        <p><strong>Personal:</strong> {{ generalMetrics.data.total_waiters }} empleados.</p>
        <!-- <p><strong>Feedback:</strong> </p> -->
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const userData = computed(() => store.getters['storeAuth/getUserData']);

const generalMetrics = computed(() => store.getters['storeAdmin/getGeneralMetrics']);

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
