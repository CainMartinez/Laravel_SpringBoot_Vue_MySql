<template>
    <div class="reservation-page">
        <div class="culinary-header">
            <div class="header-decoration left"></div>
            <h1>Elige tu Experiencia Gastronómica</h1>
            <div class="header-decoration right"></div>
        </div>

        <Modal v-if="!isAuthenticated" :visible="authModalVisible" :message="authModalMessage" title="Iniciar sesión"
            @update:visible="authModalVisible = $event" @closeModalWithRedirect="redirectToLogin" />

        <div class="menu-card">
            <div class="menu-card-header">
                <div class="menu-decoration"></div>
                <h2>Selección de Reserva</h2>
                <div class="menu-decoration"></div>
            </div>

            <div class="reservation-container">
                <div class="form-container">
                    <!-- Selección de Sala -->
                    <div class="menu-section">
                        <div class="section-title">
                            <i class="pi pi-map-marker"></i>
                            <span>Ambientes Culinarios</span>
                        </div>
                        <RoomSelect :rooms="rooms" @update:selectedRoom="changeSelectedRoom($event)" />
                    </div>

                    <!-- Selección de Número de Personas -->
                    <div class="menu-section">
                        <div class="section-title">
                            <i class="pi pi-users"></i>
                            <span>Comensales</span>
                        </div>
                        <PeopleSelect @update:selectedPeople="changeSelectedPeople($event)" />
                    </div>

                    <!-- Selección de Turno -->
                    <div class="menu-section">
                        <div class="section-title">
                            <i class="pi pi-clock"></i>
                            <span>Servicio</span>
                        </div>
                        <ShiftSelect @update:selectedShift="changeSelectedShift($event)" />
                    </div>
                </div>

                <div v-if="selectedRoom && selectedShift" class="calendar-container">
                    <div class="section-title calendar-title">
                        <i class="pi pi-calendar"></i>
                        <span>Selecciona tu fecha</span>
                    </div>
                    <!-- Calendario -->
                    <Calendar :selectedRoom="selectedRoom" :selectedPeople="selectedPeople" :selectedShift="selectedShift"
                        :roomCapacity="roomCapacity" @update:selectedDay="changeSelectedDay($event)" />
                </div>
            </div>

            <!-- Observaciones culinarias -->
            <div class="culinary-notes">
                <div class="note-icon"><i class="pi pi-info-circle"></i></div>
                <p>*Las tronas o carritos para niños deben contabilizarse como un comensal adicional.</p>
            </div>

            <div v-if="selectedDay" class="guest-information">
                <div class="section-title">
                    <i class="pi pi-id-card"></i>
                    <span>Información del Anfitrión</span>
                </div>
                <div class="user-info light-theme-inputs">
                    <div class="form-group">
                        <label for="name">Nombre:</label>
                        <InputText id="name" v-model="userFirstName" placeholder="Introduce tu nombre" disabled class="light-input" />
                    </div>

                    <div class="form-group">
                        <label for="email">Email:</label>
                        <InputText id="email" v-model="userEmail" placeholder="Introduce tu email" disabled class="light-input" />
                    </div>

                    <div class="form-group">
                        <label for="phone">Teléfono:</label>
                        <InputText id="phone" v-model="userPhone" placeholder="Introduce tu teléfono" class="light-input" />
                    </div>
                </div>
            </div>

            <!-- Botón de Reserva -->
            <button @click="handleReservation" :disabled="isDisabled" class="reservation-button">
                <span class="button-icon"><i class="pi pi-check-circle"></i></span>
                <span class="button-text">Confirmar Reserva</span>
            </button>
        </div>

        <!-- Modal de Reserva -->
        <Modal 
            :visible="reservationModalVisible" 
            :message="reservationModalMessage" 
            :title="modalTitle"
            :showActionButtons="reservationSuccess"
            :primaryButtonText="'Ir a mi Perfil'"
            :secondaryButtonText="'Volver al Inicio'"
            @update:visible="reservationModalVisible = $event" 
            @primaryAction="redirectToProfile"
            @secondaryAction="redirectToHome"
        />
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import { useRouter } from 'vue-router';
import RoomSelect from '../components/RoomSelect.vue';
import PeopleSelect from '../components/PeopleSelect.vue';
import ShiftSelect from '../components/ShiftSelect.vue';
import Calendar from '../components/Calendar.vue';
import Modal from '../components/Modal.vue';
import useReservation from '../composables/useReservation';

