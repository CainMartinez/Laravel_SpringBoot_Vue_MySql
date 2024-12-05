import { ref } from 'vue';

export default function useValidation() {
    const emailError = ref('');
    const passwordError = ref('');
    const repeatPasswordError = ref('');
    const generalError = ref('');

    const validateEmail = (email) => {
        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|es|org|net|co)$/;
        if (!emailPattern.test(email)) {
            emailError.value = 'El email no es válido. Debe contener @ y un dominio válido como .com o .es.';
            return false;
        }
        emailError.value = '';
        return true;
    };

    const validatePassword = (password) => {
        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$/;
        if (!passwordPattern.test(password)) {
            passwordError.value = 'La contraseña debe tener al menos una mayúscula, una minúscula y un número.';
            return false;
        }
        passwordError.value = '';
        return true;
    };

    const validateRepeatPassword = (password, repeatPassword) => {
        if (password !== repeatPassword) {
            repeatPasswordError.value = 'Las contraseñas no coinciden.';
            return false;
        }
        repeatPasswordError.value = '';
        return true;
    };

    const validateRegisterForm = (email, password, repeatPassword) => {
        generalError.value = '';
        let isValid = true;

        if (!validateEmail(email)) {
            isValid = false;
        }
        if (!validatePassword(password)) {
            isValid = false;
        }
        if (!validateRepeatPassword(password, repeatPassword)) {
            isValid = false;
        }

        if (!isValid) {
            generalError.value = 'Por favor corrige los errores antes de enviar el formulario.';
        }

        return isValid;
    };

    const validateLoginForm = (email, password) => {
        generalError.value = '';
        let isValid = true;

        if (!validateEmail(email)) {
            isValid = false;
        }
        if (!validatePassword(password)) {
            isValid = false;
        }

        if (!isValid) {
            generalError.value = 'Por favor corrige los errores antes de enviar el formulario.';
        }

        return isValid;
    };

    return {
        emailError,
        passwordError,
        repeatPasswordError,
        generalError,
        validateRegisterForm,
        validateLoginForm
    };
}
