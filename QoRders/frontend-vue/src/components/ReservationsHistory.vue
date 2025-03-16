<template>
    <div class="reservations-history">
        <p v-if="reservations.length === 0">No tienes reservas.</p>
        <h2 v-else>Historial de reservas:</h2>

        <!-- Iteramos sobre las reservas -->
        <div v-for="reservation in reservations" :key="reservation.bookingId" class="reservation-card"
             :style="{ backgroundImage: 'url(' + getRoomImageUrl(reservation.roomName) + ')' }">
            <Card class="transparent-card">
                <template #title>
                    <h3>{{ reservation.roomName }} - {{ reservation.status }}</h3>
                </template>
                <template #content>
                    <div class="reservation-info">
                        <p><strong>Fecha:</strong> {{ formatDate(reservation.bookingDate) }}</p>
                        <p><strong>Comensales:</strong> {{ reservation.guestCount }}</p>
                        <p v-if="reservation.notes"><strong>Notas:</strong> {{ reservation.notes }}</p>
                    </div>
                    <!-- Accordion para tickets -->
                    <Accordion :activeIndex="null" v-if="reservation.tickets.length !== 0">
                        <AccordionPanel v-for="ticket in reservation.tickets" :key="ticket.ticketId">
                            <AccordionHeader>Ticket Nº {{ ticket.ticketId }}</AccordionHeader>
                            <AccordionContent>
                                <p><strong>Cantidad a pagar:</strong> €{{ ticket.amountToPay }}</p>
                                <p><strong>Estado de pago:</strong> {{ ticket.paymentStatus }}</p>
                                <p><strong>Total a pagar:</strong> €{{ ticket.totalAmount }}</p>
                            </AccordionContent>
                        </AccordionPanel>
                    </Accordion>
                </template>
            </Card>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const props = defineProps({
    reservations: {
        type: Array,
        required: true
    }
});

// Obtener todas las salas desde el store
const rooms = computed(() => store.getters['storeRooms/getRooms'] || []);

// Cargar las salas si no están ya cargadas
onMounted(() => {
    if (rooms.value.length === 0) {
        store.dispatch('storeRooms/fetchRooms');
    }
});

// Función para obtener la URL de la imagen de la sala
const getRoomImageUrl = (roomName) => {
    // Buscar la sala por nombre
    const room = rooms.value.find(room => room.theme === roomName);
    
    // Si encontramos la sala, devolver su URL de imagen, si no, una imagen por defecto
    return room ? room.imageUrl : '/images/default-room.jpg';
};

// Función para formatear las fechas
const formatDate = (date) => {
    const d = new Date(date);
    return d.toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
};
</script>

<style scoped>
.reservations-history {
    margin: 20px;
}

.reservation-card {
    margin-bottom: 20px;
    position: relative;
    border-radius: 10px;
    overflow: hidden;
    background-size: cover;
    background-position: center;
    padding: 0;
    transition: transform 0.3s ease;
}

.reservation-card:hover {
    transform: translateY(-5px);
}

.transparent-card {
    background-color: rgba(255, 255, 255, 0.85) !important;
    backdrop-filter: blur(3px);
    border: none !important;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1) !important;
}

:deep(.p-card) {
    background-color: rgba(255, 255, 255, 0.85) !important;
    box-shadow: none !important;
}

:deep(.p-card-title) {
    color: #333;
    font-weight: bold;
    padding-bottom: 10px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
}

:deep(.p-card-content) {
    padding: 15px;
}

.reservation-info {
    margin-top: 10px;
    margin-bottom: 10px;
    background-color: rgba(255, 255, 255, 0.7);
    color: #333 !important;
    padding: 10px;
    border-radius: 8px;
}

.reservation-info p {
    margin: 5px 0;
    font-size: 1rem;
}

:deep(.p-accordion-header-link) {
    background-color: rgba(255, 255, 255, 0.7) !important;
    color: #333 !important;
    font-weight: bold !important;
    border: none !important;
}

:deep(.p-accordion-content) {
    background-color: rgba(255, 255, 255, 0.7) !important;
    color: #333 !important;
    border: none !important;
}

:deep(.p-accordion) {
    border-radius: 8px;
    overflow: hidden;
    margin-top: 15px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}
</style>