<template>
    <div class="culinary-passport">
        <div class="passport-cover">
            <div class="stamp-decoration top-left"></div>
            <div class="stamp-decoration top-right"></div>
            
            <h1 class="passport-title">Pasaporte Gastronómico</h1>
            <p class="passport-subtitle">Colección de experiencias culinarias</p>
            
            <div class="stamp-decoration bottom-left"></div>
            <div class="stamp-decoration bottom-right"></div>
        </div>

        <div v-if="reservations.length > 0" class="passport-pages">
            <div v-for="reservation in reservations" :key="reservation.bookingId" class="culinary-experience">
                <!-- Sello decorativo -->
                <div class="experience-stamp" :class="getReservationStatusClass(reservation.status)">
                    {{ formatDate(reservation.bookingDate, 'short') }}
                </div>
                
                <!-- Header de la experiencia -->
                <div class="experience-header">
                    <h2 class="destination">{{ reservation.roomName }}</h2>
                    <div class="journey-details">
                        <span class="experience-date">{{ formatDate(reservation.bookingDate) }}</span>
                        <span class="experience-companions">{{ reservation.guestCount }} comensales</span>
                    </div>
                    
                    <div class="experience-visa" :class="getReservationStatusClass(reservation.status)">
                        {{ translateReservationStatus(reservation.status) }}
                    </div>
                </div>
                
                <div class="experience-content">
                    <!-- Imagen de la sala como fondo -->
                    <div class="destination-photo" :style="{ backgroundImage: 'url(' + getRoomImageUrl(reservation.roomName) + ')' }">
                        <div class="photo-overlay">{{ reservation.roomName }}</div>
                    </div>
                    
                    <!-- Detalles de la experiencia -->
                    <div class="experience-details">
                        <div class="experience-section">
                            <h3><i class="cuisine-icon">📝</i> Notas del viaje</h3>
                            <p class="experience-notes">{{ reservation.notes || 'Sin notas para esta experiencia.' }}</p>
                        </div>
                        
                        <!-- Notas o preferencias adicionales -->
                        <div class="experience-section">
                            <h3><i class="cuisine-icon">🍽️</i> Detalles de la visita</h3>
                            <ul class="experience-highlights">
                                <li>
                                    <span class="highlight-label">Tipo de mesa:</span>
                                    <span class="highlight-value">{{ reservation.guestCount > 4 ? 'Grupo' : 'Íntima' }}</span>
                                </li>
                                <li>
                                    <span class="highlight-label">Momento:</span>
                                    <span class="highlight-value">{{ new Date(reservation.bookingDate).getHours() < 16 ? 'Comida' : 'Cena' }}</span>
                                </li>
                                <li>
                                    <span class="highlight-label">Temporada:</span>
                                    <span class="highlight-value">{{ getSeason(reservation.bookingDate) }}</span>
                                </li>
                            </ul>
                        </div>
                        
                        <!-- Sección de pagos -->
                        <div class="experience-section" v-if="reservation.tickets && reservation.tickets.length > 0">
                            <h3><i class="cuisine-icon">🧾</i> Memorias Culinarias</h3>
                            <div class="receipts-collection">
                                <div v-for="ticket in reservation.tickets" :key="ticket.ticketId" class="memory-receipt">
                                    <div class="receipt-header">
                                        <span class="receipt-title">Factura #{{ ticket.ticketId }}</span>
                                        <div class="receipt-status" :class="getPaymentStatusClass(ticket.paymentStatus)">
                                            {{ translatePaymentStatus(ticket.paymentStatus) }}
                                        </div>
                                    </div>
                                    
                                    <div class="receipt-amounts">
                                        <div class="amount-row">
                                            <span>Total gastronómico:</span>
                                            <span class="amount-value">{{ ticket.totalAmount }}€</span>
                                        </div>
                                        <div class="amount-row">
                                            <span>Contribución solidaria:</span>
                                            <span class="amount-value">{{ (ticket.totalAmount * 0.05).toFixed(2) }}€</span>
                                        </div>
                                        <div class="amount-row total">
                                            <span>Importe abonado:</span>
                                            <span class="amount-value">{{ ticket.amountToPay }}€</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Sello de experiencia completada -->
                <div class="completed-stamp" v-if="reservation.status === 'Completed'">
                    Experiencia Consumada
                </div>
            </div>
        </div>
        
        <div v-else class="empty-passport">
            <div class="empty-illustration">🍴</div>
            <h2>Tu Pasaporte está esperando experiencias</h2>
            <p>Aún no has comenzado tu viaje gastronómico con nosotros.<br>¡Reserva tu primera mesa para empezar a coleccionar momentos culinarios!</p>
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

