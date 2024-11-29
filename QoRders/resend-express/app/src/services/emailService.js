import { Resend } from 'resend';
import dotenv from 'dotenv';

// Cargar variables de entorno desde el archivo .env
dotenv.config();

const resend = new Resend(process.env.RESEND_API_KEY);

// Servicio para enviar correos
export const sendEmailService = async (to, subject, html) => {
    try {
        const response = await resend.emails.send({
            from: 'onboarding@resend.dev',
            to,
            subject,
            html,
        });
        console.log('Correo enviado (Service):', response);
        return response;
    } catch (error) {
        console.error('Error en el servicio de correo:', error);
        throw error;
    }
};