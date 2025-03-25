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
        
        <!-- Cuerpo con datos principales rediseñado -->
        <div class="card-body">
          <!-- Destacar la fecha si es hoy -->
          <div class="date-highlight" :class="{ 'today': isToday(reservation.date) }">
            <div class="date-content">
              <i class="pi pi-calendar"></i>
              <div class="date-info">
                <span class="date-label">{{ isToday(reservation.date) ? 'HOY' : 'Fecha' }}</span>
                <span class="date-value">{{ formatDate(reservation.date) }}</span>
              </div>
            </div>
            <div v-if="isToday(reservation.date)" class="today-indicator">Atender hoy</div>
          </div>

          <!-- Info del cliente simplificada -->
          <div class="client-info">
            <div class="info-card guests">
              <i class="pi pi-users"></i>
              <div>
                <span class="info-label">Comensales</span>
                <span class="info-value">{{ reservation.guestCount }}</span>
              </div>
            </div>
            
            <div class="info-card client">
              <i class="pi pi-user"></i>
              <div>
                <span class="info-label">Cliente</span>
                <span class="info-value">{{ reservation.clientName }}</span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Acciones disponibles según el estado -->
        <div class="card-actions">
          <button v-if="reservation.status === 'Confirmed'" 
                  @click.stop="generateQr(reservation)"
                  class="action-button qr-button">
            <i class="pi pi-qrcode"></i> Generar QR
          </button>
          
          <button v-if="reservation.status === 'InProgress'" 
                  @click.stop="fetchOrders(reservation)"
                  class="action-button orders-button">
            <i class="pi pi-list"></i> Ver Pedidos
          </button>
          
          <button v-if="reservation.status === 'Completed'" 
                  @click.stop="fetchTicket(reservation)"
                  class="action-button ticket-button">
            <i class="pi pi-ticket"></i> Ver Ticket
          </button>
        </div>
        
        <!-- Componente QR -->
        <GenerateQR v-if="reservation.showQr" 
                   :url="reservation.qrUrl" 
                   @close="closeQr(reservation)" />

        <!-- Sección de pedidos mejorada -->
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
            
            <!-- Lista de productos mejorada -->
            <div class="order-products">
                <h4>Productos a servir:</h4>
                
                <div class="products-list">
                  <div v-for="(product, idx) in order.products" 
                       :key="idx" 
                       class="product-item" 
                       :class="{ 'delivered': isProductDelivered(order.id, product.id) }">
                    
                    <div class="product-info">
                      <div class="product-primary">
                        <span class="product-name">{{ product.name }}</span>
                        <div class="product-badges">
                          <span v-if="isProductDelivered(order.id, product.id)" class="delivery-badge">Entregado</span>
                          <span v-if="product.isNew" class="new-badge">Nuevo</span>
                        </div>
                      </div>
                      
                      <div class="product-quantity">
                        <span class="quantity-label">Cantidad:</span>
                        <span class="quantity-value">{{ product.quantity }}</span>
                      </div>
                    </div>
                    
                    <div class="product-actions">
                      <button 
                        v-if="!isProductDelivered(order.id, product.id) && order.status !== 'Waiting'"
                        @click.stop="markProductAsDelivered(order.id, product.id)"
                        class="deliver-item-btn">
                        <i class="pi pi-check"></i> Entregar
                      </button>
                      <button 
                        v-if="isProductDelivered(order.id, product.id)"
                        @click.stop="unmarkProductAsDelivered(order.id, product.id)"
                        class="undeliver-item-btn">
                        <i class="pi pi-undo"></i> Deshacer
                      </button>
                    </div>
                  </div>
                </div>
            </div>
            
            <button class="action-button status-button"
                    :disabled="order.status === 'Delivered'"
                    @click.stop="changeOrderStatus(order)">
              {{ getOrderButtonLabel(order.status) }}
            </button>
          </div>
        </div>
        
        <!-- Sección de ticket mejorada -->
        <div v-if="reservation.ticket" class="ticket-section">
          <div class="section-header">
            <h3>Detalle del Ticket</h3>
          </div>
          
          <div class="ticket-summary">
            <div class="summary-item">
              <span class="label">Total:</span>
              <span class="value">{{ reservation.ticket.total_amount }} €</span>
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
              
              <!-- Listado de productos del ticket mejorado -->
              <div class="ticket-products-list">
                <div v-for="(product, idx) in order.products" 
                     :key="idx"
                     class="ticket-product-item">
                  <div class="ticket-product-info">
                    <div class="ticket-product-name">
                      {{ product.product_name }}
                      <span class="ticket-product-quantity">× {{ product.product_quantity }}</span>
                    </div>
                    <div class="ticket-product-price">
                      <span class="unit-price">{{ product.unit_price }} €/u</span>
                    </div>
                  </div>
                  <div class="ticket-product-subtotal">
                    {{ product.subtotal }} €
                  </div>
                </div>
                
                <div class="ticket-totals">
                  <span class="ticket-total-label">Total</span>
                  <span class="ticket-total-value">{{ order.total_amount }} €</span>
                </div>
              </div>
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
      previousOrderProductsMap: {},
      deliveredProducts: {},
      productVersions: {}
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
        'Assigned': 'Asignado',
        'Delivered': 'Entregado'
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
        
        // Antes de reemplazar los productos, guardamos los actuales para comparación
        const oldOrders = reservation.orders || [];
        
        // Asignamos los nuevos órdenes
        reservation.orders = response;
        
        // Procesamos cada orden para detectar productos nuevos
        if (reservation.orders && reservation.orders.length > 0) {
          reservation.orders.forEach(order => {
            // Verificar si ya existía esta orden antes
            const oldOrder = oldOrders.find(o => o.id === order.id);
            const oldProducts = oldOrder ? oldOrder.products || [] : [];
            
            // Si no tenemos un registro de versión para esta orden, lo inicializamos
            if (!this.productVersions[order.id]) {
              this.productVersions[order.id] = {};
            }
            
            // Procesar los productos nuevos
            if (order.products && order.products.length > 0) {
              order.products.forEach(product => {
                // Si el producto no existía antes o tiene diferente cantidad, lo consideramos nuevo
                const existingProduct = oldProducts.find(p => p.id === product.id && p.quantity === product.quantity);
                
                // Si no existía o tiene propiedades diferentes, lo marcamos como nuevo
                if (!existingProduct) {
                  product.isNew = true;
                  product.addedAt = new Date().getTime(); // Timestamp de cuándo se añadió
                  
                  // Guardamos la versión de este producto
                  this.productVersions[order.id][product.id] = product.addedAt;
                } else {
                  // Mantenemos los valores anteriores
                  product.isNew = existingProduct.isNew || false;
                  product.addedAt = this.productVersions[order.id][product.id] || new Date().getTime();
                }
                
                // Si el producto ya está marcado como entregado desde el backend
                if (product.delivered) {
                  this.markProductAsDelivered(order.id, product.id, product.addedAt, false);
                }
              });
            }
          });
          
          // Guardamos las versiones de productos
          localStorage.setItem('productVersions', JSON.stringify(this.productVersions));
        }
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
        
        // Si cambiamos a Delivered, marcamos todos los productos como entregados
        if (updatedStatus === "Delivered" && order.products) {
          order.products.forEach(product => {
            const version = this.productVersions[order.id] && 
                           this.productVersions[order.id][product.id] || 
                           product.addedAt || 
                           new Date().getTime();
            
            this.markProductAsDelivered(order.id, product.id, version, false);
            product.isNew = false; // Ya no es nuevo una vez entregado
          });
          this.saveDeliveredProductsToStorage();
        }
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
    
    // NUEVOS MÉTODOS PARA GESTIONAR PRODUCTOS ENTREGADOS
    
    // Marca un producto como entregado
    markProductAsDelivered(orderId, productId, version = null, saveToStorage = true) {
      // Si no se proporciona versión, tomamos la del registro o generamos una nueva
      const productVersion = version || 
                            (this.productVersions[orderId] && this.productVersions[orderId][productId]) || 
                            new Date().getTime();
      
      // Clave compuesta que incluye la versión
      const deliveryKey = `${orderId}_${productId}_${productVersion}`;
      
      if (!this.deliveredProducts[deliveryKey]) {
        this.deliveredProducts[deliveryKey] = true;
        
        // Actualizar el estado isNew del producto
        const reservation = this.reservations.find(r => 
          r.orders && r.orders.some(o => o.id === orderId)
        );
        
        if (reservation) {
          const order = reservation.orders.find(o => o.id === orderId);
          if (order) {
            const product = order.products.find(p => p.id === productId);
            if (product) {
              product.isNew = false; // Ya no es nuevo una vez entregado
            }
          }
        }
        
        if (saveToStorage) {
          this.saveDeliveredProductsToStorage();
        }
      }
    },
    
    // Desmarca un producto como entregado
    unmarkProductAsDelivered(orderId, productId, version = null) {
      // Si no se proporciona versión, usamos la versión guardada
      const productVersion = version || 
                            (this.productVersions[orderId] && this.productVersions[orderId][productId]) || 
                            '';
      
      const deliveryKey = `${orderId}_${productId}_${productVersion}`;
      
      if (this.deliveredProducts[deliveryKey]) {
        delete this.deliveredProducts[deliveryKey];
        this.saveDeliveredProductsToStorage();
      }
    },
    
    // Comprueba si un producto está entregado
    isProductDelivered(orderId, productId) {
      // Obtenemos la versión del producto si existe
      const productVersion = this.productVersions[orderId] && this.productVersions[orderId][productId];
      
      if (!productVersion) return false;
      
      const deliveryKey = `${orderId}_${productId}_${productVersion}`;
      return !!this.deliveredProducts[deliveryKey];
    },
    
     // Guarda el estado en localStorage
    saveDeliveredProductsToStorage() {
      localStorage.setItem('deliveredProducts', JSON.stringify(this.deliveredProducts));
    },
    
    loadDeliveredProductsFromStorage() {
      const storedDelivered = localStorage.getItem('deliveredProducts');
      const storedVersions = localStorage.getItem('productVersions');
      
      if (storedDelivered) {
        this.deliveredProducts = JSON.parse(storedDelivered);
      }
      
      if (storedVersions) {
        this.productVersions = JSON.parse(storedVersions);
      }
    },
  },
  mounted() {
    // Cargar estado de productos entregados
    this.loadDeliveredProductsFromStorage();
    
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
/* Estilos base mejorados */
.reservations-waiter {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f8fafc;
  padding: 2rem;
  color: #2c3e50;
  min-height: calc(100vh - 4rem);
}

.waiter-dashboard-header {
  margin-bottom: 2rem;
  background: linear-gradient(135deg, #1e293b 0%, #0ea5e9 100%);
  border-radius: 12px;
  padding: 1.5rem 2rem;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
}

.waiter-dashboard-header::before {
  content: "";
  position: absolute;
  top: 0;
  right: 0;
  width: 200px;
  height: 100%;
  background-image: url('data:image/svg+xml;utf8,<svg width="200" height="200" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg"><path d="M160 20C180 40 190 80 170 120C150 160 130 180 90 170C50 160 30 130 20 100C10 70 0 40 20 20C40 0 80 0 120 10C160 20 140 0 160 20Z" fill="rgba(255,255,255,0.05)"/></svg>');
  background-repeat: no-repeat;
  background-position: center right;
}

.dashboard-title {
  margin: 0;
  color: white;
  font-size: 1.8rem;
  font-weight: 600;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  position: relative;
  z-index: 1;
}

.notification-badge {
  background-color: #ef4444;
  color: white;
  font-size: 0.8rem;
  padding: 0.4rem 1rem;
  border-radius: 20px;
  font-weight: 500;
  animation: pulse 1.5s infinite;
  box-shadow: 0 4px 10px rgba(239, 68, 68, 0.3);
}

@keyframes pulse {
  0% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.8; transform: scale(1.05); }
  100% { opacity: 1; transform: scale(1); }
}

/* Contenedor de tarjetas mejorado */
.reservation-cards-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
  gap: 2rem;
}

