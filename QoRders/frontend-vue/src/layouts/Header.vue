<template>
  <div class="header">
    <div class="menu">
      <router-link to="/home">Inicio</router-link>
      <router-link to="/rooms">Carta</router-link>
      <router-link v-if="!isAuthenticated || userType === 'client'" to="/reservation">Reservar</router-link>
      <router-link v-if="!isAuthenticated || userType === 'client'" to="/donations">ONGs</router-link>
    </div>
    
    <router-link to="/home" class="logo-container">
      <img class="logo" src="/src/assets/logo.png" alt="Logo" />
    </router-link>

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
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  padding: 10px 20px;
  background-color: #f8f9fa;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border-radius: 5px;
  color: #333;
}

.logo-container {
  flex-grow: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  background-color: transparent;
  padding: 0;
  transition: transform 0.3s ease;
}

.logo-container:hover {
  transform: scale(1.05);
  background-color: transparent;
}

.logo {
  width: auto;
  height: 4rem;
  object-fit: contain;
}

.menu {
  flex-grow: 1;
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
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

@media (max-width: 992px) {
  .logo {
    height: 3.5rem;
  }
}

@media (max-width: 768px) {
  .header {
    flex-direction: column;
    align-items: center;
    padding: 15px;
  }

  .menu {
    justify-content: center;
    width: 100%;
    margin-bottom: 15px;
    gap: 5px;
  }

  .logo-container {
    margin: 10px 0;
    order: -1;
  }
  
  .logo {
    height: 3rem;
  }

  .login-button, .user-info {
    justify-content: center;
    width: 100%;
    margin-top: 10px;
  }
}

</style>