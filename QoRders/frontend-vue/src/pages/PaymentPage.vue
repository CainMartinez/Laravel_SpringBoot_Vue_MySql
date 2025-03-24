<template>
  <div class="payment-page">
    <div class="background-decoration"></div>
    <div class="loading-container" v-if="!orderData">
      <div class="loading-spinner"></div>
      <p>Cargando información del pedido...</p>
    </div>
    <!-- Ticket Card -->
    <div class="ticket-container" v-else>
      <div class="ticket-card">
        <div class="ticket-header">
          <div class="restaurant-logo">
            <i class="pi pi-utensils"></i>
          </div>
          <h2>Su Cuenta</h2>
          <p class="booking-ref">Pedido #{{ orderData.orderId }}</p>
        </div>

        <!-- Productos -->
        <div class="ticket-body">
          <div class="product-list">
            <div v-for="(product, index) in orderData.orderProducts" :key="index" class="product-item">
              <div class="product-info">
                <span class="product-name">{{ product.productName }}</span>
                <span class="product-quantity">x{{ product.quantity }}</span>
              </div>
              <span class="product-price">{{ formatPrice(product.unitPrice * product.quantity) }}</span>
            </div>
          </div>
          
          <div class="separator"></div>
          <div class="subtotal-section">
            <div class="subtotal-row">
              <span>Subtotal</span>
              <span>{{ formatPrice(subtotalAmount) }}</span>
            </div>
            <div class="subtotal-row">
              <span>IVA (10%)</span>
              <span>{{ formatPrice(taxAmount) }}</span>
            </div>
            
            <!-- Loyalty Points Section (solo visible si no hay cupón y hay puntos disponibles) -->
            <div v-if="canUseLoyaltyPoints" class="loyalty-points-section">
              <div class="loyalty-points-info">
                <span>Tienes <strong>{{ availableLoyaltyPoints }}</strong> puntos disponibles ({{ loyaltyPointsToEuros }}€)</span>
              </div>
              
              <div class="loyalty-slider">
                <label for="pointsSlider">¿Cuántos puntos quieres utilizar?</label>
                <div class="slider-container">
                  <input 
                    type="range" 
                    id="pointsSlider" 
                    v-model="pointsToUse" 
                    :max="maxPointsToUse" 
                    min="0" 
                    step="100"
                    class="points-slider"
                  />
                  <span class="points-value">{{ pointsToUse }} puntos ({{ (pointsToUse/100).toFixed(2) }}€)</span>
                </div>
              </div>
              
              <div v-if="pointsToUse > 0" class="subtotal-row loyalty-discount">
                <span>Descuento por puntos ({{ pointsToUse }} puntos)</span>
                <span>-{{ formatPrice(loyaltyDiscount) }}</span>
              </div>
            </div>
            
            <!-- Mensaje informativo cuando hay cupón activo -->
            <div v-if="hasClientCoupon && availableLoyaltyPoints >= 100" class="points-info-message">
              <i class="pi pi-info-circle"></i>
              No puedes usar puntos de fidelidad mientras tienes un cupón activo.
            </div>
            
            <!-- Descuento por cupón (si existe) -->
            <div v-if="hasClientCoupon" class="subtotal-row coupon-discount">
              <span>Cupón de descuento (20%)</span>
              <span>-{{ formatPrice(couponDiscount) }}</span>
            </div>
          </div>
        </div>

        <!-- Total y botón de pago -->
        <div class="ticket-footer">
          <div class="total-section">
            <h3>Total</h3>
            <span class="total-amount">{{ formatPrice(finalAmount) }}</span>
          </div>
          
          <div class="payment-actions">
            <button class="btn-cancel" @click="goBack">
              <i class="pi pi-arrow-left"></i>
              Volver
            </button>
            <button class="btn-pay" @click="handlePayment" :disabled="isProcessing">
              <i class="pi pi-credit-card"></i>
              {{ isProcessing ? 'Procesando...' : 'Realizar Pago' }}
            </button>
          </div>
        </div>
        <div v-if="hasClientCoupon" class="coupon-notification">
          <i class="pi pi-ticket"></i>
          ¡Cupón de 20% aplicado a tu compra!
        </div>
        <div class="ticket-footer-decoration">
          <div v-for="n in 50" :key="n" class="deco-circle"></div>
        </div>
      </div>
      
      <div class="ticket-shadow"></div>
    </div>
    
    <!-- Modal para confirmación -->
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
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useRouter, useRoute } from 'vue-router';
import OrderService from '../services/client/OrderService';
import useOrders from '../composables/useOrders';
import Modal from '../components/Modal.vue';
import axios from 'axios';
const store = useStore();
const router = useRouter();
const getCurrentRoute = () => {
  return router.currentRoute.value;
};

