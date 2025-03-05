<template>
    <div class="profile-menu-container">
        <img :src="userImageUrl" alt="User Avatar" class="user-avatar" />
        <h2>{{ userName }}</h2>

        <nav>
            <ul>
                <li :class="{ active: activeView === 'Data' }" @click="changeView('Data')">Datos Personales</li>
                <li v-if="props.userType === 'client'" :class="{ active: activeView === 'ReservationsHistory' }"
                    @click="changeView('ReservationsHistory')">Historial de Reservas</li>
                <li v-if="props.userType === 'waiter'" :class="{ active: activeView === 'ReservationsWaiter' }"
                    @click="changeView('ReservationsWaiter')">Reservas a atender</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'OngsManagement' }"
                    @click="changeView('OngsManagement')">Gestion de Ongs</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'RoomManagement' }"
                    @click="changeView('RoomManagement')">Gestion de Salas</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'MenuManagement' }"
                    @click="changeView('MenuManagement')">Gestion de Carta</li>
                <li :class="{ active: activeView === 'Settings' }" @click="changeView('Settings')">Ajustes</li>
            </ul>
        </nav>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useStore } from 'vuex';

const props = defineProps({
    userType: {
        type: String,
        required: true
    }
});

const store = useStore();
const userName = computed(() => props.userType === 'client' ? store.getters['storeAuth/getUserData'].client.firstName : store.getters['storeAuth/getUserData'].firstName);
const userImageUrl = computed(() => props.userType === 'client' ? store.getters['storeAuth/getUserData'].client.avatar_url : store.getters['storeAuth/getUserData'].avatar_url);

const emit = defineEmits(['change-view']);
const activeView = ref('ReservationsHistory');

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
    padding: 20px;
    background-color: #f8f9fa;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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
    width: 100%;
}

nav ul li {
    margin-bottom: 10px;
    cursor: pointer;
    font-weight: bold;
    text-align: center;
    padding: 10px;
    border-radius: 4px;
    transition: background-color 0.3s;
}

nav ul li:hover {
    background-color: #e9ecef;
}

nav ul li.active {
    background-color: #007bff;
    color: white;
}

@media (max-width: 768px) {
    .profile-menu-container {
        flex-direction: column;
        align-items: center;
        padding: 10px;
    }

    .user-avatar {
        width: 80px;
        height: 80px;
        margin-bottom: 15px;
    }

    nav ul {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        justify-content: center;
    }

    nav ul li {
        font-size: 14px;
        padding: 8px;
        margin: 5px;
        flex: 1 1 auto;
    }
}
</style>