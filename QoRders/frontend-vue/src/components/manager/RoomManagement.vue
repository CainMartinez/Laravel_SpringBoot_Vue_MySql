<template>
    <div class="management-container">
        <!-- Toast notifications -->
        <div class="toast-container" v-if="showToast">
            <div class="toast" :class="toastType">
                <div class="toast-icon">
                    <i :class="toastIcon"></i>
                </div>
                <div class="toast-content">
                    <div class="toast-title">{{ toastTitle }}</div>
                    <div class="toast-message">{{ toastMessage }}</div>
                </div>
                <button class="toast-close" @click="hideToast">
                    <i class="pi pi-times"></i>
                </button>
            </div>
        </div>

        <!-- Header section -->
        <div class="page-header">
            <div class="header-icon">
                <i class="pi pi-building"></i>
            </div>
            <div class="header-content">
                <h2>Gestión de Salas</h2>
                <p class="header-subtitle">Administre las salas disponibles para eventos y reservas</p>
            </div>
            <button class="btn-add" @click="crearRoom">
                <i class="pi pi-plus"></i>
                <span>Nueva Sala</span>
            </button>
        </div>

        <!-- Search and filter bar -->
        <div class="filter-bar">
            <div class="search-container">
                <input 
                    type="text" 
                    v-model="searchQuery" 
                    placeholder="Buscar sala..." 
                    class="search-input"
                />
            </div>
            <div class="filter-options">
                <button class="filter-button" :class="{ active: statusFilter === 'all' }" @click="statusFilter = 'all'">
                    Todas
                </button>
                <button class="filter-button" :class="{ active: statusFilter === 'active' }" @click="statusFilter = 'active'">
                    Activas
                </button>
                <button class="filter-button" :class="{ active: statusFilter === 'inactive' }" @click="statusFilter = 'inactive'">
                    Inactivas
                </button>
            </div>
        </div>

        <!-- Main content - Room cards -->
        <div class="rooms-grid">
            <div v-if="filteredRooms.length === 0" class="no-results">
                <i class="pi pi-info-circle"></i>
                <p>No se encontraron salas que coincidan con su búsqueda.</p>
            </div>
            
            <div v-for="room in filteredRooms" :key="room.room_id" class="room-card">
                <div class="card-header">
                    <div class="status-badge" :class="{ active: room.is_active }">
                        {{ room.is_active ? 'Activo' : 'Inactivo' }}
                    </div>
                    <div class="card-actions">
                        <button class="action-button" @click="editRoom(room)" title="Editar sala">
                            <i class="pi pi-pencil"></i>
                        </button>
                        <button 
                            class="action-button" 
                            :class="room.is_active ? 'danger' : 'success'"
                            @click="changeRoom(room)"
                            :title="room.is_active ? 'Desactivar' : 'Activar'"
                        >
                            <i :class="room.is_active ? 'pi pi-power-off' : 'pi pi-check-circle'"></i>
                        </button>
                    </div>
                </div>
                
                <div class="card-image">
                    <img :src="room.image_url" :alt="room.room_name" class="room-image" />
                </div>
                
                <div class="card-body">
                    <h3 class="room-name">{{ room.room_name }}</h3>
                    <p class="room-description">{{ room.description }}</p>
                    
                    <div class="room-meta">
                        <div class="meta-item capacity">
                            <i class="pi pi-users"></i>
                            <span>{{ room.max_capacity }} personas</span>
                        </div>
                        <div class="meta-item theme">
                            <i class="pi pi-palette"></i>
                            <span>{{ room.theme || 'Sin tema definido' }}</span>
                        </div>
                    </div>
                </div>
                
                <div class="card-footer">
                    <div class="ong-association" v-if="getOngName(room.ngo_id)">
                        <i class="pi pi-heart"></i>
                        <span>{{ getOngName(room.ngo_id) }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit/Create Room Modal -->
        <Dialog 
            v-model:visible="modalRoomVisible" 
            :header="roomToEdit?.room_id ? 'Editar Sala' : 'Crear Nueva Sala'" 
            :style="{ width: '700px' }"
            :breakpoints="{ '991px': '90vw' }"
            :modal="true"
            class="room-dialog"
        >
            <div class="dialog-content" v-if="roomToEdit">
                <div class="form-row">
                    <div class="form-group">
                        <label for="room_name">
                            <i class="pi pi-tag"></i>
                            Nombre de la Sala
                        </label>
                        <InputText 
                            id="room_name" 
                            v-model="roomToEdit.room_name" 
                            :class="{ 'input-error': formErrors.room_name }"
                        />
                        <small class="error-message" v-if="formErrors.room_name">{{ formErrors.room_name }}</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="theme">
                            <i class="pi pi-palette"></i>
                            Tema
                        </label>
                        <InputText id="theme" v-model="roomToEdit.theme" />
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">
                        <i class="pi pi-align-left"></i>
                        Descripción
                    </label>
                    <textarea 
                        id="description" 
                        v-model="roomToEdit.description" 
                        rows="3"
                        :class="{ 'input-error': formErrors.description }"
                    ></textarea>
                    <small class="error-message" v-if="formErrors.description">{{ formErrors.description }}</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="max_capacity">
                            <i class="pi pi-users"></i>
                            Capacidad máxima
                        </label>
                        <InputNumber 
                            id="max_capacity" 
                            v-model="roomToEdit.max_capacity" 
                            showButtons 
                            :step="1"
                            :min="1"
                            :max="999"
                            :class="{ 'input-error': formErrors.max_capacity }"
                        />
                        <small class="error-message" v-if="formErrors.max_capacity">{{ formErrors.max_capacity }}</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="ong">
                            <i class="pi pi-heart"></i>
                            ONG Asociada
                        </label>
                        <Select 
                            id="ong" 
                            v-model="ongSelected" 
                            :options="ongs" 
                            optionLabel="ngo_name" 
                            placeholder="Seleccione una ONG"
                            :class="{ 'input-error': formErrors.ong }"
                        />
                        <small class="error-message" v-if="formErrors.ong">{{ formErrors.ong }}</small>
                    </div>
                </div>
                
                <div class="form-group image-upload-section">
                    <label>
                        <i class="pi pi-image"></i>
                        Imagen de la Sala
                    </label>
                    
                    <div class="input-options">
                        <button 
                            type="button" 
                            :class="['option-tab', {'active': imageInputType === 'url'}]" 
                            @click="imageInputType = 'url'"
                        >
                            URL
                        </button>
                        <button 
                            type="button" 
                            :class="['option-tab', {'active': imageInputType === 'file'}]" 
                            @click="imageInputType = 'file'"
                        >
                            Archivo
                        </button>
                    </div>
                    
                    <input 
                        v-if="imageInputType === 'url'" 
                        type="url" 
                        id="image_url" 
                        v-model="roomToEdit.image_url" 
                        :class="{ 'input-error': formErrors.image_url }" 
                        placeholder="https://ejemplo.com/sala.jpg"
                    />
                    
                    <div v-else class="file-upload-control">
                        <input 
                            type="file" 
                            id="room_image_file" 
                            ref="roomImageFileInput"
                            accept="image/*"
                            @change="handleImageUpload($event)" 
                            class="hidden-file-input"
                        />
                        <button 
                            type="button" 
                            class="file-select-button" 
                            @click="triggerFileInput()"
                        >
                            <i class="pi pi-upload"></i>
                            Seleccionar imagen
                        </button>
                        <span class="selected-file-name">
                            {{ getFileNameFromUrl(roomToEdit.image_url) || 'Ningún archivo seleccionado' }}
                        </span>
                    </div>
                    
                    <small class="error-message" v-if="formErrors.image_url">{{ formErrors.image_url }}</small>
                    
                    <div class="image-preview" v-if="roomToEdit.image_url">
                        <img :src="roomToEdit.image_url" alt="Imagen de la sala" />
                    </div>
                </div>
                
                <div class="form-group">
                    <div class="status-toggle">
                        <label for="is_active">Estado de la sala</label>
                        <ToggleButton 
                            v-model="roomToEdit.is_active" 
                            onLabel="Activa" 
                            offLabel="Inactiva"
                            onIcon="pi pi-check" 
                            offIcon="pi pi-times"
                            class="status-toggle-button"
                        />
                    </div>
                </div>
            </div>
            
            <template #footer>
                <div class="dialog-footer">
                    <button class="btn-cancel" @click="closeModal">Cancelar</button>
                    <button class="btn-save" @click="guardarSala">
                        <i class="pi pi-check"></i>
                        Guardar Sala
                    </button>
                </div>
            </template>
        </Dialog>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import { useStore } from 'vuex';
import Dialog from 'primevue/dialog';
import InputText from 'primevue/inputtext';
import InputNumber from 'primevue/inputnumber';
import Select from 'primevue/select';
import ToggleButton from 'primevue/togglebutton';

const store = useStore();

// Toast notification system
const showToast = ref(false);
const toastMessage = ref('');
const toastTitle = ref('');
const toastType = ref('success');
const toastTimeout = ref(null);

const toastIcon = computed(() => {
    return toastType.value === 'success' ? 'pi pi-check-circle' : 
           toastType.value === 'info' ? 'pi pi-info-circle' : 'pi pi-exclamation-triangle';
});

const showToastNotification = (title, message, type = 'success') => {
    if (toastTimeout.value) {
        clearTimeout(toastTimeout.value);
    }
    
    toastTitle.value = title;
    toastMessage.value = message;
    toastType.value = type;
    showToast.value = true;
    
    toastTimeout.value = setTimeout(() => {
        hideToast();
    }, 5000);
};

const hideToast = () => {
    showToast.value = false;
};

// Room data handling
const rooms = computed(() => {
    const data = store.getters['storeAdmin/getAllRooms'].data;
    return Array.isArray(data) ? data : [];
});

const ongs = computed(() => {
    const data = store.getters['storeAdmin/getAllNgos'].data;
    return Array.isArray(data) ? data : [];
});

// Search and filtering
const searchQuery = ref('');
const statusFilter = ref('all');

const filteredRooms = computed(() => {
    let result = [...rooms.value];
    
    // Filter by search term
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(room => 
            room.room_name.toLowerCase().includes(query) || 
            room.description.toLowerCase().includes(query) || 
            room.theme?.toLowerCase().includes(query)
        );
    }
    
    // Filter by status
    if (statusFilter.value === 'active') {
        result = result.filter(room => room.is_active);
    } else if (statusFilter.value === 'inactive') {
        result = result.filter(room => !room.is_active);
    }
    
    return result;
});

