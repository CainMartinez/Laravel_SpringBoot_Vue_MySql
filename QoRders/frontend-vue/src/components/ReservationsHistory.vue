<template>
    <div class="reservations-history">
        <p v-if="reservations.length === 0">No tienes reservas.</p>
        <h2 v-else>Historial de reservas:</h2>

        <!-- Iteramos sobre las reservas -->
        <div v-for="reservation in reservations" :key="reservation.bookingId" class="reservation-card">
            <Card>
                <template #title>
                    <h3>{{ reservation.roomName }} - {{ reservation.status }}</h3>
                </template>
                <template #content>
                    <div class="reservation-info">
                        <p><strong>Fecha:</strong> {{ formatDate(reservation.bookingDate) }}</p>
                        <p><strong>Invitados:</strong> {{ reservation.guestCount }}</p>
                        <p v-if="reservation.notes"><strong>Notas:</strong> {{ reservation.notes }}</p>
                    </div>
                    <!-- Accordion para tickets -->
                    <Accordion :activeIndex="null" v-if="reservation.tickets.length !== 0">
                        <AccordionPanel v-for="ticket in reservation.tickets" :key="ticket.ticketId">
                            <AccordionHeader>Ticket {{ ticket.ticketId }}</AccordionHeader>
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
const props = defineProps({
    reservations: {
        type: Array,
        required: true
    }
});

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
}

.reservation-info {
    margin-top: 10px;
    margin-bottom: 10px;
}

.reservation-info p {
    margin: 5px 0;
}
</style>