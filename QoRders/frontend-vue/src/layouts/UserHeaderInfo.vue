<template>
    <div class="user-profile">
        <span>Hola {{ currentUser.firstName }}!</span>
        <router-link :to="userPageLink">
            <img v-if="currentUser.avatar_url" :src="currentUser.avatar_url" alt="User Avatar" class="user-avatar" />
        </router-link>
        <button @click="logout" class="logout-btn">Cerrar sesión</button>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import useAuth from '../composables/useAuth';

const props = defineProps({
    user: Object,
    userClient: Object,
    userType: String
});

const currentUser = computed(() => {
    return props.userType === 'client' ? props.userClient : props.user;
});

const userPageLink = computed(() => {
    switch (props.userType) {
        case 'client':
            return '/profile';
        case 'waiter':
            return '/dashboard-waiter';
        case 'manager':
            return '/dashboard-manager';
        default:
            return '/';
    }
});

const { logout } = useAuth();
</script>

<style scoped>
.user-profile {
    display: flex;
    align-items: center;
    gap: 10px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
}

.user-profile span {
    font-weight: bold;
}

.user-profile .logout-btn {
    background-color: #f8f9fa;
    border: none;
    color: #333;
    cursor: pointer;
}

.user-profile .logout-btn:hover {
    color: #bb2222;
}
</style>