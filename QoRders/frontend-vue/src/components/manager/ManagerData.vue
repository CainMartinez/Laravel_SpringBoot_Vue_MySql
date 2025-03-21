<template>
    <div class="manager-dashboard">
        <div class="dashboard-header">
            <div class="header-content">
                <h1>Panel de Gestión</h1>
                <p class="subtitle">Bienvenido, {{ userData.firstName }} {{ userData.lastName }}</p>
            </div>
            <div class="date-display">
                <i class="pi pi-calendar"></i>
                <span>{{ currentDate }}</span>
            </div>
        </div>

        <div class="dashboard-grid">
            <!-- Tarjeta de perfil -->
            <div class="dashboard-card profile-card">
                <div class="card-header">
                    <i class="pi pi-user"></i>
                    <h2>Perfil Personal</h2>
                </div>
                <div class="card-divider"></div>
                <div class="profile-avatar">
                    <div class="avatar-circle">
                        <span>{{ getInitials }}</span>
                    </div>
                </div>
                <div class="profile-details">
                    <div class="detail-item">
                        <i class="pi pi-id-card"></i>
                        <div>
                            <span class="label">Nombre completo</span>
                            <span class="value">{{ userData.firstName }} {{ userData.lastName }}</span>
                        </div>
                    </div>
                    <div class="detail-item">
                        <i class="pi pi-envelope"></i>
                        <div>
                            <span class="label">Email</span>
                            <span class="value">{{ userData.email }}</span>
                        </div>
                    </div>
                    <div class="detail-item" v-if="userData.phone_number">
                        <i class="pi pi-phone"></i>
                        <div>
                            <span class="label">Teléfono</span>
                            <span class="value">{{ userData.phone_number }}</span>
                        </div>
                    </div>
                    <div class="detail-item">
                        <i class="pi pi-euro"></i>
                        <div>
                            <span class="label">Salario</span>
                            <span class="value">{{ formatCurrency(userData.salary) }}</span>
                        </div>
                    </div>
                    <div class="bio-item" v-if="userData.bio">
                        <i class="pi pi-info-circle"></i>
                        <div>
                            <span class="label">Biografía</span>
                            <p class="bio-text">{{ userData.bio }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de métricas -->
            <div class="dashboard-card metrics-card">
                <div class="card-header">
                    <i class="pi pi-chart-bar"></i>
                    <h2>Métricas del Negocio</h2>
                </div>
                <div class="card-divider"></div>
                <div class="metrics-grid">
                    <div class="metric-box">
                        <div class="metric-icon confirmed">
                            <i class="pi pi-calendar-check"></i>
                        </div>
                        <div class="metric-content">
                            <span class="metric-value">{{ generalMetrics?.data?.bookings?.confirmed || 0 }}</span>
                            <span class="metric-label">Reservas Confirmadas</span>
                        </div>
                    </div>
                    <div class="metric-box">
                        <div class="metric-icon completed">
                            <i class="pi pi-check-circle"></i>
                        </div>
                        <div class="metric-content">
                            <span class="metric-value">{{ generalMetrics?.data?.bookings?.completed || 0 }}</span>
                            <span class="metric-label">Pedidos Completados</span>
                        </div>
                    </div>
                    <div class="metric-box">
                        <div class="metric-icon waiters">
                            <i class="pi pi-users"></i>
                        </div>
                        <div class="metric-content">
                            <span class="metric-value">{{ generalMetrics?.data?.total_waiters || 0 }}</span>
                            <span class="metric-label">Personal Activo</span>
                        </div>
                    </div>
                    <div class="metric-box">
                        <div class="metric-icon revenue">
                            <i class="pi pi-wallet"></i>
                        </div>
                        <div class="metric-content">
                            <span class="metric-value">{{ formatCurrency(generalMetrics?.data?.total_revenue || 0) }}</span>
                            <span class="metric-label">Facturación</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de acciones rápidas -->
            <div class="dashboard-card actions-card">
                <div class="card-header">
                    <i class="pi pi-cog"></i>
                    <h2>Acciones Rápidas</h2>
                </div>
                <div class="card-divider"></div>
                <div class="action-buttons">
                    <button class="action-button">
                        <i class="pi pi-calendar-plus"></i>
                        <span>Gestionar Reservas</span>
                    </button>
                    <button class="action-button">
                        <i class="pi pi-user-edit"></i>
                        <span>Gestionar Personal</span>
                    </button>
                    <button class="action-button">
                        <i class="pi pi-file-pdf"></i>
                        <span>Generar Informes</span>
                    </button>
                    <button class="action-button">
                        <i class="pi pi-cog"></i>
                        <span>Configuración</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

// Datos del usuario desde Vuex
const userData = computed(() => store.getters['storeAuth/getUserData']);

// Métricas generales desde Vuex
const generalMetrics = computed(() => store.getters['storeAdmin/getGeneralMetrics']);

// Obtener las iniciales del nombre del usuario
const getInitials = computed(() => {
    if (userData.value) {
        const firstInitial = userData.value.firstName ? userData.value.firstName.charAt(0) : '';
        const lastInitial = userData.value.lastName ? userData.value.lastName.charAt(0) : '';
        return (firstInitial + lastInitial).toUpperCase();
    }
    return '';
});

// Obtener la fecha actual formateada
const currentDate = ref(new Date().toLocaleDateString('es-ES', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
}));

