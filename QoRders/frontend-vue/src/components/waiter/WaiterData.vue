<template>
    <div class="settings-container">
        <div class="settings-header">
            <i class="pi pi-id-card"></i>
            <h2>Ficha de Empleado</h2>
        </div>
        
        <div class="data-content">
            <!-- Sección de Información Personal -->
            <div class="form-section">
                <h3>Información Personal</h3>
                
                <div class="data-user-header">
                    <div class="avatar-container">
                        <div class="avatar-preview" v-if="userData.avatar_url">
                            <img :src="userData.avatar_url" alt="Foto de perfil" class="avatar-image" />
                        </div>
                        <div class="avatar-placeholder" v-else>
                            {{ getInitials() }}
                        </div>
                    </div>
                    <div class="id-container">
                        <span class="employee-id">ID: {{ userData.id || 'N/A' }}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-user"></i>
                            <span>Nombre Completo</span>
                        </div>
                        <div class="info-value">{{ userData.firstName }} {{ userData.lastName }}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-envelope"></i>
                            <span>Email</span>
                        </div>
                        <div class="info-value">{{ userData.email }}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-phone"></i>
                            <span>Teléfono</span>
                        </div>
                        <div class="info-value">{{ userData.phone_number || 'No disponible' }}</div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-info-circle"></i>
                            <span>Biografía</span>
                        </div>
                        <div class="info-value bio-text">{{ userData.bio || 'No disponible' }}</div>
                    </div>
                </div>
            </div>
            
            <!-- Sección de Información Laboral -->
            <div class="form-section">
                <h3>Información Laboral</h3>
                
                <div class="info-section">
                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-calendar"></i>
                            <span>Fecha de Contratación</span>
                        </div>
                        <div class="info-value">{{ userData.hire_date || 'No disponible' }}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-euro"></i>
                            <span>Salario</span>
                        </div>
                        <div class="info-value">{{ userData.salary ? `${userData.salary} €` : 'No disponible' }}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="pi pi-clock"></i>
                            <span>Disponibilidad de Turno</span>
                        </div>
                        <div class="info-value">{{ userData.shift_disponibility || 'No disponible' }}</div>
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
.settings-container {
    max-width: 900px;
    margin: 40px auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.settings-header {
    background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
    color: white;
    padding: 20px 30px;
    display: flex;
    align-items: center;
}

.settings-header i {
    font-size: 24px;
    margin-right: 15px;
}

.settings-header h2 {
    margin: 0;
    font-weight: 400;
    font-size: 24px;
    letter-spacing: 0.5px;
}

.data-content {
    padding: 30px;
}

.form-section {
    margin-bottom: 30px;
    background-color: #f9fafb;
    border-radius: 8px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
    transition: all 0.3s ease;
}

.form-section:hover {
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    transform: translateY(-2px);
}

.form-section h3 {
    margin-top: 0;
    margin-bottom: 20px;
    color: #2c3e50;
    font-size: 18px;
    font-weight: 500;
    border-bottom: 1px solid #e0e0e0;
    padding-bottom: 10px;
}

.data-user-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
}

.avatar-container {
    display: flex;
    align-items: center;
}

.avatar-preview {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    border: 3px solid #3498db;
}

.avatar-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.avatar-placeholder {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #3498db;
    color: white;
    font-size: 36px;
    font-weight: bold;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.id-container {
    background-color: #ebf8ff;
    padding: 8px 15px;
    border-radius: 20px;
    color: #3498db;
    font-size: 14px;
    letter-spacing: 0.5px;
    font-weight: 500;
    box-shadow: 0 2px 5px rgba(52, 152, 219, 0.1);
    border: 1px solid rgba(52, 152, 219, 0.2);
}

.info-section {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.info-row {
    display: flex;
    flex-direction: column;
    padding-bottom: 15px;
    border-bottom: 1px solid #edf2f7;
}

.info-label {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
    color: #4a5568;
    font-size: 14px;
    font-weight: 500;
}

.info-label i {
    margin-right: 10px;
    color: #3498db;
    font-size: 16px;
    width: 24px;
    text-align: center;
}

.info-value {
    color: #2d3748;
    font-size: 16px;
    padding-left: 34px;
}

.bio-text {
    font-style: italic;
    line-height: 1.6;
}

/* Responsive design */
@media (max-width: 768px) {
    .data-content {
        padding: 20px;
    }

    .form-section {
        padding: 20px;
    }

    .data-user-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }

    .id-container {
        align-self: flex-end;
    }
}
</style>