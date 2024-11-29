import otpService from '../services/otpService.js';

const sendOtp = async (request, reply) => {
    const { phone, otp } = request.body;

    // Log inicial para verificar entrada
    console.log("Received request body:", { phone, otp });

    if (!phone || !otp) {
        console.error("Validation Error: Phone or OTP missing");
        return reply.status(400).send({ error: 'Phone and OTP are required' });
    }

    try {
        // Log antes de llamar al servicio
        console.log("Sending OTP via service with:", { phone, otp });
        
        const result = await otpService.sendOtp(phone, otp);
        
        // Log después de la llamada al servicio
        console.log("OTP sent successfully, service response:", result);

        reply.status(200).send({ message: 'OTP sent successfully', result });
    } catch (error) {
        // Log del error capturado
        console.error("Error while sending OTP:", error.message);
        console.error("Stack trace:", error.stack);

        reply.status(500).send({ error: 'Failed to send OTP', details: error.message });
    }
};

export default { sendOtp };