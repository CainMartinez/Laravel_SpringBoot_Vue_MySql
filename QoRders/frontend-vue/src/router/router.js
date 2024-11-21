import { createRouter, createWebHistory } from 'vue-router';

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
        path: '/room',
        name: 'Salas',
        component: () => import('../pages/RoomsPage.vue'),
    },
    {
        path: '/room/:slug',
        name: 'Carta',
        component: () => import('../pages/CartaPage.vue'),
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
