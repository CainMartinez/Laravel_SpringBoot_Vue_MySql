<template>
  <div class="header">
    <!-- Menú izquierdo -->
      <div class="menu left-menu">
      <router-link to="/home">Inicio</router-link>
      <router-link to="/rooms">Carta</router-link>
      <router-link v-if="isAuthenticated && userType === 'client'" to="/reservation">Reservar</router-link>
      <router-link v-if="!isAuthenticated || userType === 'client'" to="/donations">ONGs</router-link>
    </div>

    <!-- Logo siempre centrado -->
    <router-link to="/home" class="logo-container">
      <img class="logo" src="/src/assets/logo.png" alt="Logo QoRders" />
    </router-link>
    
    <!-- Menú derecho (login o info de usuario) -->
    <div class="right-menu">
      <div class="user-info" v-if="isAuthenticated && userData">
        <UserHeaderInfo :user="userData" :userClient="userClient" :userType="userType" />
      </div>
      <div v-else class="login-button">
        <router-link to="/login" class="login-link">
          <i class="pi pi-user"></i>
          <span>Iniciar sesión</span>
        </router-link>
      </div>
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
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  align-items: center;
  padding: 12px 30px;
  background: linear-gradient(to bottom, #ffffff, #f8f9fa);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
  color: #212529;
  position: relative;
  border-bottom: 3px solid #0056b3;
}

/* Logo siempre en el centro */
.logo-container {
  grid-column: 2;
  display: flex;
  justify-content: center;
  align-items: center;
  text-decoration: none;
  background-color: transparent;
  padding: 0;
  transition: transform 0.3s ease;
  z-index: 2;
}

.logo-container:hover {
  transform: scale(1.05);
  background-color: transparent;
}

.logo {
  width: auto;
  height: 6rem;
  object-fit: contain;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

/* Menú izquierdo */
.left-menu {
  grid-column: 1;
  display: flex;
  justify-content: flex-start;
  flex-wrap: wrap;
  gap: 8px;
}

/* Menú derecho */
.right-menu {
  grid-column: 3;
  display: flex;
  justify-content: flex-end;
}

.login-button, .user-info {
  display: flex;
  justify-content: flex-end;
}

a {
  padding: 8px 16px;
  color: #212529;
  border: none;
  border-radius: 4px;
  text-decoration: none;
  font-weight: 500;
  position: relative;
  transition: all 0.2s ease;
  background-color: transparent;
}

a:hover {
  color: #236dc8;
  background-color: rgba(0, 86, 179, 0.05);
}

a:after {
  content: '';
  position: absolute;
  width: 0;
  height: 2px;
  bottom: 0;
  left: 50%;
  background-color: #0056b3;
  transition: all 0.3s ease;
}

a:hover:after {
  width: 80%;
  left: 10%;
}

.login-link {
  display: flex;
  align-items: center;
  gap: 8px;
  background-color: rgba(0, 86, 179, 0.1);
  border-radius: 20px;
  padding: 8px 18px;
  color: #0056b3;
  transition: all 0.3s ease;
  font-weight: 600;
}

.login-link:hover {
  background-color: #0056b3;
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 86, 179, 0.2);
}

.login-link:hover:after {
  display: none;
}

.login-link i {
  font-size: 0.9rem;
}

/* Media queries */
@media (max-width: 992px) {
  .header {
    padding: 10px 20px;
  }
  
  .logo {
    height: 5.5rem;
  }
  
  a {
    padding: 6px 12px;
  }
}

@media (max-width: 768px) {
  .header {
    grid-template-columns: 1fr;
    grid-template-rows: auto auto auto;
    gap: 10px;
    padding: 15px;
  }
  
  .logo-container {
    grid-column: 1;
    grid-row: 1;
    margin: 0 0 15px;
  }
  
  .logo {
    height: 5rem;
  }
  
  .left-menu {
    grid-column: 1;
    grid-row: 2;
    justify-content: center;
    width: 100%;
    gap: 8px;
    margin-bottom: 10px;
  }
  
  .right-menu {
    grid-column: 1;
    grid-row: 3;
    justify-content: center;
    width: 100%;
  }
  
  a:after {
    display: none;
  }
}
</style>