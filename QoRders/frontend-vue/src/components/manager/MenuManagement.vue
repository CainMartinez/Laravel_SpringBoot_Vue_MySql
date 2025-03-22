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
                <i class="pi pi-apple"></i>
            </div>
            <div class="header-content">
                <h2>Gestión de la Carta</h2>
                <p class="header-subtitle">Administre los platos y bebidas disponibles en cada sala</p>
            </div>
            <button class="btn-add" @click="crearProducto">
                <i class="pi pi-plus"></i>
                <span>Nuevo Producto</span>
            </button>
        </div>

        <!-- Room tabs navigation -->
        <div class="rooms-tabs">
            <div class="tab-header">
                <button 
                    v-for="room in rooms" 
                    :key="room.room_id" 
                    class="tab-button" 
                    :class="{ active: roomSelected === room.room_id }"
                    @click="changeRoom(room.room_id)"
                >
                    <i class="pi pi-building"></i>
                    <span>{{ room.room_name }}</span>
                </button>
            </div>
            
            <!-- Filter and search -->
            <div class="tab-actions">
                <div class="search-container">
                    <input 
                        type="text" 
                        v-model="searchQuery" 
                        placeholder="Buscar producto..." 
                        class="search-input"
                    />
                </div>
                <div class="filter-options">
                    <button 
                        v-for="type in productTypes" 
                        :key="type.value"
                        class="filter-button" 
                        :class="{ active: typeFilter === type.value }" 
                        @click="typeFilter = type.value"
                    >
                        {{ type.label }}
                    </button>
                </div>
            </div>
        </div>

        <!-- Products grid -->
        <div class="products-grid">
            <div v-if="filteredProducts.length === 0" class="no-results">
                <i class="pi pi-info-circle"></i>
                <p>No se encontraron productos que coincidan con su búsqueda.</p>
            </div>
            
            <div v-for="product in filteredProducts" :key="product.product_id" class="product-card">
                <div class="card-header">
                    <div class="product-type">
                        {{ product.product_type }}
                    </div>
                    <div class="card-actions">
                        <button class="action-button" @click="editProduct(product)" title="Editar producto">
                            <i class="pi pi-pencil"></i>
                        </button>
                        <button 
                            class="action-button" 
                            @click="toggleProductAvailability(product)"
                            :title="product.stock > 0 ? 'Marcar sin stock' : 'Restablecer stock'"
                            :class="product.stock > 0 ? 'danger' : 'success'"
                        >
                            <i :class="product.stock > 0 ? 'pi pi-ban' : 'pi pi-check-circle'"></i>
                        </button>
                    </div>
                </div>
                
                <div class="card-image">
                    <img :src="product.image_url" :alt="product.product_name" class="product-image" />
                    <div class="price-tag">
                        {{ formatCurrency(product.unit_price) }}
                    </div>
                </div>
                
                <div class="card-body">
                    <h3 class="product-name">{{ product.product_name }}</h3>
                    <p class="product-description">{{ product.description }}</p>
                </div>
                
                <div class="card-footer">
                    <div class="stock-indicator" :class="{ 'out-of-stock': product.stock <= 0 }">
                        <i :class="product.stock > 0 ? 'pi pi-check-circle' : 'pi pi-times-circle'"></i>
                        <span>{{ product.stock > 0 ? `Stock: ${product.stock}` : 'Sin stock' }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit/Create Product Modal -->
        <Dialog 
            v-model:visible="modalProductoVisible" 
            :header="producToEdit?.product_id ? 'Editar Producto' : 'Crear Nuevo Producto'" 
            :style="{ width: '700px' }"
            :breakpoints="{ '991px': '90vw' }"
            :modal="true"
            class="product-dialog"
        >
            <div class="dialog-content" v-if="producToEdit">
                <div class="form-row">
                    <div class="form-group">
                        <label for="product_name">
                            <i class="pi pi-tag"></i>
                            Nombre del producto
                        </label>
                        <InputText 
                            id="product_name" 
                            v-model="producToEdit.product_name" 
                            :class="{ 'input-error': formErrors.product_name }"
                        />
                        <small class="error-message" v-if="formErrors.product_name">{{ formErrors.product_name }}</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="product_type">
                            <i class="pi pi-list"></i>
                            Tipo de producto
                        </label>
                        <Select 
                            id="product_type" 
                            v-model="producToEdit.product_type" 
                            :options="productTypes" 
                            optionLabel="label" 
                            optionValue="value"
                            placeholder="Seleccione un tipo"
                            :class="{ 'input-error': formErrors.product_type }"
                        />
                        <small class="error-message" v-if="formErrors.product_type">{{ formErrors.product_type }}</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">
                        <i class="pi pi-align-left"></i>
                        Descripción
                    </label>
                    <textarea 
                        id="description" 
                        v-model="producToEdit.description" 
                        rows="3"
                        :class="{ 'input-error': formErrors.description }"
                    ></textarea>
                    <small class="error-message" v-if="formErrors.description">{{ formErrors.description }}</small>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="unit_price">
                            <i class="pi pi-euro"></i>
                            Precio unitario
                        </label>
                        <InputNumber 
                            id="unit_price" 
                            v-model="producToEdit.unit_price" 
                            mode="currency" 
                            currency="EUR" 
                            locale="es-ES"
                            :minFractionDigits="2"
                            :class="{ 'input-error': formErrors.unit_price }"
                        />
                        <small class="error-message" v-if="formErrors.unit_price">{{ formErrors.unit_price }}</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="stock">
                            <i class="pi pi-inbox"></i>
                            Stock disponible
                        </label>
                        <InputNumber 
                            id="stock" 
                            v-model="producToEdit.stock" 
                            showButtons 
                            :step="1"
                            :min="0"
                            :class="{ 'input-error': formErrors.stock }"
                        />
                        <small class="error-message" v-if="formErrors.stock">{{ formErrors.stock }}</small>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="origin">
                        <i class="pi pi-building"></i>
                        Sala / Origen
                    </label>
                    <Select 
                        id="origin" 
                        v-model="producToEdit.origin" 
                        :options="rooms" 
                        optionLabel="theme" 
                        optionValue="theme"
                        placeholder="Seleccione sala de origen"
                        :class="{ 'input-error': formErrors.origin }"
                    />
                    <small class="error-message" v-if="formErrors.origin">{{ formErrors.origin }}</small>
                </div>
                
                <div class="form-group image-upload-section">
                    <label>
                        <i class="pi pi-image"></i>
                        Imagen del producto
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
                        v-model="producToEdit.image_url" 
                        :class="{ 'input-error': formErrors.image_url }" 
                        placeholder="https://ejemplo.com/imagen.jpg"
                    />
                    
                    <div v-else class="file-upload-control">
                        <input 
                            type="file" 
                            id="product_image_file" 
                            ref="productImageFileInput"
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
                            {{ getFileNameFromUrl(producToEdit.image_url) || 'Ningún archivo seleccionado' }}
                        </span>
                    </div>
                    
                    <small class="error-message" v-if="formErrors.image_url">{{ formErrors.image_url }}</small>
                    
                    <div class="image-preview" v-if="producToEdit.image_url">
                        <img :src="producToEdit.image_url" alt="Vista previa" />
                    </div>
                </div>
            </div>
            
            <template #footer>
                <div class="dialog-footer">
                    <button class="btn-cancel" @click="closeModal">Cancelar</button>
                    <button class="btn-save" @click="saveProduct">
                        <i class="pi pi-check"></i>
                        Guardar Producto
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
import InputText from 'primevue/inputtext';
import InputNumber from 'primevue/inputnumber';
import Select from 'primevue/select';

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

// Product Types
const productTypes = [
    { label: 'Todos', value: 'all' },
    { label: 'Entrante', value: 'entrante' },
    { label: 'Principal', value: 'principal' },
    { label: 'Postre', value: 'postre' },
    { label: 'Bebida', value: 'bebida' }
];

// Data sources
const rooms = computed(() => {
    const data = store.getters['storeAdmin/getAllRooms'].data;
    return Array.isArray(data) ? data : [];
});

const products = computed(() => {
    const data = store.getters['storeAdmin/getAllProducts'].data;
    return Array.isArray(data) ? data : [];
});

// Current room selection
const roomSelected = ref(rooms.value && rooms.value.length > 0 ? rooms.value[0].room_id : null);

// Search and filtering
const searchQuery = ref('');
const typeFilter = ref('all');

// Watch for rooms data to set initial room
watch(() => rooms.value, (newRooms) => {
    if (newRooms && newRooms.length > 0 && !roomSelected.value) {
        roomSelected.value = newRooms[0].room_id;
    }
}, { immediate: true });

const filteredProducts = computed(() => {
    if (!rooms.value || rooms.value.length === 0) return [];
    
    const currentRoom = rooms.value.find(r => r.room_id === roomSelected.value);
    if (!currentRoom) return [];
    
    let result = products.value.filter(p => p.origin === currentRoom.theme);
    
    // Filter by search term
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(product => 
            product.product_name.toLowerCase().includes(query) || 
            product.description.toLowerCase().includes(query)
        );
    }
    
    // Filter by product type
    if (typeFilter.value !== 'all') {
        result = result.filter(product => product.product_type === typeFilter.value);
    }
    
    return result;
});

