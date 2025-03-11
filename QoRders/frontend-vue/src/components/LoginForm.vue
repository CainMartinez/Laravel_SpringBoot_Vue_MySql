<template>
    <form @submit.prevent="handleLogin">
        <div>
            <label for="email">Correo electrónico:</label>
            <input type="text" id="email" v-model="email" required />
            <p v-if="emailError" class="error">{{ emailError }}</p>
        </div>

        <div>
            <label for="password">Contraseña:</label>
            <input type="password" id="password" v-model="password" required />
            <p v-if="passwordError" class="error">{{ passwordError }}</p>
        </div>

        <button type="submit">Iniciar sesión</button>

        <!-- Modal de error -->
        <div v-if="showModal" class="modal-overlay" @click="closeModal">
            <div class="modal-content" @click.stop>
                <h2>Error</h2>
                <p>{{ generalError }}</p>
                <button @click="closeModal">Cerrar</button>
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
const showModal = ref(false); // 🔹 Controla la visibilidad del modal
const { login } = useAuth();
const { emailError, passwordError, generalError, validateLoginForm } = useValidation();

const handleLogin = async () => {
    if (validateLoginForm(email.value, password.value)) {
        try {
            await login(email.value, password.value, props.selectedType);
        } catch (error) {
            console.error('Login failed:', error);

            // 🔹 Capturar mensaje de error desde `response.data.message`
            if (error.response && error.response.data && error.response.data.message) {
                generalError.value = error.response.data.message;
            } else {
                generalError.value = "Email o contraseña incorrectos.";
            }

            showModal.value = true; // 🔹 Mostrar el modal
        }
    }
};

const closeModal = () => {
    showModal.value = false;
};
</script>

<style scoped>
form {
    width: 100%;
    max-width: 400px;
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

form input {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
}

form .error {
    color: red;
    font-size: 14px;
}

label {
    font-size: 14px;
    font-weight: bold;
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

/* 🔹 Modal de error */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.modal-content {
    background: white;
    padding: 20px;
    border-radius: 8px;
    text-align: center;
    width: 90%;
    max-width: 400px;
}

.modal-content h2 {
    margin: 0 0 10px;
}

.modal-content p {
    font-size: 16px;
}

.modal-content button {
    margin-top: 15px;
    padding: 10px 15px;
    background-color: #d9534f;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.modal-content button:hover {
    background-color: #c9302c;
}
</style>