// Get ONG name by ID
const getOngName = (ngoId) => {
    const ong = ongs.value.find(ong => ong.ngo_id === ngoId);
    return ong ? ong.ngo_name : '';
};

// Modal management
const modalRoomVisible = ref(false);
const roomToEdit = ref(null);
const ongSelected = ref(null);
const formErrors = ref({});

// Image upload handling
const imageInputType = ref('url');
const roomImageFileInput = ref(null);

const triggerFileInput = () => {
    roomImageFileInput.value.click();
};

const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (!file) return;
    
    // Verificar tamaño (2MB máximo)
    if (file.size > 2 * 1024 * 1024) {
        showToastNotification('Error', 'La imagen es demasiado grande. El tamaño máximo es 2MB.', 'error');
        return;
    }
    
    // Convertir la imagen a base64
    const reader = new FileReader();
    reader.onload = (e) => {
        // Optimizar imagen antes de guardarla
        const img = new Image();
        img.onload = () => {
            // Calcular dimensiones para mantener proporción
            const canvas = document.createElement('canvas');
            const ctx = canvas.getContext('2d');
            
            // Máximo 800px en cualquier dimensión
            let width = img.width;
            let height = img.height;
            const maxDimension = 800;
            
            if (width > height && width > maxDimension) {
                height = (height * maxDimension) / width;
                width = maxDimension;
            } else if (height > maxDimension) {
                width = (width * maxDimension) / height;
                height = maxDimension;
            }
            
            canvas.width = width;
            canvas.height = height;
            
            // Dibujar y comprimir
            ctx.drawImage(img, 0, 0, width, height);
            const dataUrl = canvas.toDataURL('image/jpeg', 0.7); // 70% de calidad
            
            // Asignar a la imagen de la sala
            roomToEdit.value.image_url = dataUrl;
        };
        img.src = e.target.result;
    };
    reader.readAsDataURL(file);
};

