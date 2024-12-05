<template>
    <div class="login-register">
        <h1>{{ isLoginView ? 'Iniciar sesión' : 'Registrar cuenta' }}</h1>

        <!-- Selector de tipo de usuario -->
        <UserTypeSelector @update:selectedType="selectedType = $event" />

        <!-- Formulario de login o registro -->
        <LoginForm v-if="isLoginView" :selectedType="selectedType" @submit="login" />
        <RegisterForm v-else :selectedType="selectedType" @submit="register" />

        <!-- Alternar entre login y registro -->
        <a @click="toggleForm" class="toggle-link">{{ isLoginView ? 'Crear una cuenta' : 'Ya tengo cuenta' }}</a>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import LoginForm from '../components/LoginForm.vue';
import RegisterForm from '../components/RegisterForm.vue';
import UserTypeSelector from '../components/UserTypeSelector.vue';
import useAuth from '../composables/useAuth';

const { login, register, isLoginView, toggleForm } = useAuth();
const selectedType = ref('client');

watch(selectedType, (newValue) => {
    console.log('AuthPage selectedType:', newValue);
});
</script>

<style scoped>
.login-register {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background-color: #f7f7f7;
    color: #333;
    font-family: Arial, sans-serif;
}

h1 {
    font-size: 2.5em;
    margin-bottom: 30px;
    margin-top: 100px;
}

button {
    padding: 10px 20px;
    background-color: #333;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

button:hover {
    background-color: #555;
}

button:focus {
    outline: none;
}

button {
    margin-top: 20px;
}

a.toggle-link {
    margin-top: 20px;
    color: #333;
    cursor: pointer;
    text-decoration: none;
    transition: color 0.3s;
}

a.toggle-link:hover {
    text-decoration: underline;
}

.login-register>* {
    margin-bottom: 20px;
}
</style>