import axiosInstance from '../utils/axiosInstance.js';

const sendPaymentNotification = async (request, reply) => {
  const { phone } = request.body;

  if (!phone) {
    return reply.status(400).send({ error: 'Phone is required' });
  }

  try {
    // Construir el payload con el mensaje personalizado
    const payload = {
      to: phone,
      body: `🌟 *Restaurante QoRders* 🌟\n\nEspero que su estancia haya sido satisfactoria. 🙌\n\nSu pago ha sido completado con éxito.\n\nLe hemos enviado un correo electrónico con la confirmación y el número de transacción.\n\n¡Esperamos verte pronto! 🍽️\n\n📍 Dirección: Calle de la Buena Comida, 123, Madrid, España\n📞 Teléfono: +34 912 345 678\n📧 Email: contacto@qorders.com`
    };

    const response = await axiosInstance.post('/messages/chat', payload);

    // Validar que el mensaje se haya enviado correctamente
    if (response.data.sent !== 'true') {
      throw new Error(`Failed to send notification: ${response.data.message || 'Unknown error'}`);
    }

    reply.status(200).send({ message: 'Payment notification sent successfully', result: response.data });
  } catch (error) {
    reply.status(500).send({ error: 'Failed to send payment notification', details: error.message });
  }
};

export default { sendPaymentNotification };