// Obtener nombre de archivo de una URL o data URL
const getFileNameFromUrl = (url) => {
    if (!url) return '';
    
    // Si es una data URL (base64)
    if (url.startsWith('data:image')) {
        return 'Imagen cargada';
    }
    
    // Si es una URL normal
    try {
        const urlObj = new URL(url);
        const pathname = urlObj.pathname;
        return pathname.substring(pathname.lastIndexOf('/') + 1);
    } catch (e) {
        return url;
    }
};

const editRoom = (room) => {
    roomToEdit.value = {...room};
    ongSelected.value = ongs.value.find(ong => ong.ngo_id === room.ngo_id) || null;
    imageInputType.value = 'url';
    formErrors.value = {};
    modalRoomVisible.value = true;
};

const crearRoom = () => {
    roomToEdit.value = {
        room_name: '',
        description: '',
        max_capacity: null,
        image_url: '',
        theme: '',
        is_active: true,
        ngo_id: null
    };
    ongSelected.value = null;
    imageInputType.value = 'url';
    formErrors.value = {};
    modalRoomVisible.value = true;
};

const closeModal = () => {
    modalRoomVisible.value = false;
    formErrors.value = {};
};

const validateRoom = () => {
    const errors = {};
    let isValid = true;
    
    if (!roomToEdit.value.room_name) {
        errors.room_name = 'El nombre es obligatorio';
        isValid = false;
    }
    
    if (!roomToEdit.value.description) {
        errors.description = 'La descripción es obligatoria';
        isValid = false;
    }
    
    if (!roomToEdit.value.max_capacity || roomToEdit.value.max_capacity < 1) {
        errors.max_capacity = 'La capacidad debe ser al menos 1 persona';
        isValid = false;
    }
    
    if (!ongSelected.value) {
        errors.ong = 'Debe seleccionar una ONG';
        isValid = false;
    }
    
    if (!roomToEdit.value.image_url) {
        errors.image_url = 'La imagen es obligatoria';
        isValid = false;
    }
    
    formErrors.value = errors;
    return isValid;
};

