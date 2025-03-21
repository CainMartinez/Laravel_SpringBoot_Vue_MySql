<template>
    <form @submit.prevent="handleRegister" class="auth-form">
        <div class="form-row">
            <div class="form-group">
                <label for="firstName">Nombre:</label>
                <div class="input-wrapper">
                    <i class="pi pi-user"></i>
                    <input type="text" id="firstName" v-model="firstName" required :disabled="isDisabled" placeholder="Su nombre" />
                </div>
            </div>

            <div class="form-group">
                <label for="lastName">Apellidos:</label>
                <div class="input-wrapper">
                    <i class="pi pi-id-card"></i>
                    <input type="text" id="lastName" v-model="lastName" required :disabled="isDisabled" placeholder="Sus apellidos" />
                </div>
            </div>
        </div>

        <div class="form-group">
            <label for="email">Correo electrónico:</label>
            <div class="input-wrapper">
                <i class="pi pi-envelope"></i>
                <input type="text" id="email" v-model="email" required :disabled="isDisabled" placeholder="su-email@ejemplo.com" />
            </div>
            <p v-if="emailError" class="error-message">{{ emailError }}</p>
        </div>

        <div class="form-group">
            <label for="password">Contraseña:</label>
            <div class="input-wrapper">
                <i class="pi pi-lock"></i>
                <input type="password" id="password" v-model="password" required :disabled="isDisabled" placeholder="Su contraseña" />
            </div>
            <p v-if="passwordError" class="error-message">{{ passwordError }}</p>
        </div>

        <div class="form-group">
            <label for="repeatPassword">Repetir Contraseña:</label>
            <div class="input-wrapper">
                <i class="pi pi-lock"></i>
                <input type="password" id="repeatPassword" v-model="repeatPassword" required :disabled="isDisabled" placeholder="Repita su contraseña" />
            </div>
            <p v-if="repeatPasswordError" class="error-message">{{ repeatPasswordError }}</p>
        </div>

        <button type="submit" :disabled="isDisabled" :class="['submit-button', { disabled: isDisabled }]">
            <span>Crear su cuenta</span>
            <i class="pi pi-user-plus"></i>
        </button>

        <p v-if="generalError" class="error-message centered">{{ generalError }}</p>
        
        <p v-if="isDisabled" class="disclaimer">
            <i class="pi pi-info-circle"></i> 
            Este tipo de cuenta requiere permisos adicionales
        </p>
    </form>
</template>

<script setup>
import { ref } from 'vue';
import useAuth from '../composables/useAuth';
import useValidation from '../composables/useValidation';

const props = defineProps({
    selectedType: {
        type: String,
        required: true
    },
    isDisabled: {
        type: Boolean,
        default: false
    }
});

const email = ref('');
const password = ref('');
const repeatPassword = ref('');
const firstName = ref('');
const lastName = ref('');
const { register } = useAuth();
const { emailError, passwordError, repeatPasswordError, generalError, validateRegisterForm } = useValidation();

const handleRegister = async () => {
    if (props.isDisabled) {
        return;
    }
    
    if (validateRegisterForm(email.value, password.value, repeatPassword.value)) {
        try {
            await register(firstName.value, lastName.value, email.value, password.value, repeatPassword.value, props.selectedType);
        } catch (error) {
            console.error('Error al registrar:', error);
        }
    }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.auth-form {
    width: 100%;
    font-family: 'Lora', serif;
}

.form-row {
    display: flex;
    gap: 15px;
    margin-bottom: 10px;
}

.form-group {
    margin-bottom: 20px;
    flex: 1;
}

label {
    display: block;
    font-size: 0.9rem;
    font-weight: 600;
    color: #6b4423;
    margin-bottom: 8px;
}

.input-wrapper {
    position: relative;
    display: flex;
    align-items: center;
    border: 1px solid #e8d9c5;
    border-radius: 8px;
    overflow: hidden;
    transition: all 0.3s ease;
}

.input-wrapper:focus-within:not(.disabled) {
    border-color: #8B4513;
    box-shadow: 0 0 0 2px rgba(139, 69, 19, 0.1);
}

.input-wrapper i {
    position: absolute;
    left: 12px;
    color: #8B4513;
    font-size: 1rem;
}

input {
    width: 100%;
    padding: 14px 14px 14px 40px;
    font-size: 1rem;
    border: none;
    outline: none;
    background-color: #fff;
    color: #4a3933;
    font-family: 'Lora', serif;
}

input::placeholder {
    color: #ccc;
    font-style: italic;
    font-size: 0.9rem;
}

.error-message {
    margin-top: 6px;
    color: #dc3545;
    font-size: 0.85rem;
}

.error-message.centered {
    text-align: center;
    margin: 15px 0;
}

.submit-button {
    width: 100%;
    padding: 14px 20px;
    background: linear-gradient(135deg, #d4b48f, #8B4513);
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    font-size: 1rem;
    margin-top: 10px;
    transition: all 0.3s ease;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px;
    font-family: 'Lora', serif;
}

.submit-button:hover:not(.disabled) {
    background: linear-gradient(135deg, #c4a583, #7b3b0c);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(139, 69, 19, 0.2);
}

.submit-button:active:not(.disabled) {
    transform: translateY(0);
}

.submit-button.disabled {
    background: linear-gradient(135deg, #d9d9d9, #b3b3b3);
    color: #777;
    cursor: not-allowed;
    opacity: 0.8;
}

input:disabled {
    background-color: #f5f5f5;
    cursor: not-allowed;
    opacity: 0.7;
}

.disclaimer {
    margin-top: 15px;
    font-size: 0.9rem;
    color: #856404;
    background-color: #fff3cd;
    padding: 10px 15px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.disclaimer i {
    font-size: 1rem;
    color: #856404;
}

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
        gap: 0;
    }
    
    .submit-button {
        padding: 12px 16px;
    }
}
</style>