import axiosInstance from '../utils/axiosInstance.js';

const sendOtp = async (phone, otp) => {
    console.log('otpService: Preparing to send OTP...', { phone, otp });

    try {
        let formattedDate = '';
        let turno = '';
        
        // Verificar si el otp contiene el formato esperado
        if (otp) {
            const parts = otp.split(' turno de ');
            if (parts.length === 2) {
                // Extraer fecha y turno
                const fechaISO = parts[0]; // formato ISO: YYYY-MM-DD
                turno = parts[1]; // "comida" o "cena"
                
                // Convertir la fecha al formato español
                const [year, month, day] = fechaISO.split('-');
                formattedDate = `${day}/${month}/${year}`;
            } else {
                // Si no tiene el formato esperado, usar el valor original
                formattedDate = otp;
            }
        }
        const payload = {
            to: phone,
            body: `🌟 *Restaurante QoRders* 🌟\n\nEstimado cliente: 🙌\n\nSu reserva ha sido confirmada para el *${formattedDate}* en el *turno de ${turno}*.\n\nPara cumplir con todas las reservas le pedimos puntualidad.\n\n📍 Dirección: Calle de la Buena Comida, 123, Madrid, España\n📞 Teléfono: +34 912 345 678\n📧 Email: contacto@qorders.com\n\n*¡Gracias por elegirnos!* 🍽️`,
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