// Estados
const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');
const isProcessing = ref(false);

// Datos de la orden
const ticketData = ref(null);
const orderData = ref(null);

// Obtener token de autenticación
const token = computed(() => store.getters['storeAuth/getToken']);
const userData = computed(() => store.getters['storeAuth/getUserData']);
const hasClientCoupon = computed(() => userData.value?.client?.has_coupon || false);
const availableLoyaltyPoints = computed(() => userData.value?.client?.loyalty_points || 0);
const loyaltyPointsToEuros = computed(() => Math.floor(availableLoyaltyPoints.value / 100));
const pointsToUse = ref(0); // Por defecto no usar puntos
const canUseLoyaltyPoints = computed(() => !hasClientCoupon.value && availableLoyaltyPoints.value >= 100);
const route = useRoute();

// Llamada al composable
const { makePayment } = useOrders();

const maxPointsToUse = computed(() => {
  if (!canUseLoyaltyPoints.value) return 0;
  
  // Limitar el uso de puntos al subtotal (no se pueden usar más puntos que el valor del pedido)
  const maxEurosDiscount = subtotalAmount.value;
  const maxPointsValue = Math.floor(maxEurosDiscount * 100);
  return Math.min(availableLoyaltyPoints.value, maxPointsValue);
});

const loyaltyDiscount = computed(() => {
  if (!canUseLoyaltyPoints.value) return 0;
  return pointsToUse.value / 100;
});

const subtotalAmount = computed(() => {
  if (!orderData.value?.orderProducts) return 0;
  return orderData.value.orderProducts.reduce((total, product) => {
    return total + (product.unitPrice * product.quantity);
  }, 0);
});

const taxAmount = computed(() => {
  return subtotalAmount.value * 0.1; // 10% IVA
});

// Descuento por cupón (20%)
const couponDiscount = computed(() => {
  if (!hasClientCoupon.value) return 0;
  return subtotalAmount.value * 0.2;
});

// Monto con IVA
const totalWithTax = computed(() => {
  return subtotalAmount.value;
});

// Monto final a pagar (aplicando todos los descuentos)
const finalAmount = computed(() => {
  // Si hay cupón, aplicamos descuento del 20%
  if (hasClientCoupon.value) {
    return totalWithTax.value - couponDiscount.value;
  }
  
  // Si no hay cupón, podemos usar puntos de lealtad
  return totalWithTax.value - loyaltyDiscount.value;
});
// Formatear precio
const formatPrice = (value) => {
  return new Intl.NumberFormat('es-ES', {
    style: 'currency',
    currency: 'EUR',
    minimumFractionDigits: 2
  }).format(value);
};

// Cargar datos iniciales
onMounted(async () => {
  await fetchOrderData();
});

const fetchOrderData = async () => {
  try {
    const order = store.getters['storeOrders/getOrderData'];
    const ticket = store.getters['storeOrders/getTicketData'];
    
    // Si no hay datos en el store, redireccionar
    if (!order || !ticket) {
      router.push('/');
      return;
    }
    
    ticketData.value = ticket;
    orderData.value = order;
  } catch (error) {
    console.error("Error al cargar datos de la orden:", error);
    modalTitle.value = 'Error';
    modalMessage.value = 'No se pudieron cargar los datos de su pedido. Por favor, inténtelo de nuevo.';
    isModalVisible.value = true;
  }
};

// Modificar el método handlePayment

