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
                <!-- <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'ReservationManagement' }"
                    @click="changeView('ReservationManagement')">Gestion de Reserva</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'StaffManagement' }"
                    @click="changeView('StaffManagement')">Gestion de Personal</li> -->
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