<template>
    <div class="reservations-waiter">
        <h1 class="title">Reservas</h1>
        
        <div v-if="reservations.length > 0">
            <ul class="reservations-list">
                <li v-for="reservation in reservations" :key="reservation.id" class="reservation-card">
                    <div class="reservation-header">
                        <h3>Reserva Nº: {{ reservation.id }}</h3>
                        <span class="badge">{{ reservation.guestCount }} comensales</span>
                    </div>
                    <div class="reservation-body">
                        <p><strong>Notas:</strong> {{ reservation.notes }}</p>
                        <p><strong>Email:</strong> {{ reservation.clientName }}</p>
                        <p><strong>Fecha:</strong> {{ reservation.date }}</p>
                        <p><strong>Estado:</strong> {{ reservation.status }}</p>
                    </div>
                    <div class="reservation-footer">
                        <button v-if="reservation.status === 'Confirmed'"  @click="generateQr(reservation)" class="btn-generate-qr">Mostrar QR</button>
                        <GenerateQR 
                            v-if="reservation.showQr" 
                            :url="reservation.qrUrl" 
                            @close="closeQr(reservation)"
                        />
                        &nbsp;

                        <!-- Botón para Ver Pedidos, visible solo si el estado es InProgress -->
                        <button v-if="reservation.status === 'InProgress'" @click="fetchOrders(reservation)"
                            class="btn-view-orders">
                            Ver Pedidos
                        </button>
                    </div>

                    <!-- Sección para mostrar las órdenes -->
                    <div v-if="reservation.orders && reservation.orders.length > 0" class="orders-section">
                        <h4>Pedidos</h4>
                        <ul>
                            <li v-for="order in reservation.orders" :key="order.id" class="order-item">
                                <p><strong>Pedido Nº:</strong> {{ order.id }}</p>
                                <p><strong>Estado:</strong> {{ order.status }}</p><hr>

                                <!-- Productos dentro de la orden -->
                                <h3>Productos</h3>
                                <ul class="products-list">
                                    <li v-for="product in order.products" :key="product.name">
                                        <p><strong>Producto:</strong> {{ product.name }}</p>
                                        <p><strong>Cantidad:</strong> {{ product.quantity }}</p>
                                    </li>
                                </ul>

                                <!-- Botón para cambiar el estado -->
                                <button class="btn-change-status" @click="changeOrderStatus(order)"
                                    :disabled="order.status === 'Delivered'">
                                    {{ getOrderButtonLabel(order.status) }}
                                </button>
                            </li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <div v-else>
            <p class="no-reservations">No hay reservas disponibles.</p>
        </div>
    </div>
</template>

<script>
import { mapActions, mapState } from "vuex";
import GenerateQR from "./GenerateQR.vue";

export default {
    components: {
        GenerateQR,
    },
    data() {
        return {
            showQr: false, // Controla la visualización del QR
            qrUrl: null, // URL del QR
        };
    },
    computed: {
        ...mapState("storeWaiter", ["reservations"]), // Mapea las reservas desde Vuex
    },
    methods: {
        ...mapActions("storeWaiter", ["fetchGenerateQr", "fetchReservations"]),
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
                reservation.orders = response; // Añade las órdenes al objeto `reservation`
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

                console.log("Respuesta del backend en componente:", response); // Log de la respuesta

                // Ajusta el acceso a la propiedad según la estructura real
                const updatedStatus = response.data?.order_status || response.order_status;
                order.status = updatedStatus;
            } catch (error) {
                console.error("Error al cambiar el estado de la orden:", error);
            }
        },
        getOrderButtonLabel(status) {
            if (status === "Waiting") return "Asignar";
            if (status === "Assigned") return "Entregado";
            return "Entregado";
        },
    },
    async mounted() {
        // Carga las reservas desde la base de datos al montar el componente
        try {
            await this.fetchReservations();
        } catch (error) {
            console.error("Error al cargar las reservas:", error);
        }
    },
};
</script>

<style scoped>
/* General container styling */
.reservations-waiter {
    padding: 2rem;
    background-color: #f9f9f9;
    font-family: Arial, sans-serif;
}

.title {
    font-size: 2rem;
    font-weight: bold;
    text-align: center;
    margin-bottom: 1.5rem;
    color: #333;
}

/* Reservations list styling */
.reservations-list {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    padding: 0;
}

.reservation-card {
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 10px;
    padding: 1.5rem;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.reservation-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
}

/* Header section */
.reservation-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.reservation-header h3 {
    font-size: 1.5rem;
    font-weight: bold;
    color: #47515b;
}

.badge {
    background-color: #17a2b8;
    color: white;
    padding: 0.4rem 0.8rem;
    border-radius: 5px;
    font-size: 0.9rem;
    font-weight: bold;
    text-transform: uppercase;
}

/* Body section */
.reservation-body {
    margin-bottom: 1rem;
    color: #555;
    font-size: 1rem;
    line-height: 1.5;
}

/* Footer section */
.reservation-footer {
    text-align: right;
}

.btn-generate-qr {
    background-color: #28a745;
    color: white;
    padding: 0.6rem 1rem;
    font-size: 1rem;
    font-weight: bold;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.btn-generate-qr:hover {
    background-color: #218838;
}

/* No reservations styling */
.no-reservations {
    text-align: center;
    font-size: 1.2rem;
    color: #666;
    margin-top: 2rem;
}

ul {
    list-style-type: none;
    padding: 0;
}

.orders-section {
    margin-top: 1rem;
    background-color: #f9f9f9;
    padding: 1rem;
    border-radius: 5px;
    border: 1px solid #ddd;
}

.orders-section h4 {
    font-size: 1.2rem;
    color: #333;
    margin-bottom: 0.5rem;
}

.orders-section ul {
    list-style: none;
    padding: 0;
}

.orders-section li {
    border-bottom: 1px solid #ddd;
    padding: 0.5rem 0;
}

.orders-section li:last-child {
    border-bottom: none;
}

.btn-view-orders {
    background-color: #0d40a6;
    color: white;
    padding: 0.6rem 1rem;
    font-size: 1rem;
    font-weight: bold;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.2s ease;
}

.btn-view-orders:hover {
    background-color: #0056b3;
}

.orders-section {
    margin-top: 1rem;
    background-color: #f9f9f9;
    padding: 1rem;
    border-radius: 5px;
    border: 1px solid #ddd;
}

.orders-section h4 {
    font-size: 1.2rem;
    color: #333;
    margin-bottom: 0.5rem;
}

.orders-section ul {
    list-style: none;
    padding: 0;
}

.order-item {
    border-bottom: 1px solid #ddd;
    padding: 1rem 0;
}

.order-item:last-child {
    border-bottom: none;
}

.products-list {
    margin-top: 0.5rem;
    padding-left: 1rem;
    list-style: disc;
}

.products-list li {
    margin-bottom: 0.5rem;
}

.btn-view-orders {
    background-color: #007bff;
    color: white;
    padding: 0.6rem 1rem;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.btn-view-orders:hover {
    background-color: #0056b3;
}

.btn-change-status {
    margin-top: 1rem;
    background-color: #ffc107;
    color: white;
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 5px;
    font-size: 1rem;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.btn-change-status:hover {
    background-color: #e0a800;
}

.btn-change-status:disabled {
    background-color: #6c757d;
    cursor: not-allowed;
}
</style>