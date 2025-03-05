<template>
    <div class="personal-data">
        <h1>Datos del Camarero</h1>

        <div class="data-container">
            <p><strong>Nombre:</strong> {{ userData.firstName }} {{ userData.lastName }}</p>
            <p><strong>Email:</strong> {{ userData.email }}</p>
            <p><strong>Bio:</strong> {{ userData.bio }}</p>
            <p><strong>Número de Teléfono:</strong> {{ userData.phone_number }}</p>
            <p><strong>Fecha de Contratación:</strong> {{ userData.hire_date }}</p>
            <p><strong>Salario:</strong> {{ userData.salary }} €</p>
            <p><strong>Disponibilidad de Turno:</strong> {{ userData.shift_disponibility }}</p>
        </div>
    </div>
    <div class="metrics-data">
        <p><strong>Reservas Realizadas:</strong> </p>
        <p><strong>Pedidos Atendidos:</strong> </p>
        <p><strong>Feedback:</strong> </p>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const userData = computed(() => store.getters['storeAuth/getUserData']);
</script>

<style scoped>
.personal-data {
    padding: 30px;
    margin: 20px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.data-container p {
    font-size: 16px;
    margin: 10px 0;
}

.metrics-data {
    padding: 30px;
    margin: 20px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

@media (max-width: 768px) {
    .personal-data, .metrics-data {
        padding: 20px;
        margin: 10px;
    }
}
</style>