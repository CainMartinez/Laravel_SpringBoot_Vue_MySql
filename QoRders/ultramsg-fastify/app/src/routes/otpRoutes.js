import otpController from '../controllers/otpController.js';

export default async function otpRoutes(fastify, options) {
    fastify.post('/otp/send', otpController.sendOtp);
}