const guardarSala = async () => {
    if (!validateRoom()) {
        showToastNotification('Error', 'Por favor, corrija los errores del formulario', 'error');
        return;
    }
    
    try {
        // Convertir boolean a número
        const roomData = {...roomToEdit.value};
        roomData.is_active = roomData.is_active ? 1 : 0;
        
        // Asignar el ID de la ONG seleccionada
        roomData.ngo_id = ongSelected.value.ngo_id;
        
        if (roomData.room_id) {
            await store.dispatch('storeAdmin/updateRoom', roomData);
            showToastNotification('Éxito', `Sala "${roomData.room_name}" actualizada correctamente`, 'success');
        } else {
            await store.dispatch('storeAdmin/fetchCreateRoom', roomData);
            showToastNotification('Éxito', `Sala "${roomData.room_name}" creada correctamente`, 'success');
        }
        modalRoomVisible.value = false;
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al guardar la sala', 'error');
    }
};

const changeRoom = async (room) => {
    try {
        const updatedRoom = {...room};
        updatedRoom.is_active = !updatedRoom.is_active;
        
        // Convertir boolean a número para la API
        const isActiveNum = updatedRoom.is_active ? 1 : 0;
        
        if (isActiveNum === 1) {
            await store.dispatch('storeAdmin/enableRoom', updatedRoom.room_slug);
            showToastNotification('Éxito', `Sala "${updatedRoom.room_name}" activada correctamente`, 'success');
        } else {
            await store.dispatch('storeAdmin/disableRoom', updatedRoom.room_slug);
            showToastNotification('Éxito', `Sala "${updatedRoom.room_name}" desactivada correctamente`, 'success');
        }
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al cambiar el estado de la sala', 'error');
    }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

.management-container {
    font-family: 'Inter', sans-serif;
    width: 100%;
    max-width: 1400px;
    margin: 0 auto;
    padding: 20px;
    background-color: #f8fafc;
    color: #2d3748;
}

/* Toast notifications */
.toast-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    max-width: 350px;
    width: 100%;
}

.toast {
    display: flex;
    align-items: flex-start;
    padding: 15px;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
    margin-bottom: 10px;
    animation: slideIn 0.3s ease-out forwards;
    background-color: white;
    border-left: 4px solid;
}