/* Tarjeta de reserva mejorada */
.reservation-card {
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05), 0 1px 5px rgba(0, 0, 0, 0.03);
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
  display: flex;
  flex-direction: column;
  border: 1px solid rgba(0, 0, 0, 0.05);
  position: relative;
}

.reservation-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1), 0 5px 15px rgba(0, 0, 0, 0.05);
}

/* Cabecera de tarjeta mejorada */
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.25rem 1.5rem;
  border-bottom: 1px solid #e9ecef;
  background: linear-gradient(to right, #f8f9fa, #ffffff);
  position: relative;
}

.card-header::after {
  content: "";
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 3px;
  background: linear-gradient(to right, 
    var(--status-color, transparent) 0%, 
    var(--status-color, transparent) 100%);
}

.reservation-card:has(.status-pending) .card-header {
  --status-color: #f59e0b;
}

.reservation-card:has(.status-confirmed) .card-header {
  --status-color: #0ea5e9;
}

.reservation-card:has(.status-inprogress) .card-header {
  --status-color: #8b5cf6;
}

.reservation-card:has(.status-completed) .card-header {
  --status-color: #10b981;
}

.reservation-id {
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.reservation-id .label {
  color: #64748b;
  font-size: 0.9rem;
}

.reservation-id .value {
  font-size: 1.3rem;
  color: #1e293b;
  font-weight: 700;
}

.reservation-status {
  font-size: 0.8rem;
  padding: 0.4rem 1rem;
  border-radius: 20px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  gap: 6px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
}

.reservation-status::before {
  content: "";
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: currentColor;
}

/* Estados de reserva mejorados */
.status-pending {
  background-color: #fff7ed;
  color: #9a3412;
  border: 1px solid #fdba74;
}

.status-confirmed {
  background-color: #ecfeff;
  color: #0e7490;
  border: 1px solid #67e8f9;
}

.status-inprogress {
  background-color: #f5f3ff;
  color: #5b21b6;
  border: 1px solid #c4b5fd;
}

.status-completed {
  background-color: #ecfdf5;
  color: #065f46;
  border: 1px solid #6ee7b7;
}

/* NUEVO DISEÑO DEL CUERPO */
.card-body {
  padding: 1.5rem;
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  border-bottom: 1px solid #f1f5f9;
}

/* Fecha destacada */
.date-highlight {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 1.25rem;
  background-color: #f8fafc;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03);
}

.date-highlight.today {
  background-color: #fffbeb;
  border: 1px solid #fbbf24;
  box-shadow: 0 4px 10px rgba(251, 191, 36, 0.15);
}

.date-content {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.date-highlight i {
  color: #64748b;
  font-size: 1.25rem;
  background-color: rgba(100, 116, 139, 0.1);
  padding: 0.5rem;
  border-radius: 8px;
}

.date-highlight.today i {
  color: #b45309;
  background-color: rgba(180, 83, 9, 0.1);
}

.date-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.date-label {
  font-size: 0.8rem;
  color: #64748b;
  font-weight: 500;
}

.date-highlight.today .date-label {
  color: #b45309;
  font-weight: 600;
}

.date-value {
  font-size: 1.1rem;
  color: #334155;
  font-weight: 600;
}

.date-highlight.today .date-value {
  color: #92400e;
  font-weight: 700;
}

.today-indicator {
  padding: 0.3rem 0.8rem;
  background-color: #fef3c7;
  border-radius: 20px;
  color: #b45309;
  font-size: 0.75rem;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  box-shadow: 0 2px 5px rgba(251, 191, 36, 0.1);
}

.today-indicator::before {
  content: "!";
  width: 18px;
  height: 18px;
  background-color: #b45309;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.7rem;
  font-weight: 700;
}

/* Información del cliente */
.client-info {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1rem;
}

.info-card {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem;
  background-color: #f8fafc;
  border-radius: 10px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.03);
  border: 1px solid #e2e8f0;
  transition: all 0.2s ease;
}

.info-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

.info-card i {
  color: #0ea5e9;
  font-size: 1.25rem;
  background-color: rgba(14, 165, 233, 0.1);
  padding: 0.5rem;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 2.5rem;
}

.info-card div {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
}

.info-label {
  font-size: 0.8rem;
  color: #64748b;
}

.info-value {
  font-size: 1rem;
  color: #334155;
  font-weight: 600;
}

/* Acciones de la tarjeta mejoradas */
.card-actions {
  padding: 1.25rem 1.5rem;
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  background-color: #f8fafc;
}

.action-button {
  padding: 0.75rem 1.25rem;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  font-size: 0.95rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05), 0 1px 3px rgba(0, 0, 0, 0.1);
}