const store = useStore();
const router = useRouter();
const { makeReservation } = useReservation(store);

const rooms = computed(() => store.getters['storeRooms/getRooms']);
const isAuthenticated = computed(() => store.getters['storeAuth/getIsAuthenticated']);
const authModalMessage = ref('');
const authModalVisible = ref(false);
const reservationModalMessage = ref('');
const reservationModalVisible = ref(false);
const selectedRoom = ref(null);
const selectedRoomSlug = ref('');
const roomCapacity = ref(0);
const selectedShift = ref('');
const selectedShiftSpanish = ref('');
const selectedPeople = ref(2);
const selectedDay = ref('');
const isDisabled = ref(true);
const userFirstName = computed(() => store.getters['storeAuth/getUserData'].client.firstName);
const userEmail = computed(() => store.getters['storeAuth/getUserData'].client.email);
const userPhone = ref('');

const reservationSuccess = ref(false);
const modalTitle = ref('Reserva');

const redirectToLogin = () => {
    window.location.href = '/login';
};

// Nuevas funciones de redirección
const redirectToProfile = () => {
    router.push('/profile');
};

const redirectToHome = () => {
    router.push('/');
};
// Verificación de la autenticación
if (!isAuthenticated.value) {
    authModalMessage.value = "Debes iniciar sesión para realizar una reserva.";
    authModalVisible.value = true;
}

// Función para aplicar estilos a los inputs
const applyInputStyles = () => {
    setTimeout(() => {
        const inputs = document.querySelectorAll('.p-inputtext');
        inputs.forEach(input => {
            input.style.backgroundColor = '#ffffff';
            input.style.color = '#000000';
        });
    }, 50);
};

onMounted(() => {
    // Aplicar estilos a los inputs cuando se monte el componente
    applyInputStyles();
    
    // Inyectar estilos globales para los inputs de PrimeVue
    const style = document.createElement('style');
    style.textContent = `
        /* Estilos para inputs de PrimeVue */
        .p-inputtext,
        .p-inputtextarea,
        .p-inputnumber input {
            background-color: #ffffff !important;
            color: #000000 !important;
            border-color: #ced4da !important;
        }
        
        .p-inputtext:focus,
        .p-inputtextarea:focus,
        .p-inputnumber input:focus {
            background-color: #ffffff !important;
            color: #000000 !important;
            border-color: #80bdff !important;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25) !important;
        }
        
        .p-inputtext::placeholder {
            color: #6c757d !important;
        }
        
        .p-inputtext:disabled {
            background-color: #e9ecef !important;
            color: #6c757d !important;
        }
    `;
    document.head.appendChild(style);
    
    // Añadir un observer para aplicar estilos cuando cambien elementos del DOM
    const observer = new MutationObserver(() => {
        applyInputStyles();
    });
    
    observer.observe(document.body, { 
        childList: true, 
        subtree: true 
    });
    
    // Limpiar al desmontar
    return () => observer.disconnect();
});

// Cambiar sala, turno, personas
const changeSelectedShift = (shift) => {
    selectedShift.value = shift.code;
    selectedShiftSpanish.value = shift.name;
};

const changeSelectedRoom = (room) => {
    selectedRoom.value = room;
    roomCapacity.value = rooms.value.find(r => r.name === room).maxCapacity;
    selectedRoomSlug.value = rooms.value.find(r => r.name === room).slug;
};

const changeSelectedPeople = (people) => {
    selectedPeople.value = people;
};

const changeSelectedDay = (dayInfo) => {
    selectedDay.value = dayInfo.day;
    isDisabled.value = dayInfo.isDisabled;
    
    // Aplicar estilos a los inputs cuando se seleccione un día
    setTimeout(applyInputStyles, 50);
};

