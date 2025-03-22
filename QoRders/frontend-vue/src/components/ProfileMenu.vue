<template>
    <div class="profile-menu-container" :class="userTypeClass">
        <!-- Elementos decorativos solo para clientes -->
        <div v-if="props.userType === 'client'" class="menu-decoration top">
            <div class="decoration-line"></div>
            <div class="decoration-ornament">✦</div>
            <div class="decoration-line"></div>
        </div>

        <div class="avatar-container">
            <img :src="userImageUrl" alt="User Avatar" class="user-avatar" />
            
            <!-- Badge distintivo según tipo de usuario -->
            <div class="user-badge" v-if="props.userType !== 'client'">
                <i :class="userBadgeIcon"></i>
            </div>
        </div>
        
        <h2 class="user-name">{{ userName }}</h2>
        <div class="user-role" v-if="props.userType !== 'client'">{{ userRoleTitle }}</div>

        <nav class="menu-nav">
            <ul>
                <li :class="{ active: activeView === 'Data' }" @click="changeView('Data')">
                    <i :class="getIconClass('Data')"></i>
                    <span>{{ props.userType === 'client' ? 'Perfil' : 'Datos Personales' }}</span>
                </li>
                
                <li v-if="props.userType === 'client'" :class="{ active: activeView === 'ReservationsHistory' }"
                    @click="changeView('ReservationsHistory')">
                    <i class="pi pi-calendar-plus"></i>
                    <span>Reservas</span>
                </li>
                
                <li v-if="props.userType === 'waiter'" :class="{ active: activeView === 'ReservationsWaiter' }"
                    @click="changeView('ReservationsWaiter')">
                    <i class="pi pi-calendar-plus"></i>
                    <span>Reservas a atender</span>
                </li>
                
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'OngsManagement' }"
                    @click="changeView('OngsManagement')">
                    <i class="pi pi-heart"></i>
                    <span>Gestión de ONGs</span>
                </li>
                
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'RoomManagement' }"
                    @click="changeView('RoomManagement')">
                    <i class="pi pi-th-large"></i>
                    <span>Gestión de Salas</span>
                </li>
                
                <li v-if="props.userType === 'manager'" :class="{ active: activeView === 'MenuManagement' }"
                    @click="changeView('MenuManagement')">
                    <i class="pi pi-list"></i>
                    <span>Gestión de Carta</span>
                </li>
                
                <li :class="{ active: activeView === 'Settings' }" @click="changeView('Settings')">
                    <i class="pi pi-cog"></i>
                    <span>{{ props.userType === 'client' ? 'Actualizar Datos' : 'Ajustes' }}</span>
                </li>
            </ul>
        </nav>
        
        <!-- Elementos decorativos solo para clientes -->
        <div v-if="props.userType === 'client'" class="menu-decoration bottom">
            <div class="decoration-line"></div>
            <div class="decoration-ornament">✦</div>
            <div class="decoration-line"></div>
        </div>
        
        <!-- Sello solo para clientes -->
        <div v-if="props.userType === 'client'" class="client-stamp">Cliente Distinguido</div>
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

// Clase CSS basada en tipo de usuario
const userTypeClass = computed(() => {
    return {
        'client-theme': props.userType === 'client',
        'waiter-theme': props.userType === 'waiter',
        'manager-theme': props.userType === 'manager'
    }
});

// Título del rol según tipo de usuario
const userRoleTitle = computed(() => {
    switch (props.userType) {
        case 'waiter':
            return 'Personal de Servicio';
        case 'manager':
            return 'Administrador';
        default:
            return '';
    }
});

// Icono de badge según tipo de usuario
const userBadgeIcon = computed(() => {
    return {
        'pi pi-user': props.userType === 'waiter',
        'pi pi-briefcase': props.userType === 'manager'
    }
});

const emit = defineEmits(['change-view']);
const getDefaultView = () => {
  switch (props.userType) {
    case 'client':
      return 'ReservationsHistory';
    case 'waiter':
      return 'ReservationsWaiter';
    default:
      return 'Data';
  }
};

const activeView = ref(getDefaultView());

const changeView = (view) => {
    activeView.value = view;
    emit('change-view', view);
};

// Obtener icono según la vista
const getIconClass = (view) => {
    const icons = {
        'Data': props.userType === 'client' ? 'pi pi-user' : 'pi pi-id-card',
        'Settings': 'pi pi-cog'
    };
    
    return icons[view] || 'pi pi-circle';
};

