<template>
    <div class="client-profile">
        <div class="profile-menu">
            <ProfileMenu :userType="userType" @change-view="setCurrentView" />
        </div>

        <div class="profile-content">
            <ClientData v-if="currentView === 'Data'" />
            <ReservationsHistory v-if="currentView === 'ReservationsHistory'" :userType="userType" />
            <OrdersHistory v-if="currentView === 'OrdersHistory'" :userType="userType" />
            <Feedback v-if="currentView === 'Feedback'" :userType="userType" />
            <ClientSettings v-if="currentView === 'Settings'" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import ProfileMenu from '../components/ProfileMenu.vue';
import ClientData from '../components/client/ClientData.vue';
import ReservationsHistory from '../components/ReservationsHistory.vue';
import OrdersHistory from '../components/OrdersHistory.vue';
import Feedback from '../components/Feedback.vue';
import ClientSettings from '../components/client/ClientSettings.vue';

const store = useStore();
const currentView = ref('Data');
const userType = computed(() => store.getters['storeAuth/getUserType']);

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
    overflow-y: auto;
    margin-bottom: 20px;
}
</style>