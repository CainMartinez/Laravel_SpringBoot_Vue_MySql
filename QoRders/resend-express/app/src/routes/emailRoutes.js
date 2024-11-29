import { Router } from 'express';
import { sendEmail } from '../controllers/emailController.js';

const router = Router();

// Ruta para enviar correos
router.post('/send', sendEmail);

export default router;