// Función para formatear moneda
const formatCurrency = (value) => {
    if (!value) return '0,00 €';
    return new Intl.NumberFormat('es-ES', {
        style: 'currency',
        currency: 'EUR',
        minimumFractionDigits: 2
    }).format(value);
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

.manager-dashboard {
    font-family: 'Inter', sans-serif;
    width: 100%;
    padding: 20px;
    background-color: #f8fafc;
    color: #2d3748;
}

.dashboard-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e2e8f0;
}

.header-content h1 {
    font-size: 1.8rem;
    font-weight: 700;
    color: #1a365d;
    margin: 0;
    margin-bottom: 5px;
}

.subtitle {
    font-size: 1rem;
    color: #4a5568;
    margin: 0;
}

.date-display {
    display: flex;
    align-items: center;
    gap: 8px;
    color: #4a5568;
    font-size: 0.9rem;
    padding: 8px 15px;
    background-color: #ebf8ff;
    border-radius: 8px;
}

.date-display i {
    color: #3182ce;
}

.dashboard-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
}

.dashboard-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    padding: 20px;
    border: 1px solid #e2e8f0;
    overflow: hidden;
}

.profile-card {
    grid-column: 1 / 2;
    grid-row: 1 / 3;
}

.metrics-card {
    grid-column: 2 / 3;
    grid-row: 1 / 2;
}

.actions-card {
    grid-column: 2 / 3;
    grid-row: 2 / 3;
}

.card-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 5px;
}

.card-header i {
    font-size: 1.3rem;
    color: #3182ce;
    background-color: #ebf8ff;
    padding: 8px;
    border-radius: 8px;
}

.card-header h2 {
    font-size: 1.2rem;
    font-weight: 600;
    margin: 0;
    color: #2c5282;
}

.card-divider {
    height: 1px;
    background: linear-gradient(to right, #3182ce, #ebf8ff);
    margin: 15px 0;
}

/* Estilos para el perfil */
.profile-avatar {
    display: flex;
    justify-content: center;
    margin: 20px 0;
}

.avatar-circle {
    width: 80px;
    height: 80px;
    background: linear-gradient(135deg, #2c5282, #3182ce);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 2rem;
    font-weight: 600;
    box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3);
}

.profile-details {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.detail-item, .bio-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
}

.detail-item i, .bio-item i {
    color: #3182ce;
    font-size: 1rem;
    margin-top: 3px;
}

.detail-item div, .bio-item div {
    display: flex;
    flex-direction: column;
    flex: 1;
}

.label {
    font-size: 0.8rem;
    color: #718096;
    margin-bottom: 2px;
}

.value {
    font-size: 1rem;
    color: #2d3748;
    font-weight: 500;
}

.bio-text {
    font-size: 0.95rem;
    color: #4a5568;
    margin: 5px 0 0 0;
    line-height: 1.5;
    font-style: italic;
}

/* Estilos para las métricas */
.metrics-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 15px;
}

.metric-box {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 15px;
    border-radius: 8px;
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
    transition: all 0.3s ease;
}

.metric-box:hover {
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    transform: translateY(-2px);
}

.metric-icon {
    width: 45px;
    height: 45px;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.2rem;
}

.metric-icon.confirmed {
    background: linear-gradient(135deg, #3182ce, #4299e1);
}

.metric-icon.completed {
    background: linear-gradient(135deg, #38a169, #48bb78);
}

.metric-icon.waiters {
    background: linear-gradient(135deg, #805ad5, #9f7aea);
}

.metric-icon.revenue {
    background: linear-gradient(135deg, #dd6b20, #ed8936);
}

.metric-content {
    display: flex;
    flex-direction: column;
}

.metric-value {
    font-size: 1.5rem;
    font-weight: 600;
    color: #2d3748;
}

.metric-label {
    font-size: 0.8rem;
    color: #718096;
}

/* Estilos para los botones de acción */
.action-buttons {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 12px;
}

.action-button {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 15px;
    border-radius: 8px;
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
    cursor: pointer;
    transition: all 0.3s ease;
}

.action-button:hover {
    background-color: #ebf8ff;
    border-color: #bee3f8;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(49, 130, 206, 0.15);
}

.action-button i {
    font-size: 1.5rem;
    color: #3182ce;
}

.action-button span {
    font-size: 0.85rem;
    font-weight: 500;
    color: #4a5568;
}

/* Responsividad */
@media (max-width: 992px) {
    .dashboard-grid {
        grid-template-columns: 1fr;
    }
    
    .profile-card, .metrics-card, .actions-card {
        grid-column: 1 / 2;
        grid-row: auto;
    }
}

@media (max-width: 768px) {
    .dashboard-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }
    
    .date-display {
        align-self: flex-start;
    }
    
    .metrics-grid {
        grid-template-columns: 1fr;
    }
    
    .action-buttons {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 480px) {
    .manager-dashboard {
        padding: 15px;
    }
    
    .header-content h1 {
        font-size: 1.5rem;
    }
    
    .avatar-circle {
        width: 60px;
        height: 60px;
        font-size: 1.5rem;
    }
    
    .metric-value {
        font-size: 1.2rem;
    }
}
</style>