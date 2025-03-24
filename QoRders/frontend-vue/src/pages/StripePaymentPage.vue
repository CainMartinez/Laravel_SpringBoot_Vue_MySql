<template>
  <div class="payment-page">
    <div class="payment-card">
      <div class="payment-header">
        <div class="restaurant-logo">
          <i class="pi pi-credit-card"></i>
        </div>
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
            <button type="button" class="back-button" @click="goBack">
              <i class="pi pi-arrow-left"></i>
              Volver
            </button>
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
          <span class="lock-icon">🔒</span> Pago seguro con encriptación SSL
        </div>
        <div class="card-icons">
          <img src="https://upload.wikimedia.org/wikipedia/commons/4/41/Visa_Logo.png" alt="Visa" width="60">
          <img src="https://upload.wikimedia.org/wikipedia/commons/b/b7/MasterCard_Logo.svg" alt="Mastercard" width="60">
        </div>
      </div>
    </div>
    
    <!-- Modal para confirmación de pago exitoso -->
    <Modal 
      v-model:visible="isModalVisible" 
      :title="modalTitle" 
      :message="modalMessage" 
      :showActionButtons="true"
      primaryButtonText="Mi Perfil"
      secondaryButtonText="Volver al Inicio"
      @primaryAction="goToProfile"
      @secondaryAction="goToHome"
    />
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { loadStripe } from '@stripe/stripe-js';
import Modal from '../components/Modal.vue';
import OrderService from '../services/client/OrderService';
import { useStore } from 'vuex';
import axios from 'axios';

const route = useRoute();
const router = useRouter();
const store = useStore();
const token = computed(() => store.getters['storeAuth/getToken']);
const couponApplied = computed(() => route.query.couponApplied === "true");

const clientSecret = route.query.clientSecret;
const orderData = computed(() => store.getters['storeOrders/getOrderData']);

const statusMessage = ref('');
const statusType = ref('');
const cardHolder = ref('');
const cardError = ref('');
const isProcessing = ref(false);
const isModalVisible = ref(false);
const modalTitle = ref('');
const modalMessage = ref('');


const customerEmail = import.meta.env.VITE_CUSTOMER_EMAIL || '';
const customerPhone = import.meta.env.VITE_CUSTOMER_PHONE || '';

let stripe, elements, cardElement;

