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
                <i class="pi pi-heart-fill"></i>
            </div>
            <div class="header-content">
                <h2>Gestión de ONGs</h2>
                <p class="header-subtitle">Administre las organizaciones sin fines de lucro asociadas</p>
            </div>
            <button class="btn-add" @click="crearOng">
                <i class="pi pi-plus"></i>
                <span>Nueva ONG</span>
            </button>
        </div>

        <!-- Search and filter bar -->
        <div class="filter-bar">
            <div class="search-container">
                <input 
                    type="text" 
                    v-model="searchQuery" 
                    placeholder="Buscar ONG..." 
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

        <!-- Main content - ONG cards -->
        <div class="ongs-grid">
            <div v-if="filteredOngs.length === 0" class="no-results">
                <i class="pi pi-info-circle"></i>
                <p>No se encontraron ONGs que coincidan con su búsqueda.</p>
            </div>
            
            <div v-for="ong in filteredOngs" :key="ong.ngo_id" class="ong-card">
                <div class="card-header">
                    <div class="status-badge" :class="{ active: ong.is_active }">
                        {{ ong.is_active ? 'Activo' : 'Inactivo' }}
                    </div>
                    <div class="card-actions">
                        <button class="action-button" @click="editOng(ong)" title="Editar ONG">
                            <i class="pi pi-pencil"></i>
                        </button>
                        <button 
                            class="action-button" 
                            :class="ong.is_active ? 'danger' : 'success'"
                            @click="toggleOngStatus(ong)"
                            :title="ong.is_active ? 'Desactivar' : 'Activar'"
                        >
                            <i :class="ong.is_active ? 'pi pi-power-off' : 'pi pi-check-circle'"></i>
                        </button>
                    </div>
                </div>
                
                <div class="card-logo">
                    <a :href="ong.website_url" target="_blank" rel="noopener noreferrer">
                        <img :src="ong.logo_url" :alt="ong.ngo_name" class="logo-image" />
                    </a>
                </div>
                
                <div class="card-body">
                    <h3 class="ong-name">{{ ong.ngo_name }}</h3>
                    <div class="ong-meta">
                        <div class="meta-item">
                            <i class="pi pi-map-marker"></i>
                            <span>{{ ong.country }}</span>
                        </div>
                        <div class="meta-item">
                            <i class="pi pi-phone"></i>
                            <span>{{ ong.phone_number }}</span>
                        </div>
                    </div>
                </div>
                
                <div class="card-footer">
                    <div class="donation-count">
                        <i class="pi pi-chart-bar"></i>
                        <span>{{ ong.total_donations || 0 }} donaciones</span>
                    </div>
                    <button class="view-details" @click="viewOngDetails(ong)">
                        Ver detalles
                    </button>
                </div>
            </div>
        </div>

        <!-- Edit/Create ONG Modal -->
        <Dialog 
            v-model:visible="modalOngVisible" 
            :header="ongToEdit?.ngo_id ? 'Editar ONG' : 'Crear Nueva ONG'" 
            :style="{ width: '700px' }"
            :breakpoints="{ '991px': '90vw' }"
            :modal="true"
            class="ong-dialog"
        >
            <div class="dialog-content" v-if="ongToEdit">
                <div class="form-row">
                    <div class="form-group">
                        <label for="ngo_name">
                            <i class="pi pi-tag"></i>
                            Nombre de la ONG
                        </label>
                        <input 
                            type="text" 
                            id="ngo_name" 
                            v-model="ongToEdit.ngo_name" 
                            :class="{ 'input-error': formErrors.ngo_name }"
                        />
                        <small class="error-message" v-if="formErrors.ngo_name">{{ formErrors.ngo_name }}</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="country">
                            <i class="pi pi-globe"></i>
                            Tema / País
                        </label>
                        <input type="text" id="country" v-model="ongToEdit.country" :class="{ 'input-error': formErrors.country }" />
                        <small class="error-message" v-if="formErrors.country">{{ formErrors.country }}</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">
                        <i class="pi pi-align-left"></i>
                        Descripción
                    </label>
                    <textarea 
                        id="description" 
                        v-model="ongToEdit.description" 
                        rows="4"
                        :class="{ 'input-error': formErrors.description }"
                    ></textarea>
                    <small class="error-message" v-if="formErrors.description">{{ formErrors.description }}</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="email">
                            <i class="pi pi-envelope"></i>
                            Email de contacto
                        </label>
                        <input type="email" id="email" v-model="ongToEdit.email" :class="{ 'input-error': formErrors.email }" />
                        <small class="error-message" v-if="formErrors.email">{{ formErrors.email }}</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">
                            <i class="pi pi-phone"></i>
                            Teléfono
                        </label>
                        <input type="text" id="phone" v-model="ongToEdit.phone_number" :class="{ 'input-error': formErrors.phone_number }" />
                        <small class="error-message" v-if="formErrors.phone_number">{{ formErrors.phone_number }}</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="website">
                        <i class="pi pi-globe"></i>
                        Sitio web
                    </label>
                    <input type="url" id="website" v-model="ongToEdit.website_url" :class="{ 'input-error': formErrors.website_url }" />
                    <small class="error-message" v-if="formErrors.website_url">{{ formErrors.website_url }}</small>
                </div>
                
                <div class="form-group image-upload-section">
                    <label>
                        <i class="pi pi-image"></i>
                        Imágenes
                    </label>
                    
                    <div class="image-inputs">
                        <div class="image-input-group">
                            <label for="logo_url">Logo de la ONG</label>
                            <input type="url" id="logo_url" v-model="ongToEdit.logo_url" :class="{ 'input-error': formErrors.logo_url }" />
                            <small class="error-message" v-if="formErrors.logo_url">{{ formErrors.logo_url }}</small>
                            <div class="image-preview" v-if="ongToEdit.logo_url">
                                <img :src="ongToEdit.logo_url" alt="Logo preview" />
                            </div>
                        </div>
                        
                        <div class="image-input-group">
                            <label for="image_url">Imagen principal</label>
                            <input type="url" id="image_url" v-model="ongToEdit.image_url" :class="{ 'input-error': formErrors.image_url }" />
                            <small class="error-message" v-if="formErrors.image_url">{{ formErrors.image_url }}</small>
                            <div class="image-preview" v-if="ongToEdit.image_url">
                                <img :src="ongToEdit.image_url" alt="Main image preview" />
                            </div>
                        </div>
                        
                        <div class="image-input-group">
                            <label for="description_img_url">Imagen de descripción</label>
                            <input type="url" id="description_img_url" v-model="ongToEdit.description_img_url" :class="{ 'input-error': formErrors.description_img_url }" />
                            <small class="error-message" v-if="formErrors.description_img_url">{{ formErrors.description_img_url }}</small>
                            <div class="image-preview" v-if="ongToEdit.description_img_url">
                                <img :src="ongToEdit.description_img_url" alt="Description image preview" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <template #footer>
                <div class="dialog-footer">
                    <button class="btn-cancel" @click="closeModal">Cancelar</button>
                    <button class="btn-save" @click="guardarOng">
                        <i class="pi pi-check"></i>
                        Guardar ONG
                    </button>
                </div>
            </template>
        </Dialog>

        <!-- Detail view modal -->
        <Dialog 
            v-model:visible="detailsVisible" 
            header="Detalles de la ONG" 
            :style="{ width: '800px' }"
            :breakpoints="{ '991px': '95vw' }"
            :modal="true"
            class="details-dialog"
        >
            <div class="ong-details" v-if="selectedOng">
                <div class="details-header">
                    <div class="details-logo">
                        <img :src="selectedOng.logo_url" :alt="selectedOng.ngo_name" />
                    </div>
                    <div class="details-title">
                        <h2>{{ selectedOng.ngo_name }}</h2>
                        <div class="status-badge" :class="{ active: selectedOng.is_active }">
                            {{ selectedOng.is_active ? 'Activo' : 'Inactivo' }}
                        </div>
                    </div>
                </div>
                
                <div class="details-body">
                    <div class="details-images">
                        <div class="main-image">
                            <img :src="selectedOng.image_url" :alt="selectedOng.ngo_name" />
                        </div>
                        <div class="description-image">
                            <img :src="selectedOng.description_img_url" :alt="selectedOng.ngo_name + ' descripción'" />
                        </div>
                    </div>
                    
                    <div class="details-info">
                        <div class="info-section">
                            <h3>Información General</h3>
                            <p class="description-text">{{ selectedOng.description }}</p>
                            
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label"><i class="pi pi-globe"></i> Tema/País:</div>
                                    <div class="info-value">{{ selectedOng.country }}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label"><i class="pi pi-chart-bar"></i> Donaciones:</div>
                                    <div class="info-value">{{ selectedOng.total_donations || 0 }}</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-section">
                            <h3>Contacto</h3>
                            <div class="info-grid">
                                <div class="info-item">
                                    <div class="info-label"><i class="pi pi-envelope"></i> Email:</div>
                                    <div class="info-value">{{ selectedOng.email }}</div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label"><i class="pi pi-phone"></i> Teléfono:</div>
                                    <div class="info-value">{{ selectedOng.phone_number }}</div>
                                </div>
                                <div class="info-item full-width">
                                    <div class="info-label"><i class="pi pi-globe"></i> Sitio web:</div>
                                    <div class="info-value">
                                        <a :href="selectedOng.website_url" target="_blank" rel="noopener noreferrer">
                                            {{ selectedOng.website_url }}
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <template #footer>
                <div class="dialog-footer">
                    <button class="btn-secondary" @click="detailsVisible = false">Cerrar</button>
                    <button class="btn-primary" @click="editOng(selectedOng)">
                        <i class="pi pi-pencil"></i>
                        Editar ONG
                    </button>
                </div>
            </template>
        </Dialog>
    </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import { useStore } from 'vuex';
