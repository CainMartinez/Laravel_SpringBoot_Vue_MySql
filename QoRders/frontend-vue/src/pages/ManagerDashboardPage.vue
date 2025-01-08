<template>
    <div class="dashboard-container">
        <div class="dashboard-menu">
            <ProfileMenu :userType="userType" @change-view="setCurrentView" />
        </div>

        <div class="dashboard-content">
            <ManagerData v-if="currentView === 'Data'" />
            <OngsManagement v-if="currentView === 'OngsManagement'" :userType="userType" />
            <RoomManagement v-if="currentView === 'RoomManagement'" :userType="userType" />
            <MenuManagement v-if="currentView === 'MenuManagement'" :userType="userType" />
            <ReservationManagement v-if="currentView === 'ReservationManagement'" :userType="userType" />
            <StaffManagement v-if="currentView === 'StaffManagement'" :userType="userType" />
            <ManagerSettings v-if="currentView === 'Settings'" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import ProfileMenu from '../components/ProfileMenu.vue';
import ManagerData from '../components/manager/ManagerData.vue';
import RoomManagement from '../components/manager/RoomManagement.vue';
import MenuManagement from '../components/manager/MenuManagement.vue';
import ReservationManagement from '../components/manager/ReservationManagement.vue';
import StaffManagement from '../components/manager/StaffManagement.vue';
import ManagerSettings from '../components/manager/ManagerSettings.vue';
import OngsManagement from '../components/manager/OngsManagement.vue';

const store = useStore();
const userType = computed(() => store.getters['storeAuth/getUserType']);
const currentView = ref('Data');

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