.action-button::after {
  content: '';
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  pointer-events: none;
  background-image: radial-gradient(circle, #fff 10%, transparent 10.01%);
  background-repeat: no-repeat;
  background-position: 50%;
  transform: scale(10, 10);
  opacity: 0;
  transition: transform 0.4s, opacity 0.8s;
}

.action-button:active::after {
  transform: scale(0, 0);
  opacity: 0.3;
  transition: 0s;
}

.action-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
  box-shadow: none;
}

.action-button i {
  font-size: 1.1rem;
}

.qr-button {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
}

.qr-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #059669 0%, #047857 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(16, 185, 129, 0.2);
}

.orders-button {
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
}

.orders-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(59, 130, 246, 0.2);
}

.ticket-button {
  background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
  color: white;
}

.ticket-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(99, 102, 241, 0.2);
}

.status-button {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  color: white;
  margin-top: 1.25rem;
  width: 100%;
  justify-content: center;
}

.status-button:hover:not(:disabled) {
  background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(245, 158, 11, 0.2);
}

/* Secciones de pedidos y tickets mejoradas */
.orders-section, .ticket-section {
  margin-top: 0;
  border-top: 1px solid #e2e8f0;
  padding: 1.5rem;
  background-color: #f1f5f9;
  animation: slideDown 0.3s ease-out forwards;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.section-header {
  margin-bottom: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid #cbd5e1;
}

.section-header h3 {
  margin: 0;
  font-size: 1.3rem;
  font-weight: 700;
  color: #1e293b;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.section-header h3::before {
  font-family: 'PrimeIcons';
  content: "\e9c9"; /* Lista para pedidos */
  color: #3b82f6;
  font-size: 1.4rem;
}

.ticket-section .section-header h3::before {
  content: "\e92c"; /* Ticket para la sección de ticket */
  color: #6366f1;
}

.order-item {
  background-color: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.25rem;
  border-left: 5px solid #94a3b8;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  transition: all 0.2s ease;
}

.order-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.order-item:last-child {
  margin-bottom: 0;
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.25rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid #e2e8f0;
}

.order-id {
  font-weight: 700;
  color: #334155;
  font-size: 1.1rem;
}

.order-id .label {
  color: #64748b;
  font-weight: 600;
}

.order-status {
  font-size: 0.85rem;
  padding: 0.35rem 0.8rem;
  border-radius: 15px;
  font-weight: 600;
  letter-spacing: 0.5px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.order-status::before {
  content: "";
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: currentColor;
  animation: pulse 1.5s infinite;
}

/* Estados de orden mejorados */
.status-waiting {
  background-color: #fef2f2;
  color: #b91c1c;
  border: 1px solid #fca5a5;
}

.status-waiting::before {
  animation: pulse 1.5s infinite;
}

.status-assigned {
  background-color: #ede9fe;
  color: #6d28d9;
  border: 1px solid #c4b5fd;
}

.status-delivered {
  background-color: #d1fae5;
  color: #047857;
  border: 1px solid #6ee7b7;
}

.order-products h4 {
  margin: 0 0 1rem;
  font-size: 1.1rem;
  font-weight: 600;
  color: #334155;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.order-products h4::before {
  content: "🍽️";
  font-size: 1.2rem;
}

/* NUEVO LISTADO DE PRODUCTOS */
.products-list {
  background-color: white;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
}

.product-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  border-bottom: 1px solid #f1f5f9;
  transition: all 0.2s ease;
}

.product-item:last-child {
  border-bottom: none;
}

.product-item:hover {
  background-color: #f8fafc;
}

.product-item.delivered {
  background-color: #f8fafc;
  opacity: 0.85;
}

.product-info {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  flex: 1;
}

.product-primary {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.product-name {
  font-size: 1rem;
  color: #334155;
  font-weight: 600;
}

.product-item.delivered .product-name {
  text-decoration: line-through;
  color: #94a3b8;
}

.product-badges {
  display: flex;
  gap: 0.5rem;
}

.delivery-badge {
  background-color: #d1fae5;
  color: #047857;
  font-size: 0.7rem;
  font-weight: 600;
  padding: 0.2rem 0.5rem;
  border-radius: 12px;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  box-shadow: 0 2px 5px rgba(16, 185, 129, 0.2);
}

.delivery-badge::before {
  content: "✓";
  font-weight: bold;
}

.new-badge {
  background-color: #fef2f2;
  color: #b91c1c;
  font-size: 0.7rem;
  font-weight: 600;
  padding: 0.2rem 0.5rem;
  border-radius: 12px;
  display: inline-flex;
  align-items: center;
  gap: 4px;
  box-shadow: 0 2px 5px rgba(239, 68, 68, 0.2);
  animation: pulse 1.5s infinite;
}

.new-badge::before {
  content: "•";
  font-size: 1.2em;
  line-height: 0;
}

.product-quantity {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.quantity-label {
  font-size: 0.8rem;
  color: #64748b;
}

.quantity-value {
  color: #475569;
  font-weight: 600;
  background-color: #f1f5f9;
  padding: 0.2rem 0.5rem;
  border-radius: 5px;
  font-size: 0.9rem;
}

.product-actions {
  display: flex;
  gap: 0.5rem;
}

.deliver-item-btn, .undeliver-item-btn {
  padding: 0.4rem 0.8rem;
  font-size: 0.8rem;
  border-radius: 6px;
  display: flex;
  align-items: center;
  gap: 0.25rem;
  cursor: pointer;
  transition: all 0.2s ease;
  border: none;
  font-weight: 600;
}

.deliver-item-btn {
  background-color: #ecfdf5;
  color: #047857;
  border: 1px solid #6ee7b7;
}

.deliver-item-btn:hover {
  background-color: #d1fae5;
  box-shadow: 0 2px 5px rgba(16, 185, 129, 0.2);
}

.undeliver-item-btn {
  background-color: #fff7ed;
  color: #9a3412;
  border: 1px solid #fdba74;
}

.undeliver-item-btn:hover {
  background-color: #ffedd5;
  box-shadow: 0 2px 5px rgba(251, 191, 36, 0.2);
}

/* Sección de tickets mejorada */
.ticket-summary {
  background-color: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  border: 1px solid #e2e8f0;
}

.summary-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 1rem;
  padding-bottom: 1rem;
  border-bottom: 1px dashed #cbd5e1;
}

.summary-item:last-child {
  margin-bottom: 0;
  padding-bottom: 0;
  border-bottom: none;
}

.summary-item .label {
  font-weight: 600;
  color: #475569;
  font-size: 1.05rem;
}

.summary-item .value {
  font-weight: 700;
  font-size: 1.15rem;
  color: #1e293b;
}

.summary-item.payment-status .value {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  padding: 0.35rem 0.8rem;
  border-radius: 20px;
}

.payment-pending {
  background-color: #fff7ed;
  color: #9a3412;
  border: 1px solid #fdba74;
}

.payment-paid {
  background-color: #ecfdf5;
  color: #065f46;
  border: 1px solid #6ee7b7;
}

.payment-failed {
  background-color: #fef2f2;
  color: #b91c1c;
  border: 1px solid #fca5a5;
}

.ticket-orders h4 {
  margin: 1.5rem 0 1rem;
  font-size: 1.2rem;
  font-weight: 700;
  color: #1e293b;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.ticket-orders h4::before {
  content: "🧾";
  font-size: 1.3rem;
}

.ticket-order-item {
  background-color: white;
  border-radius: 12px;
  padding: 1.5rem;
  margin-bottom: 1.25rem;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  border: 1px solid #e2e8f0;
  transition: all 0.2s ease;
}

.ticket-order-item:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.ticket-order-item:last-child {
  margin-bottom: 0;
}

.ticket-order-item .order-header {
  border-bottom: 2px solid #e2e8f0;
  padding-bottom: 1rem;
  margin-bottom: 1.25rem;
}

.order-total {
  font-weight: 700;
  color: #1e293b;
  font-size: 1.1rem;
  background-color: #f1f5f9;
  padding: 0.4rem 0.8rem;
  border-radius: 8px;
}

/* NUEVO LISTADO DE PRODUCTOS DEL TICKET */
.ticket-products-list {
  background-color: white;
  border-radius: 10px;
  border: 1px solid #e2e8f0;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
}

.ticket-product-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  border-bottom: 1px solid #f1f5f9;
}

.ticket-product-item:last-of-type {
  border-bottom: 1px dashed #cbd5e1;
}

.ticket-product-info {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.ticket-product-name {
  font-size: 1rem;
  color: #334155;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.ticket-product-quantity {
  font-size: 0.85rem;
  color: #64748b;
  font-weight: 500;
}

.ticket-product-price {
  font-size: 0.85rem;
  color: #64748b;
}

.ticket-product-subtotal {
  font-weight: 700;
  color: #334155;
  font-size: 1.05rem;
}

.ticket-totals {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.25rem;
  background-color: #f8fafc;
  border-top: 1px dashed #cbd5e1;
}

.ticket-total-label {
  font-size: 1.1rem;
  font-weight: 700;
  color: #334155;
}

.ticket-total-value {
  font-size: 1.2rem;
  font-weight: 800;
  color: #1e293b;
}

/* Estado vacío mejorado */
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 5rem 2rem;
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
  text-align: center;
}

.empty-state i {
  font-size: 3.5rem;
  color: #94a3b8;
  margin-bottom: 2rem;
  background-color: #f1f5f9;
  padding: 1.5rem;
  border-radius: 50%;
}

.empty-state p {
  font-size: 1.3rem;
  color: #475569;
  margin: 0;
  font-weight: 500;
}

/* Componente QR mejorado */
:deep(.qr-container) {
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  padding: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1.5rem;
  position: relative;
  border: 1px solid #e2e8f0;
  animation: fadeIn 0.3s ease-out forwards;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

:deep(.qr-container h3) {
  color: #1e293b;
  margin: 0;
  font-size: 1.4rem;
  font-weight: 700;
  text-align: center;
}

:deep(.qr-container .qr-code) {
  padding: 1.5rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
  border: 1px solid #e2e8f0;
}

:deep(.qr-container .close-button) {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background-color: #f1f5f9;
  color: #64748b;
  border: none;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s ease;
}

:deep(.qr-container .close-button:hover) {
  background-color: #e2e8f0;
  color: #334155;
}

/* Diseño responsivo mejorado */
@media (max-width: 768px) {
  .reservations-waiter {
    padding: 1rem;
  }
  
  .waiter-dashboard-header {
    padding: 1.25rem;
  }
  
  .dashboard-title {
    font-size: 1.4rem;
  }
  
  .notification-badge {
    font-size: 0.75rem;
    padding: 0.3rem 0.8rem;
  }
  
  .reservation-cards-container {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .client-info {
    grid-template-columns: 1fr;
  }
  
  .date-highlight {
    flex-direction: column;
    gap: 0.75rem;
    align-items: flex-start;
    padding: 1rem;
  }
  
  .today-indicator {
    align-self: flex-start;
  }
  
  .card-actions {
    flex-direction: column;
    padding: 1rem;
  }
  
  .action-button {
    width: 100%;
    justify-content: center;
  }
  
  .orders-section, .ticket-section {
    padding: 1.25rem;
  }
  
  .order-item, .ticket-order-item {
    padding: 1.25rem;
  }
  
  .summary-item .label,
  .summary-item .value {
    font-size: 1rem;
  }
  
  .product-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
  }
  
  .product-actions {
    align-self: flex-end;
  }
}

@media (max-width: 480px) {
  .waiter-dashboard-header {
    padding: 1rem;
  }
  
  .dashboard-title {
    font-size: 1.2rem;
    letter-spacing: 0;
  }
  
  .card-header {
    padding: 1rem;
  }
  
  .reservation-id .value {
    font-size: 1.1rem;
  }
  
  .reservation-status {
    font-size: 0.7rem;
    padding: 0.3rem 0.7rem;
  }
  
  .card-body {
    padding: 1rem;
  }
  
  .date-value {
    font-size: 1rem;
  }
  
  .action-button {
    font-size: 0.9rem;
    padding: 0.6rem 1rem;
  }
  
  .order-header, .ticket-order-item .order-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
  }
  
  .order-status {
    align-self: flex-start;
  }
  
  .ticket-product-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  
  .ticket-product-subtotal {
    align-self: flex-end;
  }
}
</style>