<template>
    <div class="auth-experience">
        <div class="auth-container">
            <div class="auth-decoration left"></div>
            
            <div class="auth-content">
                <h1>{{ isLoginView ? 'Bienvenido de Nuevo' : 'Únase a Nuestra Mesa' }}</h1>
                <p class="auth-subtitle">
                    {{ isLoginView ? 'Acceda a su cuenta para continuar su experiencia gastronómica' : 'Complete su información para comenzar su viaje culinario con nosotros' }}
                </p>
                
                <!-- Selector de tipo de usuario (solo en login) -->
                <UserTypeSelector 
                    v-if="isLoginView" 
                    @update:selectedType="handleTypeChange" 
                />
                
                <!-- Nota para registro -->
                <div v-if="!isLoginView" class="client-registration-note">
                    <i class="pi pi-info-circle"></i>
                    <span>Está creando una cuenta de cliente. Los perfiles de gerente y camarero requieren autorización.</span>
                </div>

                <!-- Formulario de login o registro -->
                <LoginForm 
                    v-if="isLoginView" 
                    :selectedType="selectedType" 
                    @submit="login" 
                />
                <RegisterForm 
                    v-else 
                    :selectedType="'client'"
                    :isDisabled="false" 
                    @submit="handleRegister" 
                />

                <!-- Alternar entre login y registro -->
                <a @click="toggleForm" class="toggle-link">
                    {{ isLoginView ? '¿Nuevo por aquí? Crear una cuenta' : '¿Ya tiene cuenta? Iniciar sesión' }}
                </a>
            </div>
            
            <div class="auth-decoration right"></div>
        </div>
        
        <div class="auth-quote">
            <p>"La gastronomía es el arte de utilizar la comida para crear felicidad."</p>
        </div>
    </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';
import LoginForm from '../components/LoginForm.vue';
import RegisterForm from '../components/RegisterForm.vue';
import UserTypeSelector from '../components/UserTypeSelector.vue';
import useAuth from '../composables/useAuth';

const { login, register, isLoginView, toggleForm } = useAuth();
const selectedType = ref('client');

// Función para manejar el cambio de tipo de usuario (solo para login)
const handleTypeChange = (type) => {
    selectedType.value = type;
};

// Función para el registro (siempre como cliente)
const handleRegister = (userData) => {
    // Asegurar que el tipo de usuario siempre sea cliente
    userData.userType = 'client';
    
    // Proceder con el registro
    register(userData);
};

// Resetear a cliente cuando cambiamos entre vistas
watch(isLoginView, (isLogin) => {
    if (!isLogin) {
        // Si vamos a registro, fijar tipo a cliente
        selectedType.value = 'client';
    }
});
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.auth-experience {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 40px 20px;
    min-height: 100vh;
    background-color: #f9f6f0;
    color: #4a3933;
    font-family: 'Lora', serif;
    position: relative;
}

.auth-container {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    max-width: 1000px;
    margin-bottom: 20px;
}

.auth-content {
    background-color: white;
    padding: 40px;
    border-radius: 12px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 600px;
    position: relative;
    border: 1px solid #e8d9c5;
}

.auth-decoration {
    height: 80px;
    width: 1px;
    background: linear-gradient(to bottom, transparent, #8B4513, transparent);
    margin: 0 20px;
}

h1 {
    font-family: 'Playfair Display', serif;
    font-size: 2.2rem;
    font-weight: 700;
    color: #6b4423;
    margin: 0 0 15px;
    text-align: center;
}

.auth-subtitle {
    font-family: 'Lora', serif;
    font-style: italic;
    font-size: 1rem;
    color: #8B4513;
    margin: 0 0 30px;
    text-align: center;
}

.restriction-message {
    background-color: #fff3cd;
    color: #856404;
    border: 1px solid #ffeeba;
    border-radius: 6px;
    padding: 12px 16px;
    margin: 20px 0;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.95rem;
}

.restriction-message i {
    font-size: 1.2rem;
    color: #856404;
}

.toggle-link {
    display: block;
    margin-top: 25px;
    color: #8B4513;
    font-weight: 500;
    cursor: pointer;
    text-align: center;
    transition: all 0.3s ease;
    text-decoration: none;
}

.toggle-link:hover {
    color: #6b4423;
    text-decoration: underline;
}

.auth-quote {
    font-style: italic;
    color: #8B4513;
    text-align: center;
    margin-top: 20px;
    font-size: 1rem;
    max-width: 600px;
    opacity: 0.8;
}

.client-registration-note {
    background-color: #e6f7ff;
    color: #0c5460;
    border: 1px solid #d1ecf1;
    border-radius: 6px;
    padding: 12px 16px;
    margin: 0 0 25px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.95rem;
}

.client-registration-note i {
    font-size: 1.2rem;
    color: #0c5460;
}
@media (max-width: 768px) {
    .auth-container {
        flex-direction: column;
    }
    
    .auth-decoration {
        height: 1px;
        width: 80px;
        margin: 20px 0;
        background: linear-gradient(to right, transparent, #8B4513, transparent);
    }
    
    .auth-content {
        padding: 30px 20px;
    }
    
    h1 {
        font-size: 1.8rem;
    }
}
</style>