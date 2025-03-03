import Fastify from 'fastify';
import dotenv from 'dotenv';
import otpRoutes from './src/routes/otpRoutes.js';
import paymentNotificationRoutes from './src/routes/paymentNotificationRoutes.js';

dotenv.config();

const fastify = Fastify({ logger: true });

// Registrar rutas
fastify.register(otpRoutes, { prefix: '/api' });
fastify.register(paymentNotificationRoutes, { prefix: '/api' });

const PORT = process.env.PORT || 3001;

const start = async () => {
    try {
        await fastify.listen({ port: PORT, host: '0.0.0.0' });
        fastify.log.info(`Server running on http://0.0.0.0:${PORT}`);
    } catch (err) {
        fastify.log.error(err);
        process.exit(1);
    }
};

start();