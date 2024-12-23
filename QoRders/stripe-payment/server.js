require('dotenv').config();
const express = require('express');
const Stripe = require('stripe');
const bodyParser = require('body-parser');

const app = express();
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

app.use(bodyParser.json());

// Ruta para crear un Intent de Pago
app.post('/api/payment', async (req, res) => {
    const { orderId, totalAmount } = req.body;

    try {
        // Crear un Intent de Pago en Stripe
        const paymentIntent = await stripe.paymentIntents.create({
            amount: Math.round(totalAmount * 100), // Convertir a centavos
            currency: 'eur', // Cambiado a euros
            payment_method_types: ['card'], // Admitimos pagos con tarjeta
            metadata: { orderId },
        });

        res.status(200).json({
            status: 'Success',
            clientSecret: paymentIntent.client_secret, // Para completar el pago en el frontend
        });
    } catch (error) {
        console.error('Error procesando el pago:', error.message);
        res.status(500).json({
            status: 'Error',
            message: error.message,
        });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Stripe microservice running on port ${PORT}`);
});