onMounted(async () => {
  try {
    stripe = await loadStripe(import.meta.env.VITE_STRIPE_PUBLIC_KEY);
    elements = stripe.elements({
      fonts: [
        {
          cssSrc: 'https://fonts.googleapis.com/css?family=Lora:400,500,600'
        }
      ]
    });
    
    cardElement = elements.create('card', {
      style: {
        base: {
          color: '#4a3933',
          fontFamily: '"Lora", serif',
          fontSmoothing: 'antialiased',
          fontSize: '16px',
          '::placeholder': {
            color: '#8a7968'
          }
        },
        invalid: {
          color: '#c23616',
          iconColor: '#c23616'
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
  statusMessage.value = 'Procesando su pago...';
  statusType.value = 'info';

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
      // Código existente para manejo de errores...
    } else if (paymentIntent.status === 'succeeded') {
        statusMessage.value = "¡Pago procesado correctamente! Recibirá la confirmación por correo electrónico.";
        statusType.value = 'success';
        await updateBookingStatus();
        
        if (couponApplied.value) {
          await consumeCoupon();
        }
        
        const pointsUsed = parseInt(route.query.pointsUsed || 0);
        const finalAmount = parseFloat(route.query.totalAmount || 0);
        
        await updateClientLoyaltyPoints(pointsUsed, finalAmount);
        
      // Mostrar modal de confirmación
        showSuccessModal();
        
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
    }
  } catch (error) {
    statusMessage.value = `Error inesperado: ${error.message}`;
    statusType.value = 'error';
  } finally {
    isProcessing.value = false;
  }
};
// Añadir esta función si no existe

const updateClientLoyaltyPoints = async (pointsUsed, amountPaid) => {
  try {
    if (!token.value || !store.getters['storeAuth/getUserData']?.client) {
      console.warn('No hay datos de cliente disponibles para actualizar puntos');
      return;
    }
    
    const userData = store.getters['storeAuth/getUserData'];
    
    // Calcular puntos actuales
    let currentPoints = userData.client.loyalty_points || 0;
    
    // Restar puntos usados
    currentPoints -= parseInt(pointsUsed);
    
    // Añadir nuevos puntos (100 puntos por cada euro)
    const newPoints = Math.floor(amountPaid);  // 1€ = 1 punto
    currentPoints += newPoints * 100;  // 100 puntos por cada euro
    
    // Actualizar en el backend
    const response = await axios.put(
      'http://localhost:8090/spring/api/client',
      { loyalty_points: currentPoints },
      {
        headers: {
          'Authorization': `Bearer ${token.value}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    if (response.status === 200) {
      // Actualizar en el store
      store.commit('storeAuth/UPDATE_CLIENT_DATA', {
        ...userData.client,
        loyalty_points: currentPoints
      });
      
      // Mostrar mensaje de éxito
      let message = '';
      if (newPoints > 0) {
        message = `¡Has ganado ${newPoints * 100} puntos de fidelidad con esta compra!`;
      }
      if (parseInt(pointsUsed) > 0) {
        message += ` Has utilizado ${pointsUsed} puntos en este pago.`;
      }
      
      if (message) {
        store.dispatch('storeNotifications/pushNotification', {
          type: 'success',
          message: message.trim()
        });
      }
    }
  } catch (error) {
    console.error('Error al actualizar puntos de fidelidad:', error);
  }
};
const getBookingId = () => {
  // 1. Intentar obtener de la URL
  const urlBookingId = parseInt(route.query.bookingId, 10);
  if (!isNaN(urlBookingId)) {
    return urlBookingId;
  }
  
  // 2. Intentar obtener del store (primera estructura)
  const orderData = store.getters['storeOrders/getOrderData'];
  if (orderData?.bookingId) {
    return orderData.bookingId;
  }
  
  // 3. Intentar obtener del store (estructura alternativa)
  const storeOrders = store.state.storeOrders;
  if (storeOrders?.bookingId) {
    return storeOrders.bookingId;
  }
  
  return null;
};

const getOrderId = () => {
  // 1. Intentar obtener de la URL
  const urlOrderId = parseInt(route.query.orderId, 10);
  if (!isNaN(urlOrderId)) {
    return urlOrderId;
  }
  
  // 2. Intentar obtener del store
  const orderData = store.getters['storeOrders/getOrderData'];
  if (orderData?.orderId) {
    return orderData.orderId;
  }
  
  return null;
};

// Obtener los IDs
const bookingId = getBookingId();
const orderId = getOrderId();
// En StripePaymentPage.vue
const updateBookingStatus = async () => {
  try {
    if (!bookingId || !orderId) {
      console.error('Error: No se pudieron obtener los IDs necesarios para actualizar el estado');
      modalTitle.value = 'Error';
      modalMessage.value = 'No se pueden actualizar los datos del pedido. Por favor, contacte con el restaurante.';
      isModalVisible.value = true;
      return;
    }
    
    // Log para ver qué datos estamos enviando
    const paymentData = {
      bookingId: bookingId,
      orderId: orderId,
      paymentMethod: 'card',
      paymentStatus: 'PAID'
    };
    
    // Llamamos al servicio para actualizar el estado de la reserva
    const response = await OrderService.makePayment(paymentData);
    
    
    if (response.status === 'success') {
      // Mostrar el modal de éxito
      showSuccessModal();
    } else {
      throw new Error(response.message || 'Error al actualizar el estado de la reserva');
    }
  } catch (error) {
    console.error('Error completo:', error);
    // Resto del código de manejo de errores...
  }
};
const consumeCoupon = async () => {
  try {
    // Llamar al endpoint para marcar el cupón como usado
    await axios.put(
      'http://localhost:8090/spring/api/client',
      { has_coupon: false },
      {
        headers: {
          'Authorization': `Bearer ${token.value}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    // Actualizar el estado local
    store.commit('storeAuth/UPDATE_CLIENT_DATA', {
      has_coupon: false
    });
    
    console.log('Cupón consumido correctamente');
  } catch (error) {
    console.error('Error al consumir el cupón:', error);
  }
};
const showSuccessModal = () => {
  modalTitle.value = "¡Pago Completado!";
  modalMessage.value = "Su pago se ha procesado correctamente. ¿Desea ver su perfil con el historial de pedidos o volver a la página de inicio?";
  isModalVisible.value = true;
};

const goBack = () => {
  router.go(-1);
};

const goToProfile = () => {
  router.push('/profile');
};

const goToHome = () => {
  router.push('/');
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Lora:wght@400;500;600&display=swap');

.payment-page {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f8f5ef;
  background-image: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 63c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%238b4513' fill-opacity='0.03' fill-rule='evenodd'/%3E%3C/svg%3E");
  padding: 20px;
  font-family: 'Lora', serif;
}

.payment-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 15px 35px rgba(50, 50, 93, 0.1), 0 5px 15px rgba(0, 0, 0, 0.07);
  width: 100%;
  max-width: 500px;
  overflow: hidden;
  position: relative;
}

.payment-header {
  background: linear-gradient(135deg, #8B4513, #d4b48f);
  color: white;
  padding: 25px;
  text-align: center;
}

.restaurant-logo {
  display: flex;
  justify-content: center;
  margin-bottom: 15px;
}

.restaurant-logo i {
  font-size: 36px;
  color: white;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.payment-header h1 {
  margin: 0;
  font-family: 'Playfair Display', serif;
  font-size: 28px;
  font-weight: 600;
}

.subtitle {
  font-size: 16px;
  opacity: 0.9;
  margin-top: 5px;
}

.payment-form {
  padding: 30px 25px;
}

.form-group {
  margin-bottom: 20px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #4a3933;
}

.form-group input {
  width: 100%;
  padding: 12px;
  border: 1px solid #e8d9c5;
  border-radius: 6px;
  font-size: 16px;
  font-family: 'Lora', serif;
  color: #4a3933;
  transition: border-color 0.3s;
}

.form-group input:focus {
  border-color: #8B4513;
  outline: none;
  box-shadow: 0 0 0 3px rgba(139, 69, 19, 0.1);
}

.card-element {
  border: 1px solid #e8d9c5;
  border-radius: 6px;
  padding: 15px;
}

.error-message {
  color: #c23616;
  font-size: 14px;
  margin-top: 8px;
}

.form-actions {
  margin-top: 30px;
  display: flex;
  gap: 15px;
}

.back-button, .confirm-button {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 20px;
  border-radius: 6px;
  border: none;
  font-family: 'Lora', serif;
  font-weight: 500;
  font-size: 16px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.back-button {
  background-color: white;
  color: #8a7968;
  border: 1px solid #e8d9c5;
  flex: 1;
}

.confirm-button {
  background: linear-gradient(135deg, #8B4513, #d4b48f);
  color: white;
  box-shadow: 0 4px 10px rgba(139, 69, 19, 0.3);
  flex: 2;
}

.back-button:hover {
  background-color: #f9f6f2;
  color: #6b4423;
}

.confirm-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(139, 69, 19, 0.4);
}

.confirm-button:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.back-button i {
  margin-right: 8px;
}

.status-message {
  margin: 0 25px 20px;
  padding: 12px;
  border-radius: 6px;
  text-align: center;
  font-size: 15px;
}

.status-message.success {
  background-color: rgba(16, 185, 129, 0.1);
  color: #065f46;
  border: 1px solid rgba(16, 185, 129, 0.2);
}

.status-message.error {
  background-color: rgba(239, 68, 68, 0.1);
  color: #b91c1c;
  border: 1px solid rgba(239, 68, 68, 0.2);
}

.status-message.info {
  background-color: rgba(59, 130, 246, 0.1);
  color: #1e40af;
  border: 1px solid rgba(59, 130, 246, 0.2);
}

.payment-footer {
  background-color: #f8f5ef;
  border-top: 1px solid #e8d9c5;
  padding: 20px;
  text-align: center;
}

.security-info {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 15px;
  color: #8a7968;
  font-size: 14px;
}

.lock-icon {
  margin-right: 8px;
  font-size: 16px;
}

.card-icons {
  display: flex;
  justify-content: center;
  gap: 15px;
  margin-top: 10px;
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
    max-width: 100%;
  }
  
  .payment-header {
    padding: 20px;
  }
  
  .payment-header h1 {
    font-size: 24px;
  }
  
  .payment-form {
    padding: 20px;
  }
  
  .form-actions {
    flex-direction: column;
  }
  
  .back-button, .confirm-button {
    width: 100%;
  }
}
</style>