// Aplicar estilos globales para inputs cuando se monta el componente
onMounted(() => {
    emit('change-view', activeView.value);
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
/* Estilos base para todos los tipos de usuario */
.profile-menu-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 30px 20px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    position: relative;
    overflow: hidden;
    height: 100%;
}

.avatar-container {
    position: relative;
    margin-bottom: 15px;
}

.user-avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid white;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.user-name {
    margin: 0 0 5px;
    font-weight: 600;
    text-align: center;
}

.user-role {
    font-size: 0.85rem;
    margin-bottom: 20px;
    opacity: 0.8;
    font-weight: 500;
}

.menu-nav {
    width: 100%;
}

.menu-nav ul {
    list-style: none;
    padding: 0;
    width: 100%;
    margin: 0;
}

.menu-nav ul li {
    margin-bottom: 12px;
    cursor: pointer;
    padding: 12px 15px;
    border-radius: 8px;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    font-weight: 500;
}

.menu-nav ul li i {
    margin-right: 10px;
    font-size: 1.1rem;
}

/* ------ TEMA CLIENTE (GASTRONÓMICO) ------ */
.client-theme {
    background-color: #FFFCF5;
    color: #5D4037;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23FFFCF5"/><path d="M0,0 L100,100 M100,0 L0,100" stroke="%23EFEBE9" stroke-width="0.5"/></svg>');
    background-repeat: repeat;
    border: 1px solid rgba(93, 64, 55, 0.2);
    font-family: 'Playfair Display', serif;
}

.client-theme .user-avatar {
    border: 4px solid #f1e3d3;
}

.client-theme .user-name {
    font-family: 'Playfair Display', serif;
    font-size: 1.6rem;
    color: #8B4513;
    margin-bottom: 10px;
}

.client-theme .menu-nav ul li {
    border-bottom: 1px dashed #D7CCC8;
    border-radius: 0;
    padding: 14px 5px;
    color: #5D4037;
    font-weight: normal;
    font-size: 1.05rem;
}

.client-theme .menu-nav ul li:hover {
    background-color: rgba(255, 252, 245, 0.7);
    transform: translateY(-2px);
    color: #8B4513;
}

.client-theme .menu-nav ul li.active {
    background-color: rgba(215, 204, 200, 0.3);
    color: #8B4513;
    font-weight: bold;
    border-left: 3px solid #8B4513;
    box-shadow: none;
}

.client-theme .menu-nav ul li i {
    color: #8D6E63;
}

.menu-decoration {
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 15px 0;
    width: 100%;
}

.decoration-line {
    flex-grow: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, #8D6E63, transparent);
}

.decoration-ornament {
    margin: 0 20px;
    font-size: 20px;
    color: #8D6E63;
}

.client-stamp {
    position: absolute;
    bottom: 20px;
    right: 20px;
    transform: rotate(-15deg);
    font-family: 'Dancing Script', cursive;
    font-size: 1.2rem;
    color: rgba(139, 69, 19, 0.3);
    border: 1px solid rgba(139, 69, 19, 0.3);
    border-radius: 5px;
    padding: 5px 10px;
}

/* ------ TEMA CAMARERO (PROFESIONAL) ------ */
.waiter-theme {
    background-color: #f8f9fa;
    color: #333;
    background-image: linear-gradient(135deg, rgba(0,0,0,0.01) 25%, transparent 25%, transparent 50%, rgba(0,0,0,0.01) 50%, rgba(0,0,0,0.01) 75%, transparent 75%, transparent);
    background-size: 40px 40px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.waiter-theme .user-badge {
    position: absolute;
    bottom: 0;
    right: 0;
    background-color: #17a2b8;
    color: white;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid white;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.waiter-theme .user-name {
    color: #2c3e50;
}

.waiter-theme .user-role {
    color: #17a2b8;
    font-weight: 600;
}

.waiter-theme .menu-nav ul li {
    background-color: rgba(255, 255, 255, 0.8);
    margin-bottom: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    border-left: 3px solid transparent;
}

.waiter-theme .menu-nav ul li:hover {
    background-color: #fff;
    transform: translateX(5px);
    border-left: 3px solid #17a2b8;
}

.waiter-theme .menu-nav ul li.active {
    background-color: #17a2b8;
    color: white;
    border-left: 3px solid #117a8b;
}

.waiter-theme .menu-nav ul li.active i {
    color: white;
}

.waiter-theme .menu-nav ul li i {
    color: #17a2b8;
}

/* ------ TEMA MANAGER (CORPORATIVO) ------ */
.manager-theme {
    background-color: #f0f4f8;
    color: #333;
    background-image: linear-gradient(60deg, rgba(72, 126, 176, 0.05) 25%, transparent 25%, transparent 50%, rgba(72, 126, 176, 0.05) 50%, rgba(72, 126, 176, 0.05) 75%, transparent 75%, transparent);
    background-size: 20px 20px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.manager-theme .user-avatar {
    border-color: #e9ecef;
}

.manager-theme .user-badge {
    position: absolute;
    bottom: 0;
    right: 0;
    background-color: #2c3e50;
    color: white;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 2px solid white;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.manager-theme .user-name {
    color: #2c3e50;
}

.manager-theme .user-role {
    color: #2c3e50;
    background-color: rgba(44, 62, 80, 0.1);
    padding: 4px 12px;
    border-radius: 15px;
    font-size: 0.8rem;
}

.manager-theme .menu-nav ul li {
    background-color: white;
    border-radius: 4px;
    margin-bottom: 10px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
    font-weight: 500;
    border-left: 3px solid transparent;
}

.manager-theme .menu-nav ul li:hover {
    background-color: #f8f9fa;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-left: 3px solid #3498db;
}

.manager-theme .menu-nav ul li.active {
    background: linear-gradient(90deg, #2c3e50, #3498db);
    color: white;
    box-shadow: 0 4px 8px rgba(52, 152, 219, 0.3);
    border-left: 3px solid #2c3e50;
}

.manager-theme .menu-nav ul li.active i {
    color: white;
}

.manager-theme .menu-nav ul li i {
    color: #3498db;
}

/* Responsive */
@media (max-width: 768px) {
    .profile-menu-container {
        padding: 20px 15px;
    }

    .user-avatar {
        width: 80px;
        height: 80px;
    }

    .user-name {
        font-size: 1.2rem;
    }

    .menu-nav ul {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
    }

    .menu-nav ul li {
        margin: 5px;
        padding: 8px 15px;
        font-size: 0.9rem;
        flex: 1 1 auto;
        min-width: 120px;
        text-align: center;
        display: block;
    }
    
    .menu-nav ul li i {
        display: block;
        margin: 0 auto 5px;
        font-size: 1.2rem;
    }
    
    .client-stamp {
        display: none;
    }
    
    .client-theme .menu-nav ul li {
        border-bottom: none;
        padding: 10px;
    }
}
</style>