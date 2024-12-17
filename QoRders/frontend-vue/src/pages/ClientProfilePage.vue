<template>
    <div class="client-profile">
        <div class="profile-menu">
            <ProfileMenu @change-view="setCurrentView" />
        </div>

        <div class="profile-content">
            <ClientData v-if="currentView === 'ClientData'" />
            <ReservationsHistory v-if="currentView === 'ReservationsHistory'" />
            <OrdersHistory v-if="currentView === 'OrdersHistory'" />
            <Feedback v-if="currentView === 'Feedback'" />
            <ClientSettings v-if="currentView === 'ClientSettings'" />
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import ProfileMenu from '../components/client/ProfileMenu.vue';
import ClientData from '../components/client/ClientData.vue';
import ReservationsHistory from '../components/client/ReservationsHistory.vue';
import OrdersHistory from '../components/client/OrdersHistory.vue';
import Feedback from '../components/client/Feedback.vue';
import ClientSettings from '../components/client/ClientSettings.vue';

const currentView = ref('ClientData');

const setCurrentView = (view) => {
    currentView.value = view;
};
</script>

<style scoped>
.client-profile {
    display: flex;
    flex-direction: row;
    height: 100vh;
}

.profile-menu {
    width: 250px;
    padding: 20px;
    margin-top: 80px;
}

.profile-content {
    flex-grow: 1;
    padding: 20px;
    margin-top: 80px;
}
</style>