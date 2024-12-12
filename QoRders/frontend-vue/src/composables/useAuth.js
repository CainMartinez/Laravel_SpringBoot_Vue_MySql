import { ref } from 'vue';
import { useStore } from 'vuex';
import { onMounted } from 'vue';

export default function useAuth() {
    const store = useStore();
    const isLoginView = ref(true);
    const errorMessage = ref('');

    onMounted(() => {
        store.dispatch('storeAuth/populate');
    });

    // Login
    const login = async (email, password, role) => {
        if (role !== undefined) {
            console.log('Login:', email, password, role);
            try {
                await store.dispatch('storeAuth/login', { email, password, role });
            } catch (error) {
                errorMessage.value = 'Email o contraseña incorrectos.';
                throw new Error('Error en el login: ' + error.message);
            }
        }
    };

    // Registro
    const register = async (firstName, lastName, email, password, repeatPassword, role) => {
        if (role !== undefined) {
            console.log('Register:', firstName, lastName, email, password, repeatPassword, role);
            try {
                await store.dispatch('storeAuth/register', { firstName, lastName, email, password, repeatPassword, role });
                location.reload();
            } catch (error) {
                errorMessage.value = 'Error al registrar el usuario.';
                throw new Error('Error en el registro: ' + error.message);
            }
        }
    };

    // Alternar entre el formulario de login y registro
    const toggleForm = () => {
        isLoginView.value = !isLoginView.value;
    };

    const logout = async () => {
        try {
            await store.dispatch('storeAuth/logout', store.state.storeAuth);
        } catch (error) {
            errorMessage.value = 'Error al cerrar sesión.';
            throw new Error('Error en el logout: ' + error.message);
        }
    };

    return {
        login,
        register,
        logout,
        isLoginView,
        toggleForm,
        errorMessage
    };
}
