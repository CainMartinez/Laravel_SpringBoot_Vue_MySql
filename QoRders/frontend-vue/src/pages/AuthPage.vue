<template>
    <div class="login-register">
        <h1>{{ isLoginView ? 'Iniciar sesión' : 'Registrar cuenta' }}</h1>

        <!-- Selector de tipo de usuario -->
        <UserTypeSelector @update:selectedType="handleTypeChange" />

        <!-- Mensaje de error para tipos restringidos -->
        <div v-if="showRestrictionWarning" class="error-message">
            <i class="pi pi-exclamation-triangle"></i>
            Se necesitan permisos de administrador para registrar a este usuario.
        </div>

        <!-- Formulario de login o registro -->
        <LoginForm v-if="isLoginView" :selectedType="selectedType" @submit="login" />
        <RegisterForm 
            v-else 
            :selectedType="selectedType" 
            :isDisabled="isTypeRestricted" 
            @submit="handleRegister" 
        />

        <!-- Alternar entre login y registro -->
        <a @click="toggleForm" class="toggle-link">{{ isLoginView ? 'Crear una cuenta' : 'Ya tengo cuenta' }}</a>
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
const showRestrictionWarning = ref(false);

// Computed property para determinar si el tipo seleccionado está restringido
const isTypeRestricted = computed(() => {
    return selectedType.value !== 'client';
});

// Función para manejar el cambio de tipo de usuario
const handleTypeChange = (type) => {
    selectedType.value = type;
    
    // Si estamos en la vista de registro y no es cliente, mostrar la advertencia
    if (!isLoginView.value && type !== 'client') {
        showRestrictionWarning.value = true;
    } else {
        showRestrictionWarning.value = false;
    }
};

// Función intermediaria para el registro
const handleRegister = (userData) => {
    // Si es un tipo restringido, mostrar advertencia y no continuar
    if (userData.userType !== 'client') {
        showRestrictionWarning.value = true;
        return;
    }
    
    // Si es cliente, proceder con el registro normal
    register(userData);
};

// Actualizar la advertencia cuando cambia entre login/registro
watch(isLoginView, (isLogin) => {
    // Ocultar advertencia si vamos a login
    if (isLogin) {
        showRestrictionWarning.value = false;
    }
    // Mostrar advertencia si vamos a registro y no es cliente
    else if (selectedType.value !== 'client') {
        showRestrictionWarning.value = true;
    }
});
</script>

<style scoped>
.login-register {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background-color: #f7f7f7;
    color: #333;
    font-family: Arial, sans-serif;
}

h1 {
    font-size: 2.5em;
    margin-bottom: 30px;
    margin-top: 100px;
}

button {
    padding: 10px 20px;
    background-color: #333;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

button:hover {
    background-color: #555;
}

button:focus {
    outline: none;
}

button {
    margin-top: 20px;
}

a.toggle-link {
    margin-top: 20px;
    color: #333;
    cursor: pointer;
    text-decoration: none;
    transition: color 0.3s;
}

a.toggle-link:hover {
    text-decoration: underline;
}

.login-register>* {
    margin-bottom: 20px;
}

/* Estilos para el mensaje de error */
.error-message {
    background-color: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
    border-radius: 5px;
    padding: 12px 20px;
    margin: 10px 0;
    display: flex;
    align-items: center;
    gap: 10px;
    width: 100%;
    max-width: 400px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.error-message i {
    font-size: 1.2em;
    color: #dc3545;
}
</style>