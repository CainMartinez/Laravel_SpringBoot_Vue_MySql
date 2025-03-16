<template>
    <div class="profile-menu-container">
        <img :src="userImageUrl" alt="User Avatar" class="user-avatar" />
        <h2>{{ userName }}</h2>

        <nav>
            <ul>
                <li :class="{ active: activeView === 'Data' }" @click="changeView('Data')">Datos Personales</li>
                <li v-if="props.userType === 'client'" :class="{ active: activeView === 'ReservationsHistory' }"
                    @click="changeView('ReservationsHistory')">Historial de Reservas</li>
                <li v-if="props.userType === 'waiter'" :class="{ active: activeView === 'ReservationsWaiter' }"
                    @click="changeView('ReservationsWaiter')">Reservas a atender</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'OngsManagement' }"
                    @click="changeView('OngsManagement')">Gestion de Ongs</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'RoomManagement' }"
                    @click="changeView('RoomManagement')">Gestion de Salas</li>
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'MenuManagement' }"
                    @click="changeView('MenuManagement')">Gestion de Carta</li>
                <li :class="{ active: activeView === 'Settings' }" @click="changeView('Settings')">Ajustes</li>
            </ul>
        </nav>
    </div>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue';
import { useStore } from 'vuex';

const props = defineProps({
    userType: {
        type: String,
        required: true
    }
});

const store = useStore();
const userName = computed(() => props.userType === 'client' ? store.getters['storeAuth/getUserData'].client.firstName : store.getters['storeAuth/getUserData'].firstName);
const userImageUrl = computed(() => props.userType === 'client' ? store.getters['storeAuth/getUserData'].client.avatar_url : store.getters['storeAuth/getUserData'].avatar_url);

const emit = defineEmits(['change-view']);
const activeView = ref('ReservationsHistory');

const changeView = (view) => {
    activeView.value = view;
    emit('change-view', view);
};

// Aplicar estilos globales para inputs cuando se monta el componente
onMounted(() => {
    // Crear una etiqueta de estilo global
    const styleElement = document.createElement('style');
    
    // Añadir reglas CSS para inputs en toda la aplicación
    styleElement.textContent = `
        /* Estilos para formularios */
        form, 
        .p-card,
        .form-container,
        .profile-container,
        .form-section,
        .p-panel-content {
            background-color: #ffffff !important;
            color: #000000 !important;
            border-radius: 8px !important;
            padding: 20px !important;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1) !important;
            margin-bottom: 20px !important;
        }
        
        /* Estilos para grupos de campos en formularios */
        .form-group,
        .p-field,
        .form-row,
        .field-group {
            margin-bottom: 16px !important;
        }
        
        /* Estilos para etiquetas de formularios */
        form label,
        .p-field > label,
        .form-label {
            display: block !important;
            margin-bottom: 6px !important;
            font-weight: 500 !important;
            color: #000000 !important;
        }

        /* Estilos globales para inputs y elementos de formulario */
        input, 
        textarea, 
        select,
        .p-inputtext,
        .p-password input,
        .p-inputnumber input,
        .p-inputmask,
        .p-dropdown,
        .p-multiselect,
        .p-calendar input,
        .p-chips input,
        .p-autocomplete input,
        .p-float-label input {
            background-color: #ffffff !important;
            color: #000000 !important;
            border: 1px solid #ced4da !important;
            padding: 8px 12px !important;
            border-radius: 4px !important;
            width: 100% !important;
            box-sizing: border-box !important;
            margin-top: 4px !important;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out !important;
        }

        /* Estilos para dropdown panels */
        .p-dropdown-panel,
        .p-multiselect-panel,
        .p-autocomplete-panel,
        .p-calendar-panel {
            background-color: #ffffff !important;
            color: #000000 !important;
            border: 1px solid #ced4da !important;
            border-radius: 4px !important;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1) !important;
        }

        /* Estilos para items dentro de paneles */
        .p-dropdown-item,
        .p-multiselect-item,
        .p-autocomplete-item {
            background-color: #ffffff !important;
            color: #000000 !important;
            padding: 8px 12px !important;
            border-bottom: 1px solid #f2f2f2 !important;
        }

        /* Item seleccionado o activo */
        .p-dropdown-item.p-highlight,
        .p-multiselect-item.p-highlight,
        .p-autocomplete-item.p-highlight {
            background-color: #e6f7ff !important;
            color: #000000 !important;
        }

        /* Estilo para placeholders */
        input::placeholder,
        textarea::placeholder,
        .p-inputtext::placeholder {
            color: #6c757d !important;
            opacity: 0.7 !important;
        }

        /* Estilo para cuando el input está en focus */
        input:focus,
        textarea:focus,
        select:focus,
        .p-inputtext:focus,
        .p-dropdown:focus,
        .p-multiselect:focus {
            border-color: #007bff !important;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25) !important;
            outline: none !important;
        }
        
        /* Estilos para los botones dentro de formularios */
        form button,
        .form-container button,
        .p-button {
            margin-top: 16px !important;
        }
        
        /* Separación entre elementos de formulario */
        form > div,
        .form-group,
        .p-field {
            margin-bottom: 16px !important;
        }
        
        /* Estilos para headers de formulario */
        form h2,
        form h3,
        .form-container h2,
        .form-container h3 {
            margin-bottom: 20px !important;
            color: #000000 !important;
            font-weight: 600 !important;
        }
    `;
    
    // Añadir la etiqueta de estilo al head del documento
    document.head.appendChild(styleElement);
    
    // Limpieza al desmontar el componente (opcional)
    return () => {
        document.head.removeChild(styleElement);
    };
});
</script>

