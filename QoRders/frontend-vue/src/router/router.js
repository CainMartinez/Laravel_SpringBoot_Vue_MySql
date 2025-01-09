import { createRouter, createWebHistory } from 'vue-router';
import ReactWrapper from '../components/ReactWrapper.vue';
import { useStore } from 'vuex';

// Función para verificar autenticación y tipo de usuario
const requireAuth = (userType) => (to, from, next) => {
    const store = useStore();
    const isAuthenticated = store.getters['storeAuth/getIsAuthenticated'];
    const currentUserType = store.getters['storeAuth/getUserType'];
    if (isAuthenticated && currentUserType === userType) {
        next();
    } else {
        next('/');
    }
};

const loadManagerData = (userType) => async (to, from, next) => {
    const store = useStore();
    const isAuthenticated = store.getters['storeAuth/getIsAuthenticated'];
    const currentUserType = store.getters['storeAuth/getUserType'];

    await store.dispatch('storeAdmin/fetchGetGeneralMetrics');
    await store.dispatch('storeAdmin/fetchGetAllProducts');
    await store.dispatch('storeAdmin/fetchGetAllRooms');
    await store.dispatch('storeAdmin/fetchGetAllNgos');

    if (isAuthenticated && currentUserType === userType) {
        next();
    } else {
        next('/');
    }
}

const loadWaiterData = (userType) => async (to, from, next) => {
    const store = useStore();
    const isAuthenticated = store.getters['storeAuth/getIsAuthenticated'];
    const currentUserType = store.getters['storeAuth/getUserType'];

    // await store.dispatch('storeWaiter/fetchGetAllOrders');

    if (isAuthenticated && currentUserType === userType) {
        next();
    } else {
        next('/');
    }
}

const loadPaymentData = (userType) => async (to, from, next) => {
    const store = useStore();
    const isAuthenticated = store.getters['storeAuth/getIsAuthenticated'];
    const currentUserType = store.getters['storeAuth/getUserType'];
    const bookingId = store.getters['storeOrders/getBookingId'];
    const orderId = store.getters['storeOrders/getOrderId'];
    const token = store.getters['storeAuth/getToken'];

    if (isAuthenticated && currentUserType === userType) {
        try {
            await store.dispatch('storeOrders/fetchTicketData', { bookingId, token });
            await store.dispatch('storeOrders/fetchOrder', { orderId, token });
            next();
        } catch (error) {
            console.error("Error fetching payment data:", error);
            next('/');
        }
    } else {
        next('/');
    }
};

// Función para cargar varios tipos de datos
const loadRoomData = async (to, from, next) => {
    const store = useStore();
    if (to.params.slug) {
        await store.dispatch('storeProducts/fetchProductsByRoom', { room_slug: to.params.slug, filters: {} });
        await store.dispatch('storeRooms/fetchRoomBySlug', to.params.slug);
        next();
    } else {
        console.error("El parámetro 'slug' no está definido en la ruta.");
        next(false);
    }
};

const reservationGuard = (userType) => async (to, from, next) => {
    const store = useStore();
    await store.dispatch('storeRooms/fetchRooms');
    await store.dispatch('storeReservation/fetchShifts', { yearMonth: '2025-01' });
    next();
};

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
        beforeEnter: loadRoomData,
    },
    {
        path: '/reservation',
        name: 'Reserva',
        component: () => import('../pages/ReservationPage.vue'),
        beforeEnter: reservationGuard('client'),
    },
    {
        path: '/login',
        name: 'IniciarSesion',
        component: () => import('../pages/AuthPage.vue'),
        beforeEnter: (to, from, next) => {
            const store = useStore();
            if (store.getters['storeAuth/getIsAuthenticated']) {
                next('/');
            } else {
                next();
            }
        },
    },
    {
        path: '/donations',
        name: 'Donaciones',
        // component: ReactWrapper,
        beforeEnter: (to, from, next) => {
            window.location.href = 'http://localhost:8086';
        },
    },
    {
        path: '/profile',
        name: 'ClientProfile',
        component: () => import('../pages/ClientProfilePage.vue'),
        beforeEnter: requireAuth('client'),
    },
    {
        path: '/dashboard-waiter',
        name: 'WaiterDashboard',
        component: () => import('../pages/WaiterDashboardPage.vue'),
        beforeEnter: loadWaiterData('waiter'),
        children: [
            {
                path: 'qr/:bookingId',
                name: 'GenerateQR',
                component: () => import('../components/waiter/GenerateQR.vue'),
                props: true,
            },
        ],
    },
    {
        path: '/dashboard-manager',
        name: 'ManagerDashboard',
        component: () => import('../pages/ManagerDashboardPage.vue'),
        beforeEnter: loadManagerData('manager'),
    },
    {
        path: '/qr',
        name: 'QRPage',
        component: () => import('../pages/QRPage.vue'),
        beforeEnter: (to, from, next) => {
            const data = to.query.data;
            if (data) {
                next();
            } else {
                next();
                console.error("El parámetro 'data' no está definido en la ruta.");
            }
        }
    },
    {
        path: '/payment',
        name: 'Payment',
        component: () => import('../pages/PaymentPage.vue'),
        beforeEnter: loadPaymentData('client'),
    },
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

router.beforeEach(async (to, from, next) => {
    const store = useStore();
    const isAuthenticated = store.getters['storeAuth/getIsAuthenticated'];
    const token = store.getters['storeAuth/getToken'];

    if (isAuthenticated && token) {
        await store.dispatch('storeAuth/populate');
        next();
    } else if (to.meta.requiresAuth) {
        next({ name: 'IniciarSesion' });
    } else {
        next();
    }
});

export default router;
