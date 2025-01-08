import { ref } from 'vue';
import { useStore } from 'vuex';
import QRService from '../services/client/QRService';
import RoomsService from '../services/client/RoomsService';

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

            if (response && response.accessToken) {
                token.value = response.accessToken;
                store.commit('storeAuth/setToken', token.value);
                store.commit('storeAuth/setUserType', 'client');
                localStorage.setItem('token', token.value);
                localStorage.setItem('userType', 'client');

                bookingId.value = response.bookingId;
                const bookingData = await validateBooking(bookingId.value);

                successMessage.value = 'QR validado con éxito. Redirigiendo...';
                return bookingData;
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

    const getRoomData = async (room_slug) => {
        try {
            const response = await RoomsService.getRoomBySlug(room_slug);
            return response;
        } catch (error) {
            errorMessage.value = 'Error al obtener los detalles de la sala. Intenta nuevamente.';
        } finally {
            loading.value = false;
        }
    };

    return {
        loading,
        errorMessage,
        successMessage,
        bookingId,
        validateQRCode,
        validateBooking,
        getRoomData,
    };
}