import Dialog from 'primevue/dialog';

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

// ONG data handling
const ongs = computed(() => {
    const data = store.getters['storeAdmin/getAllNgos'].data;
    return Array.isArray(data) ? data : [];
});

// Search and filtering
const searchQuery = ref('');
const statusFilter = ref('all');

const filteredOngs = computed(() => {
    let result = [...ongs.value];
    
    // Filter by search term
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(ong => 
            ong.ngo_name.toLowerCase().includes(query) || 
            ong.country.toLowerCase().includes(query) || 
            ong.description?.toLowerCase().includes(query)
        );
    }
    
    // Filter by status
    if (statusFilter.value === 'active') {
        result = result.filter(ong => ong.is_active);
    } else if (statusFilter.value === 'inactive') {
        result = result.filter(ong => !ong.is_active);
    }
    
    return result;
});

// Modal management
const modalOngVisible = ref(false);
const ongToEdit = ref(null);
const formErrors = ref({});

// Details view
const detailsVisible = ref(false);
const selectedOng = ref(null);

const viewOngDetails = (ong) => {
    selectedOng.value = {...ong};
    detailsVisible.value = true;
};

const editOng = (ong) => {
    detailsVisible.value = false;
    ongToEdit.value = {...ong};
    formErrors.value = {};
    modalOngVisible.value = true;
};

