<template>
  <div class="payment-page">
    <div class="payment-card">
      <div class="payment-header">
        <h1>Confirmar Pago</h1>
        <p class="subtitle">Complete sus datos para finalizar la transacción</p>
      </div>

      <div class="payment-form">
        <form @submit.prevent="confirmPayment">
          <div class="form-group">
            <label for="card-holder">Titular de la tarjeta</label>
            <input type="text" id="card-holder" v-model="cardHolder" placeholder="Nombre completo" required>
          </div>

          <div class="form-group">
            <label for="card-element">Datos de la tarjeta</label>
            <div id="card-element" class="card-element"></div>
            <div id="card-errors" class="error-message" v-if="cardError">{{ cardError }}</div>
          </div>

          <div class="form-actions">
            <button type="submit" class="confirm-button" :disabled="isProcessing">
              <span v-if="!isProcessing">Confirmar pago</span>
              <span v-else class="spinner"></span>
            </button>
          </div>
        </form>
      </div>

      <div v-if="statusMessage" :class="['status-message', statusType]">
        {{ statusMessage }}
      </div>

      <div class="payment-footer">
        <div class="security-info">
          <!-- Usar un emoji en lugar de un icono de librería -->
          <span class="lock-icon">🔒</span> Pago seguro con encriptación SSL
        </div>
        <div class="card-icons">
          <!-- Usar URLs directas a imágenes de tarjetas de crédito -->
            <img src="https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png" alt="Visa" width="60">
            <img src="https://upload.wikimedia.org/wikipedia/commons/b/b7/MasterCard_Logo.svg" alt="Mastercard" width="60">
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { loadStripe } from '@stripe/stripe-js';

const route = useRoute();
const router = useRouter();
const clientSecret = route.query.clientSecret;
const statusMessage = ref('');
const statusType = ref('');
const cardHolder = ref('');
const cardError = ref('');
const isProcessing = ref(false);


const customerEmail = import.meta.env.VITE_CUSTOMER_EMAIL || '';
const customerPhone = import.meta.env.VITE_CUSTOMER_PHONE || '';

let stripe, elements, cardElement;

onMounted(async () => {
  try {
    stripe = await loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY);
    elements = stripe.elements({
      fonts: [
        {
          cssSrc: 'https://fonts.googleapis.com/css?family=Roboto:300,400,500,600'
        }
      ]
    });
    
    cardElement = elements.create('card', {
      style: {
        base: {
          color: '#32325d',
          fontFamily: '"Roboto", Helvetica, sans-serif',
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          '::placeholder': {
            color: '#aab7c4'
          }
        },
        invalid: {
          color: '#fa755a',
          iconColor: '#fa755a'
        }
      }
    });
    
    cardElement.mount('#card-element');
    
    cardElement.on('change', (event) => {
      if (event.error) {
        cardError.value = event.error.message;
      } else {
        cardError.value = '';
      }
    });
  } catch (error) {
    statusMessage.value = 'Error al cargar Stripe: ' + error.message;
    statusType.value = 'error';
  }
});

const confirmPayment = async () => {
  if (!stripe || !elements) {
    statusMessage.value = 'Stripe no está cargado correctamente.';
    statusType.value = 'error';
    return;
  }

  isProcessing.value = true;

  try {
    const { error, paymentIntent } = await stripe.confirmCardPayment(clientSecret, {
      payment_method: {
        card: cardElement,
        billing_details: {
          name: cardHolder.value
        }
      }
    });

    if (error) {
      statusMessage.value = `Error: ${error.message}`;
      statusType.value = 'error';
    } else if (paymentIntent.status === 'succeeded') {
      statusMessage.value = "¡Pago procesado correctamente! Recibirá la confirmación por correo electrónico.";
      statusType.value = 'success';

      // 🔹 **Llamar al backend Spring Boot para notificar la confirmación**
      try {
        const response = await fetch('http://localhost:8079/api/payment/confirm', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            paymentIntentId: paymentIntent.id,  // ID real del pago en Stripe
            customerEmail: customerEmail, // Cargado desde variables de entorno
            customerPhone: customerPhone // Cargado desde variables de entorno
          })
        });

        if (!response.ok) {
          throw new Error('Error en la confirmación del pago con el backend.');
        }
      } catch (error) {
        console.error("Error al notificar a Spring Boot:", error);
      }

      // Redirigir después de la confirmación del pago
      setTimeout(() => {
        router.push('/'); // Ajusta la ruta a donde deseas redirigir al usuario
      }, 3000);
    }
  } catch (error) {
    statusMessage.value = `Error inesperado: ${error.message}`;
    statusType.value = 'error';
  } finally {
    isProcessing.value = false;
  }
};

</script>

<style scoped>
.payment-page {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f8f9fa;
  padding: 20px;
  font-family: 'Roboto', sans-serif;
}

.payment-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  width: 100%;
  max-width: 550px;
  transition: all 0.3s ease;
}

.payment-header {
  background-color: #2c3e50;
  color: white;
  padding: 25px;
  text-align: center;
}

.payment-header h1 {
  margin: 0;
  font-size: 24px;
  font-weight: 600;
}

.subtitle {
  font-size: 16px;
  opacity: 0.8;
  margin-top: 5px;
}

.payment-form {
  padding: 30px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #495057;
}

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ced4da;
  border-radius: 5px;
  font-size: 16px;
  transition: border-color 0.3s;
}

.form-group input:focus {
  border-color: #3498db;
  outline: none;
}

.card-element {
  border: 1px solid #ced4da;
  border-radius: 5px;
  padding: 12px;
}

.error-message {
  color: #e74c3c;
  font-size: 14px;
  margin-top: 5px;
}

.form-actions {
  margin-top: 30px;
}

.confirm-button {
  width: 100%;
  background-color: #3498db;
  color: white;
  border: none;
  padding: 14px;
  border-radius: 5px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s;
}

.confirm-button:hover {
  background-color: #2980b9;
}

.confirm-button:disabled {
  background-color: #7f8c8d;
  cursor: not-allowed;
}

.status-message {
  margin: 20px 30px;
  padding: 12px;
  border-radius: 5px;
  text-align: center;
}

.status-message.success {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.status-message.error {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

.payment-footer {
  background-color: #f8f9fa;
  border-top: 1px solid #e9ecef;
  padding: 20px;
  text-align: center;
}

.security-info {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
  color: #6c757d;
  font-size: 14px;
}

.lock-icon {
  margin-right: 5px;
  font-size: 16px;
}

.card-icons {
  display: flex;
  justify-content: center;
  gap: 10px;
}

.card-icons img {
  height: 30px;
  object-fit: contain;
}

.spinner {
  display: inline-block;
  width: 20px;
  height: 20px;
  border: 3px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 1s infinite linear;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

@media (max-width: 768px) {
  .payment-card {
    box-shadow: none;
    border-radius: 0;
  }
  
  .payment-header {
    padding: 20px;
  }
  
  .payment-header h1 {
    font-size: 20px;
  }
  
  .payment-form {
    padding: 20px;
  }
  
  .form-group input,
  .card-element {
    padding: 10px;
  }
  
  .confirm-button {
    padding: 12px;
  }
}

@media (max-width: 480px) {
  .payment-page {
    padding: 10px;
  }
  
  .payment-header h1 {
    font-size: 18px;
  }
  
  .subtitle {
    font-size: 14px;
  }
  
  .payment-form {
    padding: 15px;
  }
}
</style>