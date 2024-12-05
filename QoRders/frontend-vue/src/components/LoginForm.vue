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

        <p v-if="generalError" class="error">{{ generalError }}</p>
    </form>
</template>

<script setup>
import { ref } from 'vue';
import useAuth from '../composables/useAuth';
import useValidation from '../composables/useValidation';

const email = ref('');
const password = ref('');
const role = ref('client');
const { login } = useAuth();

const {
    emailError,
    passwordError,
    generalError,
    validateLoginForm,
} = useValidation();

const handleLogin = async () => {
    if (validateLoginForm(email.value, password.value)) {
        try {
            await login(email.value, password.value, role.value);
            // Redirigir al usuario después de un login exitoso
        } catch (error) {
            console.error('Login failed:', error);
        }
    }
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

form input[type="email"],
form input[type="password"] {
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

form .reset-button {
    margin-top: 20px;
    background-color: transparent;
    color: #007bff;
    border: none;
    cursor: pointer;
}

form .reset-button:hover {
    text-decoration: underline;
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
</style>