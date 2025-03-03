import paymentNotificationController from '../controllers/PaymentNotificationController.js';

export default async function paymentNotificationRoutes(fastify, options) {
  fastify.post('/payment/notification', paymentNotificationController.sendPaymentNotification);
}