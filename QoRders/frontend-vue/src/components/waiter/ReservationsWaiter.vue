<template>
  <div class="reservations-waiter">
    <div class="waiter-dashboard-header">
      <h1 class="dashboard-title">
        Panel de Reservas
        <span v-if="showNotification" class="notification-badge">Nueva actualización</span>
      </h1>
    </div>

    <div v-if="reservations.length > 0" class="reservation-cards-container">
      <div 
        v-for="reservation in reservations" 
        :key="reservation.id" 
        class="reservation-card"
        @click="clearNotification"
      >
        <!-- Cabecera de la reserva con información principal -->
        <div class="card-header">
          <div class="reservation-id">
            <span class="label">Reserva:</span>
            <span class="value">#{{ reservation.id }}</span>
          </div>
          <div class="reservation-status" :class="getReservationStatusClass(reservation.status)">
            {{ translateReservationStatus(reservation.status) }}
          </div>
        </div>
        
        <!-- Cuerpo con datos principales -->
        <div class="card-body">
          <div class="info-grid">
            <div class="info-item">
              <i class="pi pi-users"></i>
              <span>{{ reservation.guestCount }} comensales</span>
            </div>
            <div class="info-item" :class="{ 'today-date': isToday(reservation.date) }">
              <i class="pi pi-calendar"></i>
              <span>{{ formatDate(reservation.date) }}</span>
            </div>
            <div class="info-item">
              <i class="pi pi-user"></i>
              <span>{{ reservation.clientName }}</span>
            </div>
          </div>
          
          <div class="reservation-notes" v-if="reservation.notes">
            <h4>Notas:</h4>
            <p>{{ reservation.notes }}</p>
          </div>
        </div>
        
        <!-- Acciones disponibles según el estado -->
        <div class="card-actions">
          <button v-if="reservation.status === 'Confirmed'" 
                  @click="generateQr(reservation)"
                  class="action-button qr-button">
            <i class="pi pi-qrcode"></i> Generar QR
          </button>
          
          <button v-if="reservation.status === 'InProgress'" 
                  @click="fetchOrders(reservation)"
                  class="action-button orders-button">
            <i class="pi pi-list"></i> Ver Pedidos
          </button>
          
          <button v-if="reservation.status === 'Completed'" 
                  @click="fetchTicket(reservation)"
                  class="action-button ticket-button">
            <i class="pi pi-ticket"></i> Ver Ticket
          </button>
        </div>
        
        <!-- Componente QR -->
        <GenerateQR v-if="reservation.showQr" 
                   :url="reservation.qrUrl" 
                   @close="closeQr(reservation)" />

        <!-- Sección de pedidos -->
        <div v-if="reservation.orders && reservation.orders.length > 0" 
             class="orders-section">
          <div class="section-header">
            <h3>Pedidos</h3>
          </div>
          
          <div v-for="order in reservation.orders" 
               :key="order.id" 
               class="order-item">
            <div class="order-header">
              <div class="order-id">
                <span class="label">Pedido #{{ order.id }}</span>
              </div>
              <div class="order-status" :class="getOrderStatusClass(order.status)">
                {{ translateOrderStatus(order.status) }}
              </div>
            </div>
            
            <div class="order-products">
              <h4>Productos:</h4>
              <DataTable :value="order.products" class="product-table">
                <Column field="name" header="Producto" />
                <Column field="quantity" header="Cantidad" />
              </DataTable>
            </div>
            
            <button class="action-button status-button"
                    :disabled="order.status === 'Delivered'"
                    @click="changeOrderStatus(order)">
              {{ getOrderButtonLabel(order.status) }}
            </button>
          </div>
        </div>
        
        <!-- Sección de ticket -->
        <div v-if="reservation.ticket" class="ticket-section">
          <div class="section-header">
            <h3>Detalle del Ticket</h3>
          </div>
          
          <div class="ticket-summary">
            <div class="summary-item">
              <span class="label">Total:</span>
              <span class="value">{{ reservation.ticket.total_amount }} €</span>
            </div>
            <div class="summary-item">
              <span class="label">Donación:</span>
              <span class="value">{{ reservation.ticket.donated_amount }} €</span>
            </div>
            <div class="summary-item payment-status">
              <span class="label">Estado de pago:</span>
              <span class="value" :class="'payment-' + reservation.ticket.payment_status.toLowerCase()">
                {{ translatePaymentStatus(reservation.ticket.payment_status) }}
              </span>
            </div>
          </div>
          
          <div class="ticket-orders">
            <h4>Pedidos Realizados</h4>
            <div v-for="order in reservation.ticketOrders" 
                 :key="order.order_id" 
                 class="ticket-order-item">
              <div class="order-header">
                <span class="order-id">Orden #{{ order.order_id }}</span>
                <span class="order-total">Total: {{ order.total_amount }} €</span>
              </div>
              
              <DataTable :value="order.products" class="product-table">
                <Column field="product_name" header="Producto" />
                <Column field="product_quantity" header="Cantidad" />
                <Column field="unit_price" header="Precio" />
                <Column field="subtotal" header="Subtotal" />
              </DataTable>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <div v-else class="empty-state">
      <i class="pi pi-calendar-times"></i>
      <p>No hay reservas asignadas en este momento.</p>
    </div>
  </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import GenerateQR from "./GenerateQR.vue";