const handlePayment = async () => {
  if (isProcessing.value) return;
  
  isProcessing.value = true;
  
  try {
    // Llamar a la API de Stripe para iniciar el pago
    const response = await fetch('http://localhost:3002/api/payment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        orderId: orderData.value.orderId,
        totalAmount: finalAmount.value,
        couponApplied: hasClientCoupon.value ? true : false,
        pointsUsed: canUseLoyaltyPoints.value ? pointsToUse.value : 0,
        originalAmount: subtotalAmount.value // Para calcular nuevos puntos ganados
      })
    });

    const data = await response.json();

    if (data.clientSecret) {
      // Redireccionar a la página de pago de Stripe con el clientSecret
      router.push({
        name: 'StripePaymentPage',
        query: { 
          clientSecret: data.clientSecret,
          orderId: orderData.value.orderId,
          bookingId: orderData.value.bookingId || orderData.value.booking?.bookingId,
          couponApplied: hasClientCoupon.value ? "true" : "false",
          pointsUsed: canUseLoyaltyPoints.value ? pointsToUse.value.toString() : "0"
        }
      });
    } else {
      throw new Error("No se recibió la información necesaria para el pago");
    }
  } catch (error) {
    console.error("Error al iniciar el pago:", error);
    modalTitle.value = 'Error en el Pago';
    modalMessage.value = 'Lo sentimos, ha ocurrido un error al procesar su pago. Por favor, inténtelo de nuevo más tarde.';
    isModalVisible.value = true;
  } finally {
    isProcessing.value = false;
  }
};
// Función a añadir para actualizar los puntos de fidelidad

const updateClientLoyaltyPoints = async (pointsUsed, amountPaid) => {
  try {
    const token = store.getters['storeAuth/getToken'];
    const userData = store.getters['storeAuth/getUserData'];
    
    // Calcular puntos actuales
    let currentPoints = userData.client.loyalty_points || 0;
    
    // Restar puntos usados
    currentPoints -= parseInt(pointsUsed);
    
    // Añadir nuevos puntos (100 puntos por cada 100€)
    const newPoints = Math.floor(amountPaid);  // 1€ = 1 punto
    currentPoints += newPoints * 100;  // 100 puntos por cada euro
    
    // Actualizar en el backend
    const response = await axios.put(
      'http://localhost:8090/spring/api/client',
      { loyalty_points: currentPoints },
      {
        headers: {
          'Authorization': `Bearer ${token}`,
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
      if (pointsUsed > 0) {
        message += ` Has utilizado ${pointsUsed} puntos en este pago.`;
      }
      
      store.dispatch('storeNotifications/pushNotification', {
        type: 'success',
        message: message.trim()
      });
    }
  } catch (error) {
    console.error('Error al actualizar puntos de fidelidad:', error);
  }
};

const goBack = () => {
  router.go(-1);
};

const goToHome = () => {
  router.push('/');
};

const goToProfile = () => {
  router.push('/profile');
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
  position: relative;
  font-family: 'Lora', serif;
}

.background-decoration {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 200px;
  background: linear-gradient(to bottom, rgba(139, 69, 19, 0.1), transparent);
  z-index: 0;
}

.ticket-container {
  position: relative;
  z-index: 1;
  perspective: 1000px;
  margin-top: 30px;
}

.ticket-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 15px 35px rgba(50, 50, 93, 0.1), 0 5px 15px rgba(0, 0, 0, 0.07);
  width: 100%;
  max-width: 450px;
  position: relative;
  overflow: hidden;
  transform-style: preserve-3d;
  transform: rotateX(5deg);
  transition: transform 0.3s ease;
}

.ticket-card:hover {
  transform: rotateX(0deg);
}

.ticket-shadow {
  position: absolute;
  width: 90%;
  height: 20px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.1);
  bottom: -20px;
  left: 5%;
  filter: blur(10px);
  z-index: -1;
}

