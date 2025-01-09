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
                        <button v-if="reservation.status === 'Confirmed'" @click="generateQr(reservation)"
                            class="btn-generate-qr">Mostrar QR</button>
                        <GenerateQR v-if="reservation.showQr" :url="reservation.qrUrl" @close="closeQr(reservation)" />

                        <!-- Botón para Ver Pedidos, visible solo si el estado es InProgress -->
                        <button v-if="reservation.status === 'InProgress'" @click="fetchOrders(reservation)"
                            class="btn-view-orders">
                            Ver Pedidos
                        </button>

                        <button v-if="reservation.status === 'Completed'" @click="fetchTicket(reservation)"
                            class="btn-view-ticket">
                            Ver Ticket
                        </button>
                    </div>

                    <!-- Sección para mostrar las órdenes -->
                    <div v-if="reservation.orders && reservation.orders.length > 0" class="orders-section">
                        <h4>Pedidos</h4>
                        <ul>
                            <li v-for="order in reservation.orders" :key="order.id" class="order-item">
                                <p><strong>Pedido Nº:</strong> {{ order.id }}</p>
                                <p><strong>Estado:</strong> {{ order.status }}</p>
                                <hr>

                                <!-- Productos dentro de la orden -->
                                <h3>Comanda</h3>
                                <ul class="products-list">
                                    <DataTable :value="order.products">
                                        <Column field="name" header="Producto" />
                                        <Column field="quantity" header="Cantidad" />
                                    </DataTable>
                                </ul>

                                <!-- Botón para cambiar el estado -->
                                <button class="btn-change-status" @click="changeOrderStatus(order)"
                                    :disabled="order.status === 'Delivered'">
                                    {{ getOrderButtonLabel(order.status) }}
                                </button>
                            </li>
                        </ul>
                    </div>
                    <div v-if="reservation.ticket" class="ticket-section">
                        <h4>Ticket</h4>
                        <hr>
                        <p><strong>Total:</strong> {{ reservation.ticket.total_amount }}</p>
                        <p><strong>Donación:</strong> {{ reservation.ticket.donated_amount }}</p>
                        <p><strong>Estado de pago:</strong> {{ reservation.ticket.payment_status }}</p>
                        <hr>

                        <h5>Pedidos Realizados</h5>
                        <ul>
                            <li v-for="order in reservation.ticketOrders" :key="order.order_id">
                                <p><strong>Orden Nº:</strong> {{ order.order_id }}</p>
                                <p><strong>Total:</strong> {{ order.total_amount }}</p>
                                <hr>

                                <h3>Comanda</h3>
                                <ul>
                                    <DataTable :value="order.products">
                                        <Column field="product_name" header="Orden" />
                                        <Column field="product_quantity" header="Total" />
                                        <Column field="unit_price" header="Precio Unitario" />
                                        <Column field="subtotal" header="Subtotal" />
                                    </DataTable>
                                </ul>
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
            showQr: false,
            qrUrl: null,
        };
    },
    computed: {
        ...mapState("storeWaiter", ["reservations"]),
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
            if (status === "Assigned") return "Entregado";
            return "Finalizado";
        },
        ...mapActions("storeWaiter", ["fetchTicketFromStore"]),
        async fetchTicket(reservation) {
            try {
                const response = await this.fetchTicketFromStore(reservation.id);

                reservation.ticket = response.ticket;
                reservation.ticketOrders = response.orders;

            } catch (error) {
                console.error("Error al obtener el ticket:", error);
            }
        },
    },
    async mounted() {
        try {
            await this.fetchReservations();
        } catch (error) {
            console.error("Error al cargar las reservas:", error);
        }
    },
};
</script>

<style scoped>
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

.reservations-list,
.orders-section ul,
.ticket-section ul {
    list-style: none;
    padding: 0;
}

.reservations-list {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.reservation-card,
.orders-section,
.ticket-section {
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

.reservation-header,
.reservation-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
}

.reservation-header h3,
.orders-section h4,
.ticket-section h4,
.ticket-section h5 {
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

.reservation-body,
.orders-section,
.ticket-section {
    margin-bottom: 1rem;
    color: #555;
    font-size: 1rem;
    line-height: 1.5;
}

.no-reservations {
    text-align: center;
    font-size: 1.2rem;
    color: #666;
    margin-top: 2rem;
}

.order-item,
.products-list li {
    border-bottom: 1px solid #ddd;
    padding: 1rem 0;
}

.order-item:last-child,
.products-list li:last-child {
    border-bottom: none;
}

.products-list {
    margin-top: 0.5rem;
    padding-left: 1rem;
    list-style: disc;
}

button {
    padding: 0.6rem 1rem;
    font-size: 1rem;
    font-weight: bold;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s ease;
    color: white;
}

.btn-generate-qr {
    background-color: #28a745;
}

.btn-generate-qr:hover {
    background-color: #218838;
}

.btn-view-orders {
    background-color: #007bff;
}

.btn-view-orders:hover {
    background-color: #0056b3;
}

.btn-view-ticket {
    background-color: rgb(166, 153, 67);
}

.btn-view-ticket:hover {
    background-color: rgb(179, 170, 0);
}

.btn-change-status {
    margin-top: 10px;
    background-color: #ffc107;
}

.btn-change-status:hover {
    background-color: #e0a800;
}

.btn-change-status:disabled {
    background-color: #6c757d;
    cursor: not-allowed;
}
</style>