<style scoped>
.profile-menu-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px;
    background-color: #f8f9fa;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.user-avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    margin-bottom: 20px;
    object-fit: cover;
    border: 3px solid white;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

nav ul {
    list-style: none;
    padding: 0;
    width: 100%;
}

nav ul li {
    margin-bottom: 10px;
    cursor: pointer;
    font-weight: bold;
    text-align: center;
    padding: 10px;
    border-radius: 4px;
    transition: all 0.3s ease;
}

nav ul li:hover {
    background-color: #e9ecef;
    transform: translateY(-2px);
}

nav ul li.active {
    background-color: #007bff;
    color: white;
    box-shadow: 0 2px 4px rgba(0, 123, 255, 0.5);
}

/* Estilos específicos para componentes hijos */
:deep(form),
:deep(.form-container),
:deep(.profile-container),
:deep(.form-section),
:deep(.p-card),
:deep(.p-panel-content) {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-radius: 8px !important;
    padding: 20px !important;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1) !important;
    margin-bottom: 20px !important;
}

:deep(input),
:deep(textarea),
:deep(select),
:deep(.p-inputtext),
:deep(.p-password input),
:deep(.p-dropdown),
:deep(.p-multiselect),
:deep(.p-calendar input) {
    background-color: #ffffff !important;
    color: #000000 !important;
    border: 1px solid #ced4da !important;
    padding: 8px 12px !important;
    border-radius: 4px !important;
    width: 100% !important;
    box-sizing: border-box !important;
    margin-top: 4px !important;
}

:deep(.form-group),
:deep(.p-field),
:deep(.form-row) {
    margin-bottom: 16px !important;
}

:deep(label),
:deep(.p-field > label),
:deep(.form-label) {
    display: block !important;
    margin-bottom: 6px !important;
    font-weight: 500 !important;
    color: #000000 !important;
}

:deep(form h2),
:deep(form h3),
:deep(.form-container h2),
:deep(.form-container h3) {
    margin-bottom: 20px !important;
    color: #000000 !important;
    font-weight: 600 !important;
}

@media (max-width: 768px) {
    .profile-menu-container {
        flex-direction: column;
        align-items: center;
        padding: 10px;
    }

    .user-avatar {
        width: 80px;
        height: 80px;
        margin-bottom: 15px;
    }

    nav ul {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        justify-content: center;
    }

    nav ul li {
        font-size: 14px;
        padding: 8px;
        margin: 5px;
        flex: 1 1 auto;
    }
    
    :deep(form),
    :deep(.form-container),
    :deep(.profile-container),
    :deep(.form-section) {
        padding: 15px !important;
    }
}
</style>