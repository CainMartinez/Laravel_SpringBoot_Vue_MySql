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
                    </div>
                    <div class="reservation-footer">
                        <button @click="generateQr(reservation)" class="btn-generate-qr">Mostrar QR</button>
                        <GenerateQR 
                            v-if="reservation.showQr" 
                            :url="reservation.qrUrl" 
                            @close="closeQr(reservation)"
                        />
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
                // Llama al backend para generar el QR
                await this.fetchGenerateQr(reservation.id);

                // Actualiza el estado de esta reserva con el QR y muestra el componente
                reservation.qrUrl = this.$store.getters["storeWaiter/getQrUrl"];
                reservation.showQr = true;
            } catch (error) {
                console.error("Error al generar el QR:", error);
            }
        },
        closeQr(reservation) {
            // Oculta el QR de esta reserva específica
            reservation.showQr = false;
            reservation.qrUrl = null;
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
</style>