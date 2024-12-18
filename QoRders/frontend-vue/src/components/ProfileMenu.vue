<template>
    <div class="profile-menu-container">
        <img :src="userImageUrl" alt="User Avatar" class="user-avatar" />
        <h2>{{ userName }}</h2>

        <nav>
            <ul>
                <li :class="{ active: activeView === 'ClientData' }" @click="changeView('ClientData')">Datos Personales</li>
                <li :class="{ active: activeView === 'ReservationsHistory' }" @click="changeView('ReservationsHistory')">Historial de Reservas</li>
                <li :class="{ active: activeView === 'OrdersHistory' }" @click="changeView('OrdersHistory')">Historial de Pedidos</li>
                <li :class="{ active: activeView === 'Feedback' }" @click="changeView('Feedback')">Comentarios</li>
                <li :class="{ active: activeView === 'ClientSettings' }" @click="changeView('ClientSettings')">Ajustes</li>
            </ul>
        </nav>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useStore } from 'vuex';

const store = useStore();
const userType = computed(() => store.getters['storeAuth/getUserType']);
const userName = computed(() => userType.value === 'client' ? store.getters['storeAuth/getUserData'].client.firstName : store.getters['storeAuth/getUserData'].firstName);
const userImageUrl = computed(() => userType.value === 'client' ? store.getters['storeAuth/getUserData'].client.avatar_url : store.getters['storeAuth/getUserData'].avatar_url);

const emit = defineEmits(['change-view']);
const activeView = ref('ClientData');

const changeView = (view) => {
    activeView.value = view;
    emit('change-view', view);
};
</script>

<style scoped>
.profile-menu-container {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.user-avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    margin-bottom: 20px;
}

nav ul {
    list-style: none;
    padding: 0;
}

nav ul li {
    margin-bottom: 10px;
    cursor: pointer;
    font-weight: bold;
}

nav ul li:hover {
    color: #007bff;
}

nav ul li.active {
    color: #007bff;
    font-weight: bold;
}
</style>