.ticket-header {
  position: relative;
  text-align: center;
  padding: 25px 20px;
  background: linear-gradient(135deg, #8B4513, #d4b48f);
  color: white;
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

.ticket-header h2 {
  margin: 0;
  font-family: 'Playfair Display', serif;
  font-size: 26px;
  font-weight: 600;
  letter-spacing: 1px;
}

.booking-ref {
  font-size: 14px;
  opacity: 0.8;
  margin: 5px 0 0;
}

.ticket-body {
  padding: 20px;
}

.product-list {
  margin-bottom: 20px;
}

.product-item {
  display: flex;
  justify-content: space-between;
  padding: 10px 0;
  border-bottom: 1px dashed #e8d9c5;
}

.product-item:last-child {
  border-bottom: none;
}

.product-info {
  display: flex;
  flex-direction: column;
}

.product-name {
  font-weight: 500;
  color: #4a3933;
}

.product-quantity {
  font-size: 14px;
  color: #8a7968;
  margin-top: 3px;
}

.product-price {
  font-weight: 600;
  color: #6b4423;
}

.separator {
  height: 1px;
  background: linear-gradient(to right, transparent, #e8d9c5, transparent);
  margin: 15px 0;
}

.subtotal-section {
  padding: 10px 0;
}

.subtotal-row {
  display: flex;
  justify-content: space-between;
  padding: 5px 0;
  font-size: 14px;
  color: #8a7968;
}

.ticket-footer {
  padding: 20px;
  background-color: #f8f5ef;
  border-top: 1px solid #e8d9c5;
}

.total-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.total-section h3 {
  margin: 0;
  font-family: 'Playfair Display', serif;
  color: #4a3933;
  font-size: 18px;
}

.total-amount {
  font-family: 'Playfair Display', serif;
  font-size: 24px;
  font-weight: 700;
  color: #8B4513;
}

.payment-actions {
  display: flex;
  gap: 15px;
}

.btn-cancel, .btn-pay {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 20px;
  border-radius: 6px;
  border: none;
  font-family: 'Lora', serif;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-cancel {
  background-color: white;
  color: #8a7968;
  border: 1px solid #e8d9c5;
  flex: 1;
}

.btn-pay {
  background: linear-gradient(135deg, #8B4513, #d4b48f);
  color: white;
  box-shadow: 0 4px 10px rgba(139, 69, 19, 0.3);
  flex: 2;
}

.btn-cancel:hover {
  background-color: #f9f6f2;
  color: #6b4423;
}

.btn-pay:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 15px rgba(139, 69, 19, 0.4);
}

.btn-pay:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.btn-cancel i, .btn-pay i {
  margin-right: 8px;
}

.ticket-footer-decoration {
  height: 20px;
  overflow: hidden;
  display: flex;
  position: relative;
}

.deco-circle {
  width: 10px;
  height: 20px;
  background-color: #f8f5ef;
  border-radius: 0 0 50% 50%;
  margin: 0 -1px;
  flex: 1;
}
.coupon-discount {
  color: #4CAF50 !important;
  font-weight: 600;
  background-color: rgba(76, 175, 80, 0.05);
  padding: 8px;
  border-radius: 5px;
  margin-top: 5px;
}

.coupon-notification {
  margin: 0;
  padding: 12px 20px;
  background-color: #E8F5E9;
  border-top: 1px dashed #A5D6A7;
  color: #2E7D32;
  font-size: 15px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.coupon-notification i {
  font-size: 18px;
  color: #4CAF50;
}
.loyalty-points-section {
  margin: 15px 0;
  padding: 12px;
  background-color: #FFF8E1;
  border-radius: 8px;
  border: 1px dashed #FFD54F;
}

.loyalty-points-info {
  margin-bottom: 10px;
  font-size: 14px;
  color: #795548;
}

.loyalty-slider {
  margin: 12px 0;
}

.loyalty-slider label {
  display: block;
  margin-bottom: 8px;
  font-size: 13px;
  color: #795548;
  font-weight: 500;
}

.slider-container {
  display: flex;
  align-items: center;
  gap: 10px;
}

.points-slider {
  flex: 1;
  -webkit-appearance: none;
  height: 8px;
  border-radius: 4px;
  background: #FFE0B2;
  outline: none;
}

.points-slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #FB8C00;
  cursor: pointer;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.points-slider::-moz-range-thumb {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: #FB8C00;
  cursor: pointer;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.points-value {
  min-width: 120px;
  font-size: 14px;
  font-weight: 600;
  color: #795548;
}

.loyalty-discount {
  color: #FB8C00 !important;
  font-weight: 600;
  background-color: rgba(251, 140, 0, 0.05);
  padding: 8px;
  border-radius: 5px;
  margin-top: 5px;
}

.points-info-message {
  margin: 10px 0;
  padding: 8px 12px;
  background-color: #E3F2FD;
  border-radius: 6px;
  color: #1565C0;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.points-info-message i {
  font-size: 16px;
}
@media (max-width: 768px) {
  .ticket-card {
    max-width: 100%;
    margin: 0 auto;
  }

  .ticket-header {
    padding: 20px 15px;
  }

  .ticket-header h2 {
    font-size: 22px;
  }

  .total-amount {
    font-size: 20px;
  }

  .payment-actions {
    flex-direction: column;
  }

  .btn-cancel, .btn-pay {
    width: 100%;
  }
}
</style>