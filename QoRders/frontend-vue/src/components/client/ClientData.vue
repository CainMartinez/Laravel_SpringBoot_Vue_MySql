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
        <p><strong>Reservas Realizadas:</strong> {{ reservationsCount }}</p>
        <p><strong>Dinero Donado:</strong> {{ donationsAmount }} €</p>
        <!-- <p><strong>Feedback:</strong> {{ }}</p> -->
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

// Datos del usuario
const userData = computed(() => store.getters['storeAuth/getUserData'].client);

const props = defineProps({
    reservations: {
        type: Array,
        required: true
    },
    reservationsCount: {
        type: Number,
        required: true
    }
});

const donationsAmount = computed(() => {
    const totalAmount = props.reservations.reduce((total, reservation) => {
        const ticketsTotal = reservation.tickets.reduce((sum, ticket) => sum + ticket.totalAmount, 0);
        return total + ticketsTotal;
    }, 0) * 0.05;
    return totalAmount.toFixed(2);
});
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