const crearOng = () => {
    ongToEdit.value = {
        ngo_name: '',
        description: '',
        country: '',
        email: '',
        phone_number: '',
        logo_url: '',
        image_url: '',
        description_img_url: '',
        website_url: '',
        is_active: true
    };
    formErrors.value = {};
    modalOngVisible.value = true;
};

const closeModal = () => {
    modalOngVisible.value = false;
    formErrors.value = {};
};

const validateOng = () => {
    const errors = {};
    let isValid = true;
    
    if (!ongToEdit.value.ngo_name) {
        errors.ngo_name = 'El nombre es obligatorio';
        isValid = false;
    }
    
    if (!ongToEdit.value.description) {
        errors.description = 'La descripción es obligatoria';
        isValid = false;
    }
    
    if (!ongToEdit.value.country) {
        errors.country = 'El país/tema es obligatorio';
        isValid = false;
    }
    
    if (!ongToEdit.value.email) {
        errors.email = 'El email es obligatorio';
        isValid = false;
    } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(ongToEdit.value.email)) {
        errors.email = 'Email inválido';
        isValid = false;
    }
    
    if (!ongToEdit.value.phone_number) {
        errors.phone_number = 'El teléfono es obligatorio';
        isValid = false;
    }
    
    if (!ongToEdit.value.logo_url) {
        errors.logo_url = 'El logo es obligatorio';
        isValid = false;
    }
    
    if (!ongToEdit.value.image_url) {
        errors.image_url = 'La imagen principal es obligatoria';
        isValid = false;
    }
    
    if (!ongToEdit.value.website_url) {
        errors.website_url = 'El sitio web es obligatorio';
        isValid = false;
    } else if (!/^https?:\/\/.+\..+/.test(ongToEdit.value.website_url)) {
        errors.website_url = 'URL inválida (debe comenzar con http:// o https://)';
        isValid = false;
    }
    
    formErrors.value = errors;
    return isValid;
};

