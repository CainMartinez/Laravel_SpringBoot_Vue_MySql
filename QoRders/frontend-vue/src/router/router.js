import { createRouter, createWebHistory } from 'vue-router';
import ReactWrapper from '../components/ReactWrapper.vue';
import { useStore } from 'vuex';

// Definición de rutas
const routes = [
    {
        path: '/',
        name: 'Inicio',
        component: () => import('../pages/HomePage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            store.dispatch('storeRooms/fetchRooms');
            next();
        }
    },
    {
        path: '/home',
        redirect: '/',
    },
    {
        path: '/rooms',
        name: 'rooms',
        component: () => import('../pages/RoomsPage.vue'),
    },
    {
        path: '/room/:slug',
        name: 'menu',
        component: () => import('../pages/MenuPage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            if (to.params.slug) {
                store.dispatch('storeProducts/fetchProductsByRoom', { room_slug: to.params.slug, filters: {} });
                store.dispatch('storeRooms/fetchRoomBySlug', to.params.slug);
                next();
            } else {
                console.error("El parámetro 'slug' no está definido en la ruta.");
                next(false);
            }
        },
    },
    {
        path: '/reservation',
        name: 'Reserva',
        component: () => import('../pages/ReservationPage.vue'),
    },
    {
        path: '/login',
        name: 'Iniciar sesión',
        component: () => import('../pages/AuthPage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            console.log(store.getters['storeAuth/isAuthenticated']);
            if (store.getters['storeAuth/isAuthenticated']) {
                next('/');
            } else {
                next();
            }
        },
    },
    {
        path: '/donations',
        name: 'Donaciones',
        component: ReactWrapper,
    },
    {
        path: '/profile-client',
        name: 'ClientDashboard',
        component: () => import('../pages/ClientProfilePage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            const userType = store.getters['storeAuth/getUserType'];
            console.log(userType);
            if (userType === 'client') {
                next();
            } else {
                next('/');
            }
        },
    },
    {
        path: '/dashboard-waiter',
        name: 'WaiterDashboard',
        component: () => import('../pages/WaiterDashboardPage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            const userType = store.getters['storeAuth/getUserType'];
            console.log(userType);
            if (userType === 'waiter') {
                next();
            } else {
                next('/');
            }
        },
    },
    {
        path: '/dashboard-manager',
        name: 'ManagerDashboard',
        component: () => import('../pages/ManagerDashboardPage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            const userType = store.getters['storeAuth/getUserType'];
            console.log(userType);
            if (userType === 'manager') {
                next();
            } else {
                next('/');
            }
        },
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