const getRoomImageUrl = (roomName) => {
    // Buscar la sala por theme (ya que reservation.roomName contiene el theme)
    const room = rooms.value.find(room => room.theme === roomName || room.name === roomName);
    
    // Si encontramos la sala, devolver su URL de imagen, si no, una imagen por defecto
    return room ? room.imageUrl : '/images/default-room.jpg';
};

// Función para formatear las fechas con opción de formato corto
const formatDate = (date, format = 'long') => {
    const d = new Date(date);
    
    if (format === 'short') {
        return d.toLocaleDateString('es-ES', {
            day: 'numeric',
            month: 'short'
        });
    }
    
    return d.toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
};

// Obtener la temporada según la fecha
const getSeason = (date) => {
    const month = new Date(date).getMonth();
    
    if (month >= 2 && month <= 4) return 'Primavera';
    if (month >= 5 && month <= 7) return 'Verano';
    if (month >= 8 && month <= 10) return 'Otoño';
    return 'Invierno';
};

// Traducción de estados de reserva
const translateReservationStatus = (status) => {
    const translations = {
        'Pending': 'Por Disfrutar',
        'Confirmed': 'Mesa Reservada',
        'InProgress': 'En Degustación',
        'Completed': 'Experiencia Vivida'
    };
    return translations[status] || status;
};

// Traducción de estados de pago
const translatePaymentStatus = (status) => {
    const translations = {
        'Pending': 'Pendiente de Abono',
        'Paid': 'Abonado',
        'Failed': 'Pago Rechazado'
    };
    return translations[status] || status;
};

// Clases para los estados de reserva
const getReservationStatusClass = (status) => {
    return {
        'status-pending': status === 'Pending',
        'status-confirmed': status === 'Confirmed',
        'status-inprogress': status === 'InProgress',
        'status-completed': status === 'Completed'
    };
};

// Clases para los estados de pago
const getPaymentStatusClass = (status) => {
    return {
        'payment-pending': status === 'Pending',
        'payment-paid': status === 'Paid',
        'payment-failed': status === 'Failed'
    };
};
</script>

<style scoped>
.culinary-passport {
    max-width: 1200px;
    margin: 40px auto;
    font-family: 'Cormorant Garamond', serif;
    background-color: #f8f5f0;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
    border-radius: 10px;
    overflow: hidden;
    color: #2c3e50;
    position: relative;
}

.passport-cover {
    background-color: #8b4513;
    color: #f1e3d3;
    padding: 40px;
    text-align: center;
    position: relative;
    border-bottom: 6px double #f1e3d3;
}

.passport-title {
    font-size: 42px;
    margin: 0;
    font-weight: 700;
    letter-spacing: 2px;
    text-transform: uppercase;
    font-family: 'Playfair Display', serif;
}

.passport-subtitle {
    font-size: 18px;
    margin-top: 10px;
    font-style: italic;
    opacity: 0.9;
}

.stamp-decoration {
    width: 70px;
    height: 70px;
    position: absolute;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="45" fill="none" stroke="%23f1e3d3" stroke-width="2" stroke-dasharray="5,5"/><path d="M30,50 L70,50 M50,30 L50,70" stroke="%23f1e3d3" stroke-width="2"/></svg>');
    background-size: contain;
    opacity: 0.4;
}

.top-left {
    top: 20px;
    left: 20px;
}

.top-right {
    top: 20px;
    right: 20px;
    transform: rotate(90deg);
}

.bottom-left {
    bottom: 20px;
    left: 20px;
    transform: rotate(270deg);
}

.bottom-right {
    bottom: 20px;
    right: 20px;
    transform: rotate(180deg);
}

.passport-pages {
    background-color: #f8f5f0;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23f8f5f0"/><path d="M0,0 L100,100 M100,0 L0,100" stroke="%23eae0d5" stroke-width="0.5"/></svg>');
    padding: 40px;
    display: flex;
    flex-direction: column;
    gap: 40px;
}

.culinary-experience {
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    overflow: hidden;
    position: relative;
    border-left: 15px solid #d4a76a;
    padding: 25px;
}

.experience-stamp {
    position: absolute;
    top: 15px;
    right: 15px;
    width: 60px;
    height: 60px;
    border-radius: 50%;
    border: 2px dashed;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    transform: rotate(10deg);
    z-index: 10;
    font-weight: bold;
    text-align: center;
    line-height: 1.2;
}

.experience-header {
    border-bottom: 1px dashed #d4a76a;
    padding-bottom: 20px;
    margin-bottom: 20px;
    position: relative;
}

.destination {
    font-size: 28px;
    margin: 0 0 10px;
    color: #8b4513;
    font-family: 'Playfair Display', serif;
}