const guardarOng = async () => {
    if (!validateOng()) {
        showToastNotification('Error', 'Por favor, corrija los errores del formulario', 'error');
        return;
    }
    
    try {
        if (ongToEdit.value.ngo_id) {
            await store.dispatch('storeAdmin/updateNgo', ongToEdit.value);
            showToastNotification('Éxito', `ONG "${ongToEdit.value.ngo_name}" actualizada correctamente`, 'success');
        } else {
            await store.dispatch('storeAdmin/fetchCreateNgo', ongToEdit.value);
            showToastNotification('Éxito', `ONG "${ongToEdit.value.ngo_name}" creada correctamente`, 'success');
        }
        modalOngVisible.value = false;
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al guardar la ONG', 'error');
    }
};

const toggleOngStatus = async (ong) => {
    try {
        const updatedOng = {...ong};
        updatedOng.is_active = !updatedOng.is_active;
        
        if (updatedOng.is_active) {
            await store.dispatch('storeAdmin/enableNgo', updatedOng.ngo_slug);
            showToastNotification('Éxito', `ONG "${updatedOng.ngo_name}" activada correctamente`, 'success');
        } else {
            await store.dispatch('storeAdmin/disableNgo', updatedOng.ngo_slug);
            showToastNotification('Éxito', `ONG "${updatedOng.ngo_name}" desactivada correctamente`, 'success');
        }
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al cambiar el estado de la ONG', 'error');
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
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 24px;
    box-shadow: 0 4px 10px rgba(231, 76, 60, 0.3);
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
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    color: white;
    border: none;
    padding: 10px 15px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    font-size: 14px;
    box-shadow: 0 4px 6px rgba(231, 76, 60, 0.2);
    transition: all 0.3s;
}

.btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 10px rgba(231, 76, 60, 0.3);
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

.search-container i {
    position: absolute;
    left: 12px;
    top: 50%;
    transform: translateY(-50%);
    color: #a0aec0;
}

.search-input {
    width: 100%;
    padding: 12px 12px 12px 40px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    background-color: white;
    font-size: 14px;
    color: #4a5568;
    transition: all 0.3s;
}

.search-input:focus {
    outline: none;
    border-color: #e74c3c;
    box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.15);
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
    background-color: #fef2f2;
    color: #e74c3c;
    border-color: #fad7d7;
    font-weight: 500;
}

/* ONG Cards Grid */
.ongs-grid {
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

.ong-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
    overflow: hidden;
    transition: all 0.3s;
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
}

