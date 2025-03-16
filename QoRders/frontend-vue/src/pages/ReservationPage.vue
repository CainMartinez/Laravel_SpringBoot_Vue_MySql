<template>
    <div class="reservation-page">
        <h1>¿Dónde vas a viajar hoy?</h1>

        <Modal v-if="!isAuthenticated" :visible="authModalVisible" :message="authModalMessage" title="Iniciar sesión"
            @update:visible="authModalVisible = $event" @closeModalWithRedirect="redirectToLogin" />

        <div class="reservation-container">
            <div class="form-container">
                <!-- Selección de Sala -->
                <RoomSelect :rooms="rooms" @update:selectedRoom="changeSelectedRoom($event)" />

                <!-- Selección de Número de Personas -->
                <PeopleSelect @update:selectedPeople="changeSelectedPeople($event)" />

                <!-- Selección de Turno -->
                <ShiftSelect @update:selectedShift="changeSelectedShift($event)" />
            </div>

            <div v-if="selectedRoom && selectedShift" class="calendar-container">
                <!-- Calendario -->
                <Calendar :selectedRoom="selectedRoom" :selectedPeople="selectedPeople" :selectedShift="selectedShift"
                    :roomCapacity="roomCapacity" @update:selectedDay="changeSelectedDay($event)" />
            </div>
        </div>
        <!-- Observaciones -->
        <p>*Si desea trona o viene con carrito, debe incluirlo como 1 persona más.</p>
        <div v-if="selectedDay">
            <div class="user-info light-theme-inputs">
                <label for="name">Nombre:</label>
                <InputText id="name" v-model="userFirstName" placeholder="Introduce tu nombre" disabled class="light-input" />

                <label for="email">Email:</label>
                <InputText id="email" v-model="userEmail" placeholder="Introduce tu email" disabled class="light-input" />

                <label for="phone">Teléfono:</label>
                <InputText id="phone" v-model="userPhone" placeholder="Introduce tu teléfono" class="light-input" />
            </div>
        </div>

        <!-- Botón de Reserva -->
        <button @click="handleReservation" :disabled="isDisabled">Hacer Reserva</button>

        <!-- Modal de Reserva -->
        <Modal :visible="reservationModalVisible" :message="reservationModalMessage" title="Reserva"
            @update:visible="reservationModalVisible = $event" @closeModalWithRedirect="redirectToProfile" />
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';
import RoomSelect from '../components/RoomSelect.vue';
import PeopleSelect from '../components/PeopleSelect.vue';
import ShiftSelect from '../components/ShiftSelect.vue';
import Calendar from '../components/Calendar.vue';
import Modal from '../components/Modal.vue';
import useReservation from '../composables/useReservation';

const store = useStore();
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

// Redirigir al login cuando se cierre el modal
const redirectToLogin = () => {
    window.location.href = '/login';
};
const redirectToProfile = () => {
    // window.location.href = '/profile';
};

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
                reservationModalMessage.value = `Reserva realizada para el día ${selectedDay.value} en la sala ${selectedRoom.value} para ${selectedPeople.value} personas en el turno ${selectedShiftSpanish.value}. Revisa los datos de la reserva en tu perfil.`;
            })
            .catch((error) => {
                reservationModalMessage.value = `Error al realizar la reserva: ${error.message}`;
            });
    } else {
        reservationModalMessage.value = "Por favor, completa todos los datos.";
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
.reservation-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background-color: #f7f7f7;
    color: #333;
    font-family: Arial, sans-serif;
    min-height: 100vh;
}

h1 {
    font-size: 2.5em;
    margin-bottom: 30px;
    margin-top: 100px;
}

.reservation-container {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    gap: 20px;
}

.form-container {
    display: flex;
    flex-direction: column;
    padding: 20px;
    border-radius: 8px;
    width: 100%;
    max-width: 400px;
    margin-bottom: 20px;
}

.calendar-container {
    display: flex;
    justify-content: center;
    margin-bottom: 20px;
}

.user-info {
    display: flex;
    flex-direction: column;
    padding: 20px;
    border-radius: 8px;
    width: 100%;
    max-width: 400px;
    margin-bottom: 20px;
    gap: 10px;
}

/* Estilos específicos para inputs */
.user-info input,
.light-input,
.user-info .p-inputtext {
    background-color: #ffffff !important;
    color: #000000 !important;
    padding: 0.5rem;
    border: 1px solid #ced4da;
    border-radius: 4px;
}

.user-info input:focus,
.light-input:focus,
.user-info .p-inputtext:focus {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-color: #80bdff !important;
    box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25) !important;
}

.user-info input:disabled,
.light-input:disabled,
.user-info .p-inputtext:disabled {
    background-color: #e9ecef !important;
    color: #6c757d !important;
}

button {
    padding: 10px 20px;
    font-size: 16px;
    background-color: #333;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.3s;
}

button:hover {
    background-color: #555;
}

button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

@media (max-width: 768px) {
    h1 {
        font-size: 2em;
        margin-top: 50px;
    }

    .reservation-container {
        flex-direction: column;
        gap: 10px;
    }

    .form-container,
    .user-info {
        padding: 10px;
        max-width: 100%;
    }

    button {
        width: 100%;
        padding: 10px;
    }
}

/* Estos estilos se aplicarán a todos los inputs en el componente */
:deep(.p-inputtext),
:deep(input),
:deep(textarea) {
    background-color: #ffffff !important;
    color: #000000 !important;
}

:deep(.p-inputtext:focus),
:deep(input:focus),
:deep(textarea:focus) {
    background-color: #ffffff !important;
    color: #000000 !important;
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