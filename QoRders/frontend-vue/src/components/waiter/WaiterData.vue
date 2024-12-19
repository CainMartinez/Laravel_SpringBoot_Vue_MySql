<template>
    <div class="personal-data">
        <h1>Datos del Camarero</h1>

        <div class="data-container">
            <p><strong>Nombre:</strong> {{ userData.firstName }} {{ userData.lastName }}</p>
            <p><strong>Email:</strong> {{ userData.email }}</p>
            <p><strong>Bio:</strong> {{ userData.bio }}</p>
            <p><strong>Numero de Teléfono</strong> {{ userData.phone_number }}</p>
            <p><strong>Fecha de Contratación:</strong> {{ userData.hire_date }}</p>
            <p><strong>Salario:</strong> {{ userData.salary }} €</p>
            <p><strong>Disponibilidad de Turno:</strong> {{ userData.shift_disponibility }}</p>
        </div>
    </div>
    <div class="metrics-data">
        <p><strong>Reservas Realizadas:</strong> </p>
        <p><strong>Pedidos Atendidos:</strong> €</p>
        <p><strong>Feedback:</strong> </p>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const userData = computed(() => store.getters['storeAuth/getUserData']);
console.log(userData.value);
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