.ong-card:hover {
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

.card-logo {
    height: 150px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background-color: #f8fafc;
    overflow: hidden;
}

.logo-image {
    max-width: 100%;
    max-height: 120px;
    object-fit: contain;
    transition: transform 0.3s;
}

.card-logo:hover .logo-image {
    transform: scale(1.05);
}

.card-body {
    padding: 15px;
    flex: 1;
}

.ong-name {
    margin: 0 0 10px 0;
    font-size: 18px;
    font-weight: 600;
    color: #1a202c;
}

.ong-meta {
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
    color: #e74c3c;
    margin-right: 8px;
    font-size: 16px;
    opacity: 0.8;
}

.card-footer {
    padding: 15px;
    border-top: 1px solid #f1f5f9;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.donation-count {
    display: flex;
    align-items: center;
    font-size: 14px;
    color: #4a5568;
}

.donation-count i {
    color: #e74c3c;
    margin-right: 8px;
    opacity: 0.8;
}

.view-details {
    background: none;
    border: none;
    color: #e74c3c;
    font-weight: 500;
    font-size: 14px;
    cursor: pointer;
    transition: color 0.2s;
}

.view-details:hover {
    color: #c0392b;
    text-decoration: underline;
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
    color: #e74c3c;
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
    min-height: 100px;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #e74c3c;
    box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.15);
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

.image-upload-section {
    margin-top: 20px;
}

.image-inputs {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    margin-top: 10px;
}

.image-input-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.image-input-group label {
    font-size: 13px;
    color: #4a5568;
    font-weight: 500;
}

.image-preview {
    width: 100%;
    height: 120px;
    background-color: #f8fafc;
    border-radius: 6px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 8px;
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
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    border: none;
    border-radius: 6px;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-save:hover {
    box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
}

/* Details dialog */
.ong-details {
    color: #2d3748;
}

.details-header {
    display: flex;
    align-items: center;
    margin-bottom: 25px;
    gap: 20px;
}

.details-logo {
    width: 100px;
    height: 100px;
    border-radius: 10px;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    background-color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 10px;
}

.details-logo img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

.details-title {
    flex: 1;
}

.details-title h2 {
    margin: 0 0 10px 0;
    font-size: 22px;
    font-weight: 600;
    color: #1a202c;
}

.details-body {
    display: flex;
    flex-direction: column;
    gap: 30px;
}

.details-images {
    display: flex;
    gap: 20px;
    height: 200px;
}

.main-image, .description-image {
    flex: 1;
    background-color: #f8fafc;
    border-radius: 10px;
    overflow: hidden;
    border: 1px solid #e2e8f0;
    display: flex;
    align-items: center;
    justify-content: center;
}

.main-image img, .description-image img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}

.details-info {
    display: flex;
    flex-direction: column;
    gap: 25px;
}

.info-section {
    background-color: #f8fafc;
    border-radius: 10px;
    padding: 20px;
    border: 1px solid #e2e8f0;
}

.info-section h3 {
    margin: 0 0 15px 0;
    font-size: 18px;
    font-weight: 500;
    color: #1a202c;
    padding-bottom: 10px;
    border-bottom: 1px solid #e2e8f0;
}

.description-text {
    font-size: 14px;
    line-height: 1.6;
    color: #4a5568;
    margin: 0 0 20px 0;
}

.info-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
}

.info-item {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.info-item.full-width {
    grid-column: 1 / -1;
}

.info-label {
    font-size: 13px;
    font-weight: 500;
    color: #718096;
    display: flex;
    align-items: center;
    gap: 8px;
}

.info-label i {
    color: #e74c3c;
    opacity: 0.8;
}

.info-value {
    font-size: 14px;
    color: #1a202c;
}

.info-value a {
    color: #e74c3c;
    text-decoration: none;
}

.info-value a:hover {
    text-decoration: underline;
}

.btn-primary, .btn-secondary {
    padding: 10px 15px;
    border-radius: 6px;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-primary {
    display: flex;
    align-items: center;
    gap: 8px;
    background: linear-gradient(135deg, #e74c3c, #c0392b);
    border: none;
    color: white;
    font-weight: 500;
}

.btn-primary:hover {
    box-shadow: 0 4px 8px rgba(231, 76, 60, 0.3);
}

.btn-secondary {
    background-color: white;
    border: 1px solid #e2e8f0;
    color: #718096;
}

.btn-secondary:hover {
    background-color: #f7fafc;
    color: #4a5568;
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
    
    .details-header {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
    
    .details-images {
        flex-direction: column;
        height: auto;
        gap: 15px;
    }
    
    .main-image, .description-image {
        height: 150px;
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
    
    .ongs-grid {
        grid-template-columns: 1fr;
    }
}
</style>