<template>
    <form @submit.prevent="handleLogin" class="auth-form">
        <div class="form-group">
            <label for="email">Correo electrónico:</label>
            <div class="input-wrapper">
                <i class="pi pi-envelope"></i>
                <input type="text" id="email" v-model="email" required placeholder="su-email@ejemplo.com" />
            </div>
            <p v-if="emailError" class="error-message">{{ emailError }}</p>
        </div>

        <div class="form-group">
            <label for="password">Contraseña:</label>
            <div class="input-wrapper">
                <i class="pi pi-lock"></i>
                <input type="password" id="password" v-model="password" required placeholder="Su contraseña" />
            </div>
            <p v-if="passwordError" class="error-message">{{ passwordError }}</p>
        </div>

        <button type="submit" class="submit-button">
            <span>Iniciar sesión</span>
            <i class="pi pi-sign-in"></i>
        </button>

        <!-- Modal de error -->
        <div v-if="showModal" class="modal-overlay" @click="closeModal">
            <div class="modal-content" @click.stop>
                <i class="pi pi-exclamation-circle modal-icon"></i>
                <h2>Error de autenticación</h2>
                <p>{{ generalError }}</p>
                <button @click="closeModal" class="modal-button">Cerrar</button>
            </div>
        </div>
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
    }
});

const email = ref('');
const password = ref('');
const showModal = ref(false);
const { login } = useAuth();
const { emailError, passwordError, generalError, validateLoginForm } = useValidation();

const handleLogin = async () => {
    if (validateLoginForm(email.value, password.value)) {
        try {
            await login(email.value, password.value, props.selectedType);
        } catch (error) {
            console.error('Login failed:', error);

            if (error.response && error.response.data && error.response.data.message) {
                generalError.value = error.response.data.message;
            } else {
                generalError.value = "Email o contraseña incorrectos.";
            }

            showModal.value = true;
        }
    }
};

const closeModal = () => {
    showModal.value = false;
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.auth-form {
    width: 100%;
    font-family: 'Lora', serif;
}

.form-group {
    margin-bottom: 20px;
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

.input-wrapper:focus-within {
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

.submit-button:hover {
    background: linear-gradient(135deg, #c4a583, #7b3b0c);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(139, 69, 19, 0.2);
}

.submit-button:active {
    transform: translateY(0);
}

/* Modal de error */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(3px);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.modal-content {
    background: white;
    padding: 30px;
    border-radius: 12px;
    text-align: center;
    width: 90%;
    max-width: 400px;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
    animation: modalFadeIn 0.3s ease;
}

@keyframes modalFadeIn {
    from {
        opacity: 0;
        transform: scale(0.95);
    }
    to {
        opacity: 1;
        transform: scale(1);
    }
}

.modal-content h2 {
    font-family: 'Playfair Display', serif;
    margin: 10px 0;
    color: #6b4423;
    font-size: 1.5rem;
}

.modal-content p {
    font-size: 1rem;
    margin-bottom: 20px;
    color: #4a3933;
    line-height: 1.5;
}

.modal-icon {
    font-size: 2.5rem;
    color: #dc3545;
    margin-bottom: 10px;
}

.modal-button {
    padding: 10px 20px;
    background-color: #dc3545;
    color: white;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
    font-size: 0.95rem;
    transition: all 0.3s ease;
}

.modal-button:hover {
    background-color: #c82333;
}

@media (max-width: 768px) {
    .submit-button {
        padding: 12px 16px;
    }
}
</style>