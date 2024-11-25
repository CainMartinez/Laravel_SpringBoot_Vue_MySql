import { createRouter, createWebHistory } from 'vue-router';
import ReactWrapper from '../components/ReactWrapper.vue';
import { useStore } from 'vuex';

// Definición de rutas
const routes = [
    {
        path: '/',
        name: 'Inicio',
        component: () => import('../pages/HomePage.vue'),
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
            store.dispatch('storeProducts/fetchProductsByRoom', to.params.slug);
            store.dispatch('storeRooms/fetchRoomBySlug', to.params.slug);
            next();
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
    },
    {
        path: '/donations',
        name: 'Donaciones',
        component: ReactWrapper,
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