const changeRoom = (roomId) => {
    roomSelected.value = roomId;
};

// Modal and form management
const modalProductoVisible = ref(false);
const producToEdit = ref(null);
const formErrors = ref({});

// Image upload controls
const imageInputType = ref('url');
const productImageFileInput = ref(null);

const triggerFileInput = () => {
    productImageFileInput.value.click();
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
            
            // Asignar a la imagen del producto
            producToEdit.value.image_url = dataUrl;
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

const formatCurrency = (value) => {
    return new Intl.NumberFormat('es-ES', {
        style: 'currency',
        currency: 'EUR'
    }).format(value);
};

const editProduct = (product) => {
    producToEdit.value = {...product};
    imageInputType.value = 'url';
    formErrors.value = {};
    modalProductoVisible.value = true;
};

const crearProducto = () => {
    // Obtener la sala actual
    const currentRoom = rooms.value.find(r => r.room_id === roomSelected.value);
    
    producToEdit.value = {
        product_name: '',
        description: '',
        product_type: '',
        origin: currentRoom ? currentRoom.theme : '',
        unit_price: 0,
        stock: 0,
        image_url: ''
    };
    imageInputType.value = 'url';
    formErrors.value = {};
    modalProductoVisible.value = true;
};

const closeModal = () => {
    modalProductoVisible.value = false;
    formErrors.value = {};
};

const validateProduct = () => {
    const errors = {};
    let isValid = true;
    
    if (!producToEdit.value.product_name) {
        errors.product_name = 'El nombre es obligatorio';
        isValid = false;
    }
    
    if (!producToEdit.value.description) {
        errors.description = 'La descripción es obligatoria';
        isValid = false;
    }
    
    if (!producToEdit.value.product_type) {
        errors.product_type = 'El tipo de producto es obligatorio';
        isValid = false;
    }
    
    if (!producToEdit.value.origin) {
        errors.origin = 'La sala de origen es obligatoria';
        isValid = false;
    }
    
    if (!producToEdit.value.unit_price || producToEdit.value.unit_price <= 0) {
        errors.unit_price = 'El precio debe ser mayor que 0';
        isValid = false;
    }
    
    if (producToEdit.value.stock === null || producToEdit.value.stock === undefined) {
        errors.stock = 'El stock es obligatorio';
        isValid = false;
    }
    
    if (!producToEdit.value.image_url) {
        errors.image_url = 'La imagen es obligatoria';
        isValid = false;
    }
    
    formErrors.value = errors;
    return isValid;
};

const saveProduct = async () => {
    if (!validateProduct()) {
        showToastNotification('Error', 'Por favor, corrija los errores del formulario', 'error');
        return;
    }
    
    try {
        if (producToEdit.value.product_id) {
            await store.dispatch('storeAdmin/updateProduct', producToEdit.value);
            showToastNotification('Éxito', `Producto "${producToEdit.value.product_name}" actualizado correctamente`, 'success');
        } else {
            await store.dispatch('storeAdmin/createProduct', producToEdit.value);
            showToastNotification('Éxito', `Producto "${producToEdit.value.product_name}" creado correctamente`, 'success');
        }
        modalProductoVisible.value = false;
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al guardar el producto', 'error');
        console.error(error);
    }
};

const toggleProductAvailability = async (product) => {
    try {
        const updatedProduct = {...product};
        
        if (updatedProduct.stock > 0) {
            // Si tiene stock, ponerlo a 0
            updatedProduct.stock = 0;
            await store.dispatch('storeAdmin/updateProduct', updatedProduct);
            showToastNotification('Éxito', `Producto "${updatedProduct.product_name}" marcado sin stock`, 'success');
        } else {
            // Si no tiene stock, ponerlo a 1
            updatedProduct.stock = 1;
            await store.dispatch('storeAdmin/updateProduct', updatedProduct);
            showToastNotification('Éxito', `Stock de "${updatedProduct.product_name}" restablecido`, 'success');
        }
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al cambiar el stock del producto', 'error');
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
    background: linear-gradient(135deg, #10b981, #047857);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 24px;
    box-shadow: 0 4px 10px rgba(16, 185, 129, 0.3);
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
    background: linear-gradient(135deg, #10b981, #047857);
    color: white;
    border: none;
    padding: 10px 15px;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 500;
    font-size: 14px;
    box-shadow: 0 4px 6px rgba(16, 185, 129, 0.2);
    transition: all 0.3s;
}

.btn-add:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 10px rgba(16, 185, 129, 0.3);
}

.btn-add i {
    margin-right: 8px;
}

/* Room tabs */
.rooms-tabs {
    margin-bottom: 30px;
}

.tab-header {
    display: flex;
    gap: 2px;
    border-bottom: 1px solid #e2e8f0;
    overflow-x: auto;
    padding-bottom: 1px;
    scrollbar-width: thin;
}

.tab-header::-webkit-scrollbar {
    height: 6px;
}

.tab-header::-webkit-scrollbar-thumb {
    background-color: #cbd5e0;
    border-radius: 3px;
}

.tab-button {
    padding: 12px 20px;
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
    border-bottom: none;
    border-radius: 6px 6px 0 0;
    color: #718096;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
    white-space: nowrap;
    display: flex;
    align-items: center;
    gap: 8px;
}

.tab-button i {
    font-size: 16px;
    color: #10b981;
}

.tab-button:hover {
    background-color: #edf2f7;
}

.tab-button.active {
    background-color: white;
    color: #10b981;
    border-color: #e2e8f0;
    position: relative;
}

.tab-button.active::after {
    content: '';
    position: absolute;
    bottom: -1px;
    left: 0;
    right: 0;
    height: 2px;
    background-color: white;
}

.tab-button.active::before {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 2px;
    background-color: #10b981;
    z-index: 1;
}

.tab-actions {
    display: flex;
    justify-content: space-between;
    padding: 20px 0 0;
    flex-wrap: wrap;
    gap: 15px;
}

.search-container {
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
    border-color: #10b981;
    box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
}

.filter-options {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
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
    background-color: #ecfdf5;
    color: #10b981;
    border-color: #d1fae5;
    font-weight: 500;
}

/* Products Grid */
.products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
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

.product-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
    overflow: hidden;
    transition: all 0.3s;
    display: flex;
    flex-direction: column;
    border: 1px solid #e2e8f0;
}

.product-card:hover {
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

.product-type {
    background-color: #f0fff4;
    color: #10b981;
    font-size: 12px;
    font-weight: 500;
    padding: 4px 8px;
    border-radius: 4px;
    text-transform: capitalize;
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

.product-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s;
}

.product-card:hover .product-image {
    transform: scale(1.05);
}

.price-tag {
    position: absolute;
    bottom: 10px;
    right: 10px;
    background-color: rgba(16, 185, 129, 0.9);
    color: white;
    padding: 5px 10px;
    border-radius: 4px;
    font-weight: 600;
    font-size: 14px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.card-body {
    padding: 15px;
    flex: 1;
}

.product-name {
    margin: 0 0 8px 0;
    font-size: 16px;
    font-weight: 600;
    color: #1a202c;
}

.product-description {
    margin: 0;
    font-size: 14px;
    color: #4a5568;
    line-height: 1.4;
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.card-footer {
    padding: 15px;
    border-top: 1px solid #f1f5f9;
}

.stock-indicator {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 14px;
    color: #10b981;
    font-weight: 500;
}

.stock-indicator.out-of-stock {
    color: #ef4444;
}

.stock-indicator i {
    font-size: 16px;
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
    color: #10b981;
}

.form-group input,
.form-group textarea,
.form-group .p-inputtext,
.form-group .p-dropdown {
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
.form-group textarea:focus,
.form-group .p-inputtext:focus {
    outline: none;
    border-color: #10b981;
    box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.15);
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
    background-color: #ecfdf5;
    color: #10b981;
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
    color: #10b981;
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
    background: linear-gradient(135deg, #10b981, #047857);
    border: none;
    border-radius: 6px;
    color: white;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-save:hover {
    box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
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
    
    .tab-actions {
        flex-direction: column;
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
        justify-content: center;
        flex-wrap: wrap;
    }
    
    .filter-button {
        flex: 1;
        min-width: 80px;
        text-align: center;
        padding: 8px 10px;
    }
    
    .products-grid {
        grid-template-columns: 1fr;
    }
}
</style>