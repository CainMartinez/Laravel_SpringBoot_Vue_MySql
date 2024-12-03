import { ref } from 'vue';
import { useStore } from 'vuex';

export default function useAuth() {
    const store = useStore();
    const isLoginView = ref(true);

    const login = async (email, password) => {
        // Lógica para autenticarse
        try {
            await store.dispatch('auth/login', { email, password });
        } catch (error) {
            throw new Error('Error en el login: ' + error.message);
        }
    };

    const register = async (email, password) => {
        // Lógica para registrarse
        try {
            await store.dispatch('auth/register', { email, password });
        } catch (error) {
            throw new Error('Error en el registro: ' + error.message);
        }
    };

    const toggleForm = () => {
        isLoginView.value = !isLoginView.value;
    };

    return {
        login,
        register,
        isLoginView,
        toggleForm
    };
}
