<template>
    <div class="dashboard-container">
        <div class="dashboard-menu">
            <ProfileMenu :userType="userType" @change-view="setCurrentView" />
        </div>

        <div class="dashboard-content">
            <WaiterData v-if="currentView === 'Data'" />
            <ReservationsWaiter v-if="currentView === 'ReservationsWaiter'" :userType="userType" />
            <OrdersHistory v-if="currentView === 'OrdersHistory'" :userType="userType" />
            <Feedback v-if="currentView === 'Feedback'" :userType="userType" />
            <WaiterSettings v-if="currentView === 'Settings'" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import ProfileMenu from '../components/ProfileMenu.vue';
import WaiterData from '../components/waiter/WaiterData.vue';
import ReservationsWaiter from '../components/waiter/ReservationsWaiter.vue';
import OrdersHistory from '../components/OrdersHistory.vue';
import Feedback from '../components/Feedback.vue';
import WaiterSettings from '../components/waiter/WaiterSettings.vue';

const store = useStore();
const userType = computed(() => store.getters['storeAuth/getUserType']);
const currentView = ref('ReservationsWaiter');

const setCurrentView = (view) => {
    currentView.value = view;
};
</script>

<style scoped>
.dashboard-container {
    display: flex;
    flex-direction: row;
    height: 100vh;
}

.dashboard-menu {
    width: 250px;
    padding: 20px;
    margin-top: 80px;
}

.dashboard-content {
    flex-grow: 1;
    padding: 20px;
    margin-top: 80px;
    overflow-y: auto;
    margin-bottom: 20px;
}
</style>