.toast.success {
    border-left-color: #10b981;
}

.toast.error {
    border-left-color: #ef4444;
}

.toast.info {
    border-left-color: #3b82f6;
}

.toast-icon {
    margin-right: 12px;
    font-size: 22px;
}

.toast.success .toast-icon {
    color: #10b981;
}

.toast.error .toast-icon {
    color: #ef4444;
}

.toast.info .toast-icon {
    color: #3b82f6;
}

.toast-content {
    flex: 1;
}

.toast-title {
    font-weight: 600;
    font-size: 16px;
    margin-bottom: 4px;
    color: #1f2937;
}

.toast-message {
    font-size: 14px;
    color: #4b5563;
}

.toast-close {
    background: transparent;
    border: none;
    color: #9ca3af;
    cursor: pointer;
    font-size: 14px;
    padding: 0;
    margin-left: 8px;
}

@keyframes slideIn {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

/* Header */
.page-header {
    display: flex;
    align-items: center;
    margin-bottom: 30px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e2e8f0;
}

.header-icon {
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 24px;
    box-shadow: 0 4px 10px rgba(59, 130, 246, 0.3);
    margin-right: 15px;
}

.header-content {
    flex: 1;
}

.header-content h2 {
    font-size: 24px;
    font-weight: 600;
    color: #1a202c;
    margin: 0 0 5px 0;
}

.header-subtitle {
    font-size: 14px;
    color: #718096;
    margin: 0;
}

.btn-add {
    display: flex;
    align-items: center;
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
    color: white;
    border: none;
    padding: 10px 15px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    font-size: 14px;
    box-shadow: 0 4px 6px rgba(59, 130, 246, 0.2);
    transition: all 0.3s;
}

.btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 10px rgba(59, 130, 246, 0.3);
}

.btn-add i {
    margin-right: 8px;
}

/* Search and filter bar */
.filter-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 25px;
    flex-wrap: wrap;
    gap: 15px;
}

.search-container {
    position: relative;
    flex: 1;
    max-width: 400px;
}

.search-input {
    width: 100%;
    padding: 12px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    background-color: white;
    font-size: 14px;
    color: #4a5568;
    transition: all 0.3s;
}

.search-input:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

.filter-options {
    display: flex;
    gap: 10px;
}

.filter-button {
    padding: 8px 15px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    background-color: white;
    color: #718096;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s;
}

.filter-button:hover {
    background-color: #f7fafc;
}

.filter-button.active {
    background-color: #ebf5ff;
    color: #3b82f6;
    border-color: #bfdbfe;
    font-weight: 500;
}

/* Room Cards Grid */
.rooms-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 25px;
    margin-bottom: 30px;
}

.no-results {
    grid-column: 1 / -1;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 50px 20px;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
    color: #718096;
    text-align: center;
}

.no-results i {
    font-size: 36px;
    margin-bottom: 15px;
    color: #cbd5e0;
}

.room-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
    overflow: hidden;
    transition: all 0.3s;
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
}

.room-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
}

.card-header {
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #f1f5f9;
}

.status-badge {
    background-color: #f3f4f6;
    color: #6b7280;
    font-size: 12px;
    font-weight: 500;
    padding: 4px 8px;
    border-radius: 4px;
}

.status-badge.active {
    background-color: #dcfce7;
    color: #16a34a;
}

.card-actions {
    display: flex;
    gap: 8px;
}

.action-button {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    border: none;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f3f4f6;
    color: #4b5563;
    cursor: pointer;
    transition: all 0.2s;
}

.action-button:hover {
    background-color: #e5e7eb;
}

.action-button.danger {
    color: #ef4444;
}

.action-button.success {
    color: #10b981;
}

.action-button.danger:hover {
    background-color: #fee2e2;
}

.action-button.success:hover {
    background-color: #d1fae5;
}

.card-image {
    height: 180px;
    overflow: hidden;
    position: relative;
}

.room-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s;
}

.room-card:hover .room-image {
    transform: scale(1.05);
}

.card-body {
    padding: 15px;
    flex: 1;
}

.room-name {
    margin: 0 0 8px 0;
    font-size: 18px;
    font-weight: 600;
    color: #1a202c;
}

