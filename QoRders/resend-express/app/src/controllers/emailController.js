import { sendEmailService } from '../services/emailService.js';

// Controlador para enviar correos
export const sendEmail = async (req, res) => {
    const { to, subject, html } = req.body;

    // Validación básica
    if (!to || !subject || !html) {
        return res.status(400).json({ error: 'Campos "to", "subject" y "html" son requeridos.' });
    }

    try {
        const response = await sendEmailService(to, subject, html);
        res.status(200).json({ message: 'Correo enviado con éxito', response });
    } catch (error) {
        console.error('Error enviando correo:', error);
        res.status(500).json({ error: 'No se pudo enviar el correo.' });
    }
};