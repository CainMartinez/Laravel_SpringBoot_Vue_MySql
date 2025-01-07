import { ref } from 'vue';
import { useStore } from 'vuex';
import QRService from '../services/client/QRService';

export default function useQR() {
    const store = useStore();

    const loading = ref(true);
    const errorMessage = ref('');
    const successMessage = ref('');
    const bookingId = ref('');
    const token = ref('');

    // Función para validar el QR
    const validateQRCode = async (queryData) => {
        try {
            const response = await QRService.validateQRCode(queryData);

            if (response && response.token) {
                token.value = response.token;
                store.commit('storeAuth/setToken', token.value);
                store.commit('storeAuth/setUserType', 'client');
                localStorage.setItem('token', token.value);
                localStorage.setItem('userType', 'client');

                bookingId.value = response.bookingId;

                successMessage.value = 'QR validado con éxito. Redirigiendo...';
            }
        } catch (error) {
            errorMessage.value = 'Error al validar el QR. Intenta nuevamente.';
        } finally {
            loading.value = false;
        }
    };

    const validateBooking = async (bookingId) => {
        try {
            const response = await QRService.validateBooking(bookingId);
            return response;
        } catch (error) {
            errorMessage.value = 'Error al validar el QR. Intenta nuevamente.';
        } finally {
            loading.value = false;
        }
    }

    return {
        loading,
        errorMessage,
        successMessage,
        bookingId,
        validateQRCode,
        validateBooking
    };
}