export default {
  components: { GenerateQR },
  data() {
    return {
      showQr: false,
      qrUrl: null,
      showNotification: false,
      previousStatusMap: {},
      previousOrderProductsMap: {}
    };
  },
  computed: {
    ...mapState("storeWaiter", ["reservations"]),
  },
  methods: {
    ...mapActions("storeWaiter", [
      "fetchGenerateQr",
      "fetchReservations",
      "fetchOrders",
      "fetchTicketFromStore",
      "changeOrderStatus"
    ]),
    // Traducción de estados de reserva
    translateReservationStatus(status) {
      const translations = {
        'Pending': 'Pendiente',
        'Confirmed': 'Confirmada',
        'InProgress': 'En Progreso',
        'Completed': 'Completada'
      };
      return translations[status] || status;
    },
    // Traducción de estados de orden
    translateOrderStatus(status) {
      const translations = {
        'Waiting': 'En Espera',
        'Assigned': 'Asignada',
        'Delivered': 'Entregada'
      };
      return translations[status] || status;
    },
    // Traducción de estados de pago
    translatePaymentStatus(status) {
      const translations = {
        'Pending': 'Pendiente',
        'Paid': 'Pagado',
        'Failed': 'Fallido'
      };
      return translations[status] || status;
    },
    // Clases para los estados de reserva
    getReservationStatusClass(status) {
      return {
        'status-pending': status === 'Pending',
        'status-confirmed': status === 'Confirmed',
        'status-inprogress': status === 'InProgress',
        'status-completed': status === 'Completed'
      };
    },
    formatDate(dateString) {
      if (!dateString) return '';
      const [year, month, day] = dateString.split('-');
      return `${day}/${month}/${year}`;
    },
    isToday(dateString) {
      if (!dateString) return false;
      const today = new Date();
      const [year, month, day] = dateString.split('-');
      
      return parseInt(year) === today.getFullYear() &&
             parseInt(month) === today.getMonth() + 1 &&
             parseInt(day) === today.getDate();
    },
    // Clases para los estados de orden
    getOrderStatusClass(status) {
      return {
        'status-waiting': status === 'Waiting',
        'status-assigned': status === 'Assigned',
        'status-delivered': status === 'Delivered'
      };
    },
    async generateQr(reservation) {
      try {
        await this.fetchGenerateQr(reservation.id);
        reservation.qrUrl = this.$store.getters["storeWaiter/getQrUrl"];
        reservation.showQr = true;
      } catch (error) {
        console.error("Error al generar el QR:", error);
      }
    },
    async fetchOrders(reservation) {
      try {
        const response = await this.$store.dispatch("storeWaiter/fetchOrders", reservation.id);
        reservation.orders = response;
      } catch (error) {
        console.error("Error al obtener las órdenes:", error);
      }
    },
    closeQr(reservation) {
      reservation.showQr = false;
      reservation.qrUrl = null;
    },
    async changeOrderStatus(order) {
      try {
        const endpoint =
          order.status === "Waiting"
            ? `/auth/waiter/orders/${order.id}/assign`
            : `/auth/waiter/orders/${order.id}/deliver`;
        const response = await this.$store.dispatch("storeWaiter/changeOrderStatus", {
          endpoint,
          orderId: order.id,
        });
        const updatedStatus = response.data?.order_status || response.order_status;
        order.status = updatedStatus;
      } catch (error) {
        console.error("Error al cambiar el estado de la orden:", error);
      }
    },
    getOrderButtonLabel(status) {
      if (status === "Waiting") return "Asignar";
      if (status === "Assigned") return "Entregar";
      return "Finalizado";
    },
    async fetchTicket(reservation) {
      try {
        const response = await this.fetchTicketFromStore(reservation.id);
        reservation.ticket = response.ticket;
        reservation.ticketOrders = response.orders;
      } catch (error) {
        console.error("Error al obtener el ticket:", error);
      }
    },
    // Actualiza el mapa de estados a partir de la lista actual
    updateStatusMap() {
      const map = {};
      this.reservations.forEach(reservation => {
        map[reservation.id] = reservation.status;
      });
      this.previousStatusMap = map;
    },
    updateOrderProductsMap() {
      const map = {};
      this.reservations.forEach(reservation => {
        if (reservation.orders && reservation.orders.length > 0) {
          reservation.orders.forEach(order => {
            // Usamos JSON.stringify para obtener una representación de los productos
            map[order.id] = JSON.stringify(order.products);
          });
        }
      });
      this.previousOrderProductsMap = map;
    },
    // Compara los estados actuales con los previos
    checkForStatusChanges() {
      let changed = false;
      this.reservations.forEach(reservation => {
        const previousStatus = this.previousStatusMap[reservation.id];
        if (!previousStatus || reservation.status !== previousStatus) {
          changed = true;
        }
      });
      return changed;
    },
    pollReservations() {
      this.fetchReservations().then(() => {
        let changed = false;
        
        // Compara el estado de cada reserva
        this.reservations.forEach(reservation => {
          const prevStatus = this.previousStatusMap[reservation.id];
          if (!prevStatus || reservation.status !== prevStatus) {
            changed = true;
            console.log(`Cambio en estado de reserva ${reservation.id}: ${prevStatus} -> ${reservation.status}`);
          }
          
          // Compara los productos de cada orden
          if (reservation.orders && reservation.orders.length > 0) {
            reservation.orders.forEach(order => {
              const currentProducts = JSON.stringify(order.products);
              const previousProducts = this.previousOrderProductsMap[order.id] || "";
              if (currentProducts !== previousProducts) {
                changed = true;
                console.log(`Cambio en productos de la orden ${order.id}:`);
                console.log("Anterior:", previousProducts);
                console.log("Actual:  ", currentProducts);
              }
            });
          }
        });
        
        // Si el número de reservas cambia, también se considera cambio
        if (Object.keys(this.previousStatusMap).length !== this.reservations.length) {
          changed = true;
          console.log("Cambio en la cantidad de reservas");
        }
        
        if (changed) {
          this.showNotification = true;
        }
        
        // Actualiza ambos mapas para la próxima comparación
        this.updateStatusMap();
        this.updateOrderProductsMap();
      }).catch(error => {
        console.error("Error en el polling de reservas:", error);
      });
    },
    startPolling() {
      // Inicializa ambos mapas
      this.updateStatusMap();
      this.updateOrderProductsMap();
      setInterval(() => {
        this.pollReservations();
      }, 30000);
    },
    clearNotification() {
      this.showNotification = false;
    },
  },
  mounted() {
    this.fetchReservations().then(() => {
      // Inicializamos los mapas con los datos actuales
      this.updateStatusMap();
      this.updateOrderProductsMap();
      this.startPolling();
    }).catch(error => {
      console.error("Error al cargar las reservas:", error);
    });
  }
};
</script>

