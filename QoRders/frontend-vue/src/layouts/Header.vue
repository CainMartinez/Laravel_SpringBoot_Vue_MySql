<template>
  <div class="header">
    <div class="menu">
      <router-link to="/home">Inicio</router-link>
      <router-link to="/rooms">Carta</router-link>
      <router-link v-if="!isAuthenticated || userType === 'client'" to="/reservation">Reserva</router-link>
      <router-link v-if="!isAuthenticated || userType === 'client'" to="/donations">Donaciones</router-link>
    </div>

    <div class="logo">
      <img src="/src/assets/logo.png" alt="Logo" />
    </div>

    <div class="user-info" v-if="isAuthenticated && userData">
      <UserHeaderInfo :user="userData" :userClient="userClient" :userType="userType" />
    </div>

    <div v-else class="login-button">
      <router-link to="/login">Iniciar sesión</router-link>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';
import UserHeaderInfo from './UserHeaderInfo.vue';

const store = useStore();
const isAuthenticated = computed(() => store.getters['storeAuth/getIsAuthenticated']);
const userType = computed(() => store.getters['storeAuth/getUserType']);
const userData = computed(() => store.getters['storeAuth/getUserData']);

const userClient = computed(() => {
  return userType.value === 'client' && userData.value ? userData.value.client : null;
});
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
  flex-grow: 1;
  display: flex;
  justify-content: flex-start;
}

.login-button {
  display: flex;
  justify-content: flex-end;
  flex-grow: 1;
}

.user-info {
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