.journey-details {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
    font-size: 15px;
    color: #666;
}

.experience-visa {
    display: inline-block;
    padding: 8px 16px;
    margin-top: 15px;
    border-radius: 4px;
    font-weight: bold;
    letter-spacing: 1px;
    font-size: 14px;
    text-transform: uppercase;
}

.experience-content {
    display: flex;
    flex-wrap: wrap;
    gap: 25px;
}

.destination-photo {
    flex: 1;
    min-width: 300px;
    height: 220px;
    border-radius: 6px;
    background-size: cover;
    background-position: center;
    position: relative;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    border: 5px solid white;
    outline: 1px solid #e1d5c8;
}

.photo-overlay {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    background: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 10px;
    font-family: 'Playfair Display', serif;
    text-align: center;
}

.experience-details {
    flex: 2;
    min-width: 300px;
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.experience-section h3 {
    font-size: 18px;
    color: #8b4513;
    margin: 0 0 10px;
    display: flex;
    align-items: center;
    gap: 8px;
    border-bottom: 1px solid #f0e6d2;
    padding-bottom: 8px;
}

.cuisine-icon {
    font-style: normal;
}

.experience-notes {
    font-style: italic;
    color: #666;
    line-height: 1.6;
}

.experience-highlights {
    list-style: none;
    padding: 0;
    margin: 0;
}

.experience-highlights li {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px dotted #eee;
}

.highlight-label {
    font-weight: bold;
    color: #8b4513;
}

.highlight-value {
    color: #555;
}

.receipts-collection {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
}

.memory-receipt {
    background-color: #fffdf9;
    border: 1px solid #e9e1d7;
    border-radius: 6px;
    padding: 15px;
    flex: 1;
    min-width: 250px;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
}

.receipt-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    border-bottom: 1px solid #f0e6d2;
    padding-bottom: 10px;
}

.receipt-title {
    font-weight: bold;
    color: #5e3517;
}

.receipt-status {
    font-size: 12px;
    padding: 3px 8px;
    border-radius: 20px;
    font-weight: bold;
}

.amount-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    font-size: 14px;
}

.amount-row.total {
    font-weight: bold;
    margin-top: 10px;
    padding-top: 8px;
    border-top: 1px dashed #e9e1d7;
    color: #5e3517;
}

.completed-stamp {
    position: absolute;
    bottom: 30px;
    right: 40px;
    font-family: 'Dancing Script', cursive;
    font-size: 24px;
    color: rgba(40, 167, 69, 0.3);
    border: 2px solid rgba(40, 167, 69, 0.3);
    border-radius: 5px;
    padding: 5px 15px;
    transform: rotate(-15deg);
    z-index: 10;
}

.empty-passport {
    padding: 60px 20px;
    text-align: center;
    background-color: #f8f5f0;
}

.empty-illustration {
    font-size: 60px;
    margin-bottom: 20px;
}

.empty-passport h2 {
    color: #8b4513;
    font-size: 24px;
    margin-bottom: 15px;
}

.empty-passport p {
    color: #666;
    max-width: 500px;
    margin: 0 auto;
    line-height: 1.6;
}

/* Status Colors */
.status-pending {
    border-color: #ffc107;
    color: #856404;
    background-color: rgba(255, 193, 7, 0.1);
}

.status-confirmed {
    border-color: #17a2b8;
    color: #0c5460;
    background-color: rgba(23, 162, 184, 0.1);
}

.status-inprogress {
    border-color: #007bff;
    color: #004085;
    background-color: rgba(0, 123, 255, 0.1);
}

.status-completed {
    border-color: #28a745;
    color: #155724;
    background-color: rgba(40, 167, 69, 0.1);
}

/* Payment Status Colors */
.payment-pending {
    background-color: rgba(255, 193, 7, 0.15);
    color: #856404;
}

.payment-paid {
    background-color: rgba(40, 167, 69, 0.15);
    color: #155724;
}

.payment-failed {
    background-color: rgba(220, 53, 69, 0.15);
    color: #721c24;
}

/* Responsive Styles */
@media (max-width: 768px) {
    .passport-cover {
        padding: 25px 15px;
    }
    
    .passport-title {
        font-size: 28px;
    }
    
    .passport-pages {
        padding: 20px;
    }
    
    .destination-photo {
        height: 180px;
    }
    
    .experience-content {
        flex-direction: column;
    }
    
    .culinary-experience {
        padding: 15px;
    }
    
    .memory-receipt {
        min-width: 100%;
    }
    
    .stamp-decoration {
        width: 40px;
        height: 40px;
    }
}
</style>