.room-description {
    margin: 0 0 15px 0;
    font-size: 14px;
    color: #4a5568;
    line-height: 1.5;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.room-meta {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.meta-item {
    display: flex;
    align-items: center;
    font-size: 14px;
    color: #4a5568;
}

.meta-item i {
    color: #3b82f6;
    margin-right: 8px;
    font-size: 16px;
    opacity: 0.8;
}

.card-footer {
    padding: 15px;
    border-top: 1px solid #f1f5f9;
    display: flex;
    justify-content: flex-end;
    align-items: center;
}

.ong-association {
    display: flex;
    align-items: center;
    font-size: 14px;
    color: #4a5568;
    font-weight: 500;
}

.ong-association i {
    color: #e74c3c;
    margin-right: 8px;
    opacity: 0.8;
}

/* Form Styling */
.form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
}

.form-group {
    flex: 1;
    margin-bottom: 20px;
}

.form-group label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
    margin-bottom: 8px;
    color: #2c5282;
    font-size: 14px;
}

.form-group label i {
    color: #3b82f6;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 14px;
    color: #4a5568;
    transition: all 0.3s;
}

.form-group textarea {
    resize: vertical;
    min-height: 80px;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
}

.input-error {
    border-color: #ef4444 !important;
}

.error-message {
    color: #ef4444;
    font-size: 12px;
    display: block;
    margin-top: 5px;
}

.status-toggle {
    display: flex;
    align-items: center;
    gap: 15px;
}

.status-toggle label {
    margin-bottom: 0;
}

.status-toggle-button {
    border-radius: 50px;
}

.image-upload-section {
    margin-top: 20px;
}

.input-options {
    display: flex;
    margin-bottom: 10px;
}

.option-tab {
    flex: 1;
    padding: 8px 12px;
    background-color: #f3f4f6;
    border: 1px solid #e2e8f0;
    color: #4b5563;
    cursor: pointer;
    font-size: 13px;
    transition: all 0.2s;
    max-width: 100px;
}

.option-tab:first-child {
    border-radius: 4px 0 0 4px;
    border-right: none;
}

.option-tab:last-child {
    border-radius: 0 4px 4px 0;
}

.option-tab.active {
    background-color: #ebf5ff;
    color: #3b82f6;
    font-weight: 500;
}

.file-upload-control {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.hidden-file-input {
    display: none;
}

.file-select-button {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 10px 15px;
    background-color: #f3f4f6;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    color: #4b5563;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
}

.file-select-button:hover {
    background-color: #e5e7eb;
}

.file-select-button i {
    color: #3b82f6;
    font-size: 16px;
}

.selected-file-name {
    font-size: 13px;
    color: #6b7280;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    padding: 4px 0;
}

.image-preview {
    width: 100%;
    height: 180px;
    background-color: #f8fafc;
    border-radius: 6px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 15px;
    border: 1px solid #e2e8f0;
}

.image-preview img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

/* Dialog footer buttons */
.dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

.btn-cancel {
    padding: 10px 15px;
    background-color: white;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    color: #718096;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-cancel:hover {
    background-color: #f7fafc;
    color: #4a5568;
}

.btn-save {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 15px;
    background: linear-gradient(135deg, #3b82f6, #1d4ed8);
    border: none;
    border-radius: 6px;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-save:hover {
    box-shadow: 0 4px 8px rgba(59, 130, 246, 0.3);
}

/* Responsive design */
@media (max-width: 768px) {
    .page-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }
    
    .header-content {
        width: 100%;
        margin-bottom: 10px;
    }
    
    .btn-add {
        width: 100%;
        justify-content: center;
    }
    
    .filter-bar {
        flex-direction: column;
        align-items: stretch;
    }
    
    .search-container {
        max-width: 100%;
    }
    
    .form-row {
        flex-direction: column;
        gap: 10px;
    }
}

@media (max-width: 480px) {
    .filter-options {
        width: 100%;
        justify-content: space-between;
    }
    
    .filter-button {
        flex: 1;
        text-align: center;
        padding: 8px 10px;
    }
    
    .rooms-grid {
        grid-template-columns: 1fr;
    }
}
</style>