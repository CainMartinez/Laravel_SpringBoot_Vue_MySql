import axiosInstance from '../utils/axiosInstance.js';

const sendOtp = async (phone, otp) => {
    console.log('otpService: Preparing to send OTP...', { phone, otp });

    try {
        const payload = {
            to: phone,
            body: `🌟 *Restaurante QoRders* 🌟\n\nGracias por confiar en nosotros. 🙌\n\nSu reserva ha sido confirmada para el día:${otp}.\n\nPara cumplir con todas las reservas le pedimos puntualidad.\n\n📍 Dirección: Calle de la Buena Comida, 123, Madrid, España\n📞 Teléfono: +34 912 345 678\n📧 Email: contacto@qorders.com\n\n¡Esperamos verte pronto! 🍽️`,
        };

        console.log('otpService: Sending request with payload:', payload);

        const response = await axiosInstance.post('/messages/chat', payload);

        console.log('otpService: Received response from UltraMsg:', response.data);

        // Verifica si la respuesta indica que el mensaje fue enviado correctamente
        if (response.data.sent !== 'true') {
            console.error('otpService: OTP sending failed. Response data:', response.data);
            throw new Error(`Failed to send OTP: ${response.data.message || 'Unknown error'}`);
        }

        console.log('otpService: OTP sent successfully.');
        return response.data;
    } catch (error) {
        console.error('otpService: Error while sending OTP.', {
            message: error.message,
            stack: error.stack,
            response: error.response?.data,
        });
        throw new Error('Failed to send OTP');
    }
};

export default { sendOtp };