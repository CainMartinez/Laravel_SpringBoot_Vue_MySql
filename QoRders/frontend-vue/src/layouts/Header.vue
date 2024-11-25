<template>
  <div class="header">
    <div class="logo">
      <img src="/src/assets/logo.png" alt="Logo" />
    </div>

    <div class="menu">
      <router-link to="/home">Inicio</router-link>
      <router-link to="/rooms">Carta</router-link>
      <router-link to="/reservation">Reserva</router-link>
      <router-link to="/donations">Donaciones</router-link>
    </div>

    <div class="login-button">
      <router-link to="/login">Iniciar sesión</router-link>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import router from '../router/router';


</script>

<style scoped>
.header {
  display: flex;
  position: absolute;
  z-index: 1;
  width: 99%;
  align-items: center;
  justify-content: space-between;
  padding: 10px 20px;
  margin: 10px 20px 10px 10px;
  background-color: #f8f9fa;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border-radius: 5px;
  color: #333;
}

.logo {
  flex-grow: 1;
  display: flex;
  justify-content: center;
  width: 2rem;
  height: 2rem;
}

.menu {
  background: transparent;
  border: none;
}

.login-button {
  display: flex;
  justify-content: flex-end;
  flex-grow: 1;
}

a {
  padding: 6px 12px;
  background-color: #f8f9fa;
  color: #495057;
  border: none;
  border-radius: 4px;
  text-decoration: none;
}

a:hover {
  background-color: #e9ecef;
}
</style>