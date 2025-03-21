<template>
    <div class="waiter-profile-card">
        <!-- Encabezado con avatar placeholder -->
        <div class="profile-header">
            <div class="avatar-container">
                <div class="avatar">
                    {{ getInitials() }}
                </div>
            </div>
            <div class="title-container">
                <h1>Ficha de Empleado</h1>
                <div class="employee-id">ID: {{ userData.id || 'N/A' }}</div>
            </div>
        </div>

        <!-- Contenido principal de dos columnas -->
        <div class="profile-content">
            <div class="profile-column personal-info">
                <h2>Información Personal</h2>
                <div class="info-row">
                    <i class="pi pi-user"></i>
                    <div>
                        <label>Nombre Completo</label>
                        <p>{{ userData.firstName }} {{ userData.lastName }}</p>
                    </div>
                </div>
                <div class="info-row">
                    <i class="pi pi-envelope"></i>
                    <div>
                        <label>Email</label>
                        <p>{{ userData.email }}</p>
                    </div>
                </div>
                <div class="info-row">
                    <i class="pi pi-phone"></i>
                    <div>
                        <label>Teléfono</label>
                        <p>{{ userData.phone_number || 'No disponible' }}</p>
                    </div>
                </div>
                <div class="info-row">
                    <i class="pi pi-info-circle"></i>
                    <div>
                        <label>Bio</label>
                        <p>{{ userData.bio || 'No disponible' }}</p>
                    </div>
                </div>
            </div>
            
            <div class="profile-column employment-info">
                <h2>Información Laboral</h2>
                <div class="info-row">
                    <i class="pi pi-calendar"></i>
                    <div>
                        <label>Fecha de Contratación</label>
                        <p>{{ userData.hire_date || 'No disponible' }}</p>
                    </div>
                </div>
                <div class="info-row">
                    <i class="pi pi-euro"></i>
                    <div>
                        <label>Salario</label>
                        <p>{{ userData.salary || 'No disponible' }} €</p>
                    </div>
                </div>
                <div class="info-row">
                    <i class="pi pi-clock"></i>
                    <div>
                        <label>Disponibilidad de Turno</label>
                        <p>{{ userData.shift_disponibility || 'No disponible' }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const userData = computed(() => store.getters['storeAuth/getUserData']);

// Función para obtener las iniciales del nombre para el avatar
const getInitials = () => {
    if (!userData.value) return '?';
    const first = userData.value.firstName ? userData.value.firstName.charAt(0) : '';
    const last = userData.value.lastName ? userData.value.lastName.charAt(0) : '';
    return (first + last).toUpperCase();
};
</script>

<style scoped>
.waiter-profile-card {
    padding: 0;
    margin: 40px auto;
    max-width: 900px;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Estilos para el encabezado */
.profile-header {
    display: flex;
    align-items: center;
    background: linear-gradient(135deg, #0a4f70 0%, #0d6efd 100%);
    color: white;
    padding: 30px;
    position: relative;
}

.avatar-container {
    margin-right: 25px;
}

.avatar {
    width: 80px;
    height: 80px;
    background-color: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
    font-weight: bold;
    color: white;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
    border: 3px solid rgba(255, 255, 255, 0.3);
}

.title-container h1 {
    margin: 0;
    font-size: 28px;
    font-weight: 300;
    letter-spacing: 1px;
}

.employee-id {
    margin-top: 5px;
    font-size: 14px;
    opacity: 0.8;
    letter-spacing: 1px;
}

/* Estilos para el contenido principal */
.profile-content {
    display: flex;
    flex-wrap: wrap;
    padding: 0;
}

.profile-column {
    flex: 1;
    min-width: 300px;
    padding: 30px;
}

.profile-column h2 {
    font-size: 18px;
    color: #0a4f70;
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e0e0e0;
    font-weight: 500;
    letter-spacing: 0.5px;
}

.personal-info {
    border-right: 1px solid #f0f0f0;
}

.info-row {
    display: flex;
    margin-bottom: 25px;
    align-items: flex-start;
}

.info-row i {
    font-size: 18px;
    margin-right: 15px;
    color: #0d6efd;
    background-color: rgba(13, 110, 253, 0.1);
    width: 36px;
    height: 36px;
    border-radius: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.info-row label {
    display: block;
    font-size: 12px;
    color: #888;
    margin-bottom: 5px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.info-row p {
    margin: 0;
    font-size: 16px;
    color: #333;
}

/* Efectos decorativos */
.waiter-profile-card::after {
    content: "";
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    width: 5px;
    background: linear-gradient(to bottom, #0a4f70, #0d6efd);
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
}

/* Estilos responsivos */
@media (max-width: 768px) {
    .profile-content {
        flex-direction: column;
    }
    
    .personal-info {
        border-right: none;
        border-bottom: 1px solid #f0f0f0;
    }
    
    .profile-header {
        flex-direction: column;
        text-align: center;
        padding: 20px;
    }
    
    .avatar-container {
        margin-right: 0;
        margin-bottom: 15px;
    }
    
    .profile-column {
        padding: 20px;
    }
}
</style>