<style scoped>
/* Estilos base */
.reservations-waiter {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f5f7fa;
  padding: 2rem;
  color: #2c3e50;
}

.waiter-dashboard-header {
  margin-bottom: 2rem;
  background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.dashboard-title {
  margin: 0;
  color: white;
  font-size: 1.6rem;
  font-weight: 500;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.notification-badge {
  background-color: #e74c3c;
  color: white;
  font-size: 0.8rem;
  padding: 0.3rem 0.7rem;
  border-radius: 20px;
  font-weight: normal;
  animation: pulse 1.5s infinite;
}

@keyframes pulse {
  0% { opacity: 1; }
  50% { opacity: 0.7; }
  100% { opacity: 1; }
}

/* Contenedor de tarjetas */
.reservation-cards-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
  gap: 1.5rem;
}

/* Tarjeta de reserva */
.reservation-card {
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  display: flex;
  flex-direction: column;
}

.reservation-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

/* Cabecera de tarjeta */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e9ecef;
  background-color: #f8f9fa;
}

.reservation-id {
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.reservation-id .label {
  color: #6c757d;
  font-size: 0.9rem;
}

.reservation-id .value {
  font-size: 1.2rem;
  color: #343a40;
}

.reservation-status {
  font-size: 0.85rem;
  padding: 0.35rem 0.8rem;
  border-radius: 15px;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Estados de reserva */
.status-pending {
  background-color: #fff3cd;
  color: #856404;
}

.status-confirmed {
  background-color: #d1ecf1;
  color: #0c5460;
}

.status-inprogress {
  background-color: #cce5ff;
  color: #004085;
}

.status-completed {
  background-color: #d4edda;
  color: #155724;
}

/* Estados de orden */
.status-waiting {
  background-color: #f8d7da;
  color: #721c24;
}

.status-assigned {
  background-color: #e2d9f3;
  color: #5a3b94;
}

.status-delivered {
  background-color: #d1f2eb;
  color: #0e7c61;
}

/* Estados de pago */
.payment-pending {
  color: #856404;
}

.payment-paid {
  color: #155724;
}

.payment-failed {
  color: #721c24;
}

/* Cuerpo de la tarjeta */
.card-body {
  padding: 1.5rem;
  flex: 1;
}

.info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.info-item i {
  color: #3498db;
  font-size: 1.1rem;
}

.reservation-notes {
  background-color: #f8f9fa;
  padding: 1rem;
  border-radius: 6px;
  margin-top: 1rem;
  border-left: 3px solid #6c757d;
}

.reservation-notes h4 {
  margin: 0 0 0.5rem;
  font-size: 1rem;
  font-weight: 600;
  color: #495057;
}
.today-date {
  background-color: #fffacd;
  border-radius: 4px;
  padding: 0.3rem 0.5rem !important;
  border-left: 3px solid #ffd700;
  font-weight: bold;
}

.today-date i, .today-date span {
  color: #d4af37 !important;
}
.reservation-notes p {
  margin: 0;
  color: #6c757d;
  font-size: 0.95rem;
  line-height: 1.5;
}

/* Acciones de la tarjeta */
.card-actions {
  padding: 1rem 1.5rem;
  border-top: 1px solid #e9ecef;
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
  background-color: #f8f9fa;
}

.action-button {
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 4px;
  font-weight: 500;
  font-size: 0.9rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.2s ease;
}

.action-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.action-button i {
  font-size: 1rem;
}

.qr-button {
  background-color: #28a745;
  color: white;
}

.qr-button:hover {
  background-color: #218838;
}

.orders-button {
  background-color: #007bff;
  color: white;
}

.orders-button:hover {
  background-color: #0069d9;
}

.ticket-button {
  background-color: #6c757d;
  color: white;
}

.ticket-button:hover {
  background-color: #5a6268;
}

.status-button {
  background-color: #ffc107;
  color: #212529;
  margin-top: 1rem;
}

.status-button:hover:not(:disabled) {
  background-color: #e0a800;
}

/* Sección de pedidos */
.orders-section, .ticket-section {
  margin-top: 1.5rem;
  border-top: 1px solid #e9ecef;
  padding: 1.5rem;
}

.section-header {
  margin-bottom: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-header h3 {
  margin: 0;
  font-size: 1.2rem;
  font-weight: 600;
  color: #343a40;
}

.order-item {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.25rem;
  margin-bottom: 1rem;
  border-left: 4px solid #dee2e6;
}

.order-item:last-child {
  margin-bottom: 0;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.order-id {
  font-weight: 600;
  color: #495057;
}

.order-status {
  font-size: 0.8rem;
  padding: 0.25rem 0.6rem;
  border-radius: 12px;
}

.order-products h4 {
  margin: 0 0 0.75rem;
  font-size: 1rem;
  font-weight: 500;
  color: #495057;
}

/* Sección de tickets */
.ticket-summary {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.25rem;
  margin-bottom: 1.5rem;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.75rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid #e9ecef;
}

.summary-item:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
}

.summary-item .label {
  font-weight: 500;
  color: #495057;
}

.summary-item .value {
  font-weight: 600;
}

.ticket-orders h4 {
  margin: 1.5rem 0 1rem;
  font-size: 1.1rem;
  font-weight: 600;
  color: #343a40;
}

.ticket-order-item {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.25rem;
  margin-bottom: 1rem;
}

.ticket-order-item:last-child {
  margin-bottom: 0;
}

.ticket-order-item .order-header {
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #e9ecef;
  padding-bottom: 0.75rem;
  margin-bottom: 1rem;
}

.order-total {
  font-weight: 600;
  color: #343a40;
}

/* Tablas */
.product-table {
  margin-top: 0.75rem;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

/* Estado vacío */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
  text-align: center;
}

.empty-state i {
  font-size: 3rem;
  color: #adb5bd;
  margin-bottom: 1.5rem;
}

.empty-state p {
  font-size: 1.2rem;
  color: #6c757d;
  margin: 0;
}

/* Responsivo */
@media (max-width: 768px) {
  .reservations-waiter {
    padding: 1rem;
  }
  
  .waiter-dashboard-header {
    padding: 1rem;
  }
  
  .dashboard-title {
    font-size: 1.3rem;
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  
  .reservation-cards-container {
    grid-template-columns: 1fr;
  }
  
  .info-grid {
    grid-template-columns: 1fr 1fr;
  }
  
  .card-actions {
    flex-direction: column;
  }
  
  .action-button {
    width: 100%;
    justify-content: center;
  }
}
</style>