// Realizar la reserva
const handleReservation = () => {
    const reservationData = {
        "date": selectedDay.value,
        "room_slug": selectedRoomSlug.value,
        "firstName": userFirstName.value,
        "shift": selectedShift.value,
        "guest_count": selectedPeople.value,
        "email": userEmail.value,
        "phoneNumber": userPhone.value
    };
    
    if (selectedDay.value && selectedRoomSlug.value && selectedShift.value && selectedPeople.value && userPhone.value) {
        makeReservation(reservationData)
            .then(() => {
                // Actualizar para indicar éxito
                reservationSuccess.value = true;
                modalTitle.value = '¡Reserva Confirmada!';
                reservationModalMessage.value = `¡Excelente elección! Su experiencia gastronómica está reservada para el ${selectedDay.value} en ${selectedRoom.value}, mesa para ${selectedPeople.value} comensales en el servicio de ${selectedShiftSpanish.value}. Puede revisar los detalles en su perfil.`;
            })
            .catch((error) => {
                // Actualizar para indicar error
                reservationSuccess.value = false;
                modalTitle.value = 'Error en la Reserva';
                reservationModalMessage.value = `Lo sentimos, no hemos podido completar su reserva: ${error.message}`;
            });
    } else {
        reservationSuccess.value = false;
        modalTitle.value = 'Información Incompleta';
        reservationModalMessage.value = "Por favor, complete todos los campos del menú de reserva.";
    }
    
    reservationModalVisible.value = true;
};
</script>

<style>
/* Estilos globales para los inputs de PrimeVue */
.p-inputtext,
.p-inputtextarea,
.p-inputnumber input {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-color: #ced4da !important;
}

.p-inputtext:focus,
.p-inputtextarea:focus,
.p-inputnumber input:focus {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-color: #80bdff !important;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25) !important;
}

.p-inputtext::placeholder {
    color: #6c757d !important;
}

.p-inputtext:disabled {
    background-color: #e9ecef !important;
    color: #6c757d !important;
}
</style>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.reservation-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px;
    background-color: #f9f6f0;
    color: #4a3933;
    font-family: 'Lora', serif;
    min-height: 100vh;
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0L50 50L100 0L50 100L0 0Z" fill="%23f2e8dc" fill-opacity="0.3"/></svg>');
    background-size: 300px;
}

.culinary-header {
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 40px 0;
    width: 100%;
    position: relative;
}

