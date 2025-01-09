<template>
    <div class="client-profile">
        <div class="profile-menu">
            <ProfileMenu :userType="userType" @change-view="setCurrentView" />
        </div>

        <div class="profile-content">
            <ClientData v-if="currentView === 'Data'" :reservationsCount="reservations.length"
                :reservations="reservations" />
            <ReservationsHistory v-if="currentView === 'ReservationsHistory'" :userType="userType"
                :reservations="reservations" />
            <!-- <OrdersHistory v-if="currentView === 'OrdersHistory'" :userType="userType" /> -->
            <ClientSettings v-if="currentView === 'Settings'" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import ProfileMenu from '../components/ProfileMenu.vue';
import ClientData from '../components/client/ClientData.vue';
import ReservationsHistory from '../components/ReservationsHistory.vue';
// import OrdersHistory from '../components/OrdersHistory.vue';
import ClientSettings from '../components/client/ClientSettings.vue';
import useReservation from '../composables/useReservation';

const store = useStore();
const { loadReservations } = useReservation();
const currentView = ref('ReservationsHistory');
const userType = computed(() => store.getters['storeAuth/getUserType']);
const reservations = ref([]);

const setCurrentView = (view) => {
    currentView.value = view;
};

onMounted(async () => {
    await loadReservations();
    reservations.value = store.state.storeReservation.reservations.data;
});
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