.header-decoration {
    flex: 1;
    height: 2px;
    background: linear-gradient(90deg, transparent, #8B4513, transparent);
    max-width: 100px;
    position: relative;
}

.header-decoration::before, .header-decoration::after {
    content: "•";
    position: absolute;
    top: -10px;
    color: #8B4513;
    font-size: 18px;
}

.header-decoration.left::after {
    right: 0;
}

.header-decoration.right::before {
    left: 0;
}

h1 {
    font-family: 'Playfair Display', serif;
    font-size: 2.5rem;
    font-weight: 700;
    margin: 0 20px;
    text-align: center;
    color: #6b4423;
    text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
    letter-spacing: 0.5px;
}

.menu-card {
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 1000px;
    padding: 30px;
    margin-bottom: 40px;
    position: relative;
    border: 1px solid #e8d9c5;
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0L100 100M100 0L0 100" stroke="%23f5efe6" stroke-width="0.5"/></svg>');
}

.menu-card::before {
    content: "";
    position: absolute;
    top: 10px;
    left: 10px;
    right: 10px;
    bottom: 10px;
    border: 1px dashed #e8d9c5;
    border-radius: 8px;
    pointer-events: none;
}

.menu-card-header {
    text-align: center;
    margin-bottom: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.menu-decoration {
    height: 1px;
    background: linear-gradient(90deg, transparent, #8B4513, transparent);
    flex: 1;
    max-width: 120px;
    position: relative;
}

.menu-decoration::before, .menu-decoration::after {
    content: "✦";
    position: absolute;
    top: -10px;
    color: #8B4513;
    font-size: 14px;
}

.menu-decoration:first-child::after {
    right: 0;
}

.menu-decoration:last-child::before {
    left: 0;
}

h2 {
    font-family: 'Playfair Display', serif;
    font-size: 1.8rem;
    font-weight: 600;
    margin: 0 20px;
    color: #6b4423;
}

.reservation-container {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: space-around;
    gap: 30px;
    margin-bottom: 30px;
}

.form-container {
    display: flex;
    flex-direction: column;
    width: 100%;
    max-width: 400px;
    gap: 25px;
}

.menu-section {
    background-color: #fdfbf7;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
    border-left: 3px solid #d4b48f;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.menu-section:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

.section-title {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
    border-bottom: 1px solid #e8d9c5;
    padding-bottom: 10px;
    font-family: 'Playfair Display', serif;
}

.section-title i {
    color: #8B4513;
    font-size: 1.2rem;
    margin-right: 10px;
}

.section-title span {
    font-size: 1.2rem;
    font-weight: 600;
    color: #6b4423;
}

.calendar-container {
    background-color: #fdfbf7;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
    align-items: center;
    border-left: 3px solid #d4b48f;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.calendar-container:hover {
    transform: translateY(-3px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
}

.calendar-title {
    align-self: flex-start;
    border-bottom: 1px solid #e8d9c5;
    width: 100%;
}

.culinary-notes {
    display: flex;
    align-items: center;
    background-color: #f8f5ef;
    border-radius: 6px;
    padding: 10px 15px;
    margin: 20px 0;
    border-left: 3px solid #d4b48f;
}

.note-icon {
    margin-right: 10px;
    color: #8B4513;
    font-size: 1.2rem;
}

.culinary-notes p {
    margin: 0;
    font-style: italic;
    color: #6b4423;
}

.guest-information {
    background-color: #fdfbf7;
    border-radius: 8px;
    padding: 20px;
    margin: 25px 0;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
    border-left: 3px solid #d4b48f;
}

.user-info {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 15px;
    margin-top: 15px;
}

.form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-group label {
    font-weight: 500;
    color: #6b4423;
}

.light-input {
    padding: 10px 12px;
    border: 1px solid #e8d9c5;
    border-radius: 4px;
    background-color: #ffffff;
    color: #333;
    font-family: 'Lora', serif;
}

.light-input:focus {
    border-color: #d4b48f;
    box-shadow: 0 0 0 3px rgba(212, 180, 143, 0.2);
}

.reservation-button {
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 30px auto 0;
    padding: 14px 28px;
    background: linear-gradient(135deg, #8B4513, #d4b48f);
    color: white;
    border: none;
    border-radius: 6px;
    font-family: 'Playfair Display', serif;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

.reservation-button:hover:not(:disabled) {
    background: linear-gradient(135deg, #7b3b0c, #c4a583);
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(139, 69, 19, 0.4);
}

.reservation-button:disabled {
    background: linear-gradient(135deg, #a08676, #d7cfc6);
    cursor: not-allowed;
    box-shadow: none;
}

.button-icon {
    margin-right: 10px;
}

/* Responsive design */
@media (max-width: 768px) {
    h1 {
        font-size: 2rem;
    }

    h2 {
        font-size: 1.5rem;
    }

    .menu-card {
        padding: 20px;
    }

    .reservation-container {
        flex-direction: column;
        align-items: center;
    }

    .form-container,
    .calendar-container {
        max-width: 100%;
    }

    .user-info {
        grid-template-columns: 1fr;
    }

    .header-decoration {
        max-width: 60px;
    }
    
    .reservation-button {
        width: 100%;
    }
}

/* Estos estilos se aplicarán a todos los inputs en el componente */
:deep(.p-inputtext),
:deep(input),
:deep(textarea) {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-color: #e8d9c5 !important;
    font-family: 'Lora', serif !important;
}

:deep(.p-inputtext:focus),
:deep(input:focus),
:deep(textarea:focus) {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-color: #d4b48f !important;
    box-shadow: 0 0 0 3px rgba(212, 180, 143, 0.2) !important;
}

/* Para asegurar que los inputs en modo oscuro se vean bien */
@media (prefers-color-scheme: dark) {
    :deep(.p-inputtext),
    :deep(input),
    :deep(textarea),
    .user-info input,
    .light-input {
        background-color: #ffffff !important;
        color: #000000 !important;
    }
}
</style>