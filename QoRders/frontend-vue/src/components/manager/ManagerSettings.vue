<template>
    <div class="settings-container">
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
        <div class="settings-header">
            <div class="header-icon">
                <i class="pi pi-cog"></i>
            </div>
            <div class="header-content">
                <h2>Ajustes de Perfil</h2>
                <p class="header-subtitle">Actualice su información personal y preferencias</p>
            </div>
        </div>

        <div class="settings-card">
            <form @submit.prevent="handleSubmit" class="settings-form">
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">
                            <i class="pi pi-user"></i>
                            Nombre
                        </label>
                        <input type="text" id="firstName" v-model="form.firstName" placeholder="Introduce tu nombre" />
                    </div>

                    <div class="form-group">
                        <label for="lastName">
                            <i class="pi pi-id-card"></i>
                            Apellido
                        </label>
                        <input type="text" id="lastName" v-model="form.lastName" placeholder="Introduce tu apellido" />
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone_number">
                            <i class="pi pi-phone"></i>
                            Número de Teléfono
                        </label>
                        <input type="text" id="phone_number" v-model="form.phone_number"
                            placeholder="Introduce tu número de teléfono" />
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class="pi pi-envelope"></i>
                            Email
                        </label>
                        <input type="email" id="email" v-model="form.email" placeholder="Email" disabled />
                        <small class="input-help">El email no puede modificarse</small>
                    </div>
                </div>
                <div class="form-row avatar-row">
                    <div class="form-group avatar-upload-group">
                        <label for="avatar_url">
                            <i class="pi pi-image"></i>
                            Imagen de Perfil
                        </label>
                        <div class="avatar-container">
                            <div class="avatar-preview" v-if="imagePreview">
                                <img :src="imagePreview" alt="Vista previa" class="avatar-image" />
                                <button type="button" class="remove-image" @click="removeImage" title="Quitar imagen">
                                    <i class="pi pi-times"></i>
                                </button>
                            </div>
                            <div class="avatar-upload" @click="triggerFileInput">
                                <div class="upload-icon-container">
                                    <i class="pi pi-camera"></i>
                                </div>
                                <span class="upload-text">{{ imagePreview ? 'Cambiar imagen' : 'Seleccionar imagen' }}</span>
                                <div class="upload-info">
                                    <small>Formatos: JPG, PNG, GIF, WEBP (máx 2MB)</small>
                                </div>
                            </div>
                        </div>
                        <input 
                            type="file" 
                            ref="fileInput" 
                            class="hidden-file-input" 
                            accept="image/jpeg, image/png, image/gif, image/webp"
                            @change="handleImageChange" 
                        />
                        <input type="hidden" id="avatar_url" v-model="form.avatar_url" />
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="bio">
                        <i class="pi pi-info-circle"></i>
                        Biografía
                    </label>
                    <textarea id="bio" v-model="form.bio" placeholder="Introduce una breve descripción sobre ti y tu experiencia"></textarea>
                    <small class="input-help">La biografía aparecerá en tu perfil público</small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="pi pi-check"></i>
                        Guardar Cambios
                    </button>
                </div>
            </form>
        </div>
        
        <Modal v-model:visible="isModalVisible" :message="modalMessage" :title="modalTitle" />
    </div>
</template>
<script setup>
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import Modal from '../Modal.vue';

const store = useStore();
// Ya no necesitamos el modal, pero mantenemos la importación por compatibilidad
const isModalVisible = ref(false); 
const modalMessage = ref('');
const modalTitle = ref('');
const fileInput = ref(null);
const imagePreview = ref('');

// Variables para el toast
const showToast = ref(false);
const toastMessage = ref('');
const toastTitle = ref('');
const toastType = ref('success');
const toastTimeout = ref(null);

// Icono del toast basado en el tipo
const toastIcon = computed(() => {
    return toastType.value === 'success' ? 'pi pi-check-circle' : 
           toastType.value === 'info' ? 'pi pi-info-circle' : 'pi pi-exclamation-triangle';
});

const managerData = store.getters['storeAuth/getUserData'];
const originalForm = ref({});

const form = ref({
    firstName: managerData.firstName || '',
    lastName: managerData.lastName || '',
    phone_number: managerData.phone_number || '',
    email: managerData.email || '',
    avatar_url: managerData.avatar_url || '',
    bio: managerData.bio || '',
    salary: managerData.salary || '',
});

onMounted(() => {
    // Guardar los valores originales para poder resetear el formulario
    originalForm.value = { ...form.value };
    
    // Inicializar vista previa de imagen si existe
    if (form.value.avatar_url) {
        imagePreview.value = form.value.avatar_url;
    }
});

// Función para mostrar el toast
const showToastNotification = (title, message, type = 'success') => {
    // Limpiar cualquier toast anterior
    if (toastTimeout.value) {
        clearTimeout(toastTimeout.value);
    }
    
    toastTitle.value = title;
    toastMessage.value = message;
    toastType.value = type;
    showToast.value = true;
    
    // Auto ocultar después de 5 segundos
    toastTimeout.value = setTimeout(() => {
        hideToast();
    }, 5000);
};

// Función para ocultar el toast
const hideToast = () => {
    showToast.value = false;
};

// Función para abrir el selector de archivos
const triggerFileInput = () => {
    fileInput.value.click();
};

// Función para eliminar la imagen
const removeImage = () => {
    imagePreview.value = '';
    form.value.avatar_url = '';
    if (fileInput.value) {
        fileInput.value.value = '';  // Limpiar el input file
    }
};

// Función para manejar la selección de imagen
const handleImageChange = (event) => {
    const file = event.target.files[0];
    if (!file) return;
    
    // Verificar tamaño (2MB máximo)
    if (file.size > 2 * 1024 * 1024) {
        showToastNotification('Error', 'La imagen es demasiado grande. El tamaño máximo es 2MB.', 'error');
        return;
    }
    
    // Resto del código de handleImageChange sin cambios
    // ...
};

const resetForm = () => {
    form.value = { ...originalForm.value };
    // Restablecer también la vista previa de la imagen
    imagePreview.value = form.value.avatar_url;
};

const handleSubmit = async () => {
    try {
        // Si la imagen es demasiado grande, comprimir más
        if (form.value.avatar_url && form.value.avatar_url.length > 500000) {
            showToastNotification('Procesando', 'Optimizando imagen para mejor rendimiento...', 'info');
            
            const img = new Image();
            img.onload = async () => {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                
                // Dimensiones más pequeñas
                canvas.width = 250;
                canvas.height = 250;
                
                // Dibujar con suavizado
                ctx.drawImage(img, 0, 0, 250, 250);
                
                // Mayor compresión
                form.value.avatar_url = canvas.toDataURL('image/jpeg', 0.5);
                
                // Ahora enviar los datos
                await submitForm();
            };
            img.src = imagePreview.value;
        } else {
            await submitForm();
        }
    } catch (error) {
        showToastNotification('Error', 'Ha ocurrido un error al actualizar tu perfil.', 'error');
    }
};

const submitForm = async () => {
    try {
        await store.dispatch('storeAuth/updateUser', form.value);
        showToastNotification('¡Éxito!', 'Tus datos se han actualizado correctamente.', 'success');
        
        // Actualizar los valores originales después de un guardado exitoso
        originalForm.value = { ...form.value };
    } catch (error) {
        showToastNotification('Error', 'No se pudieron actualizar los datos. Inténtalo de nuevo.', 'error');
    }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap');

.settings-container {
    font-family: 'Inter', sans-serif;
    width: 100%;
    padding: 20px;
    background-color: #f8fafc;
    color: #2d3748;
}

.settings-header {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-bottom: 30px;
    padding-bottom: 15px;
    border-bottom: 1px solid #e2e8f0;
}

.header-icon {
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, #2c5282, #3182ce);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
    box-shadow: 0 4px 10px rgba(49, 130, 206, 0.3);
}

.header-content h2 {
    font-size: 1.6rem;
    font-weight: 600;
    color: #1a365d;
    margin: 0 0 5px 0;
}

.header-subtitle {
    font-size: 0.95rem;
    color: #4a5568;
    margin: 0;
}

.settings-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    padding: 25px;
    border: 1px solid #e2e8f0;
}

.settings-form {
    width: 100%;
    max-width: 100%;
}

.form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 5px;
}

.form-group {
    flex: 1;
    margin-bottom: 20px;
}

.form-group.full-width {
    width: 100%;
}

.form-group label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-weight: 500;
    margin-bottom: 8px;
    color: #2c5282;
    font-size: 0.95rem;
}

.form-group label i {
    color: #3182ce;
    font-size: 1rem;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 0.95rem;
    color: #4a5568;
    transition: all 0.3s ease;
    font-family: 'Inter', sans-serif;
}

.form-group textarea {
    height: 120px;
    resize: vertical;
    line-height: 1.5;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #3182ce;
    box-shadow: 0 0 0 2px rgba(49, 130, 206, 0.2);
}

.form-group input:disabled {
    background-color: #f7fafc;
    color: #718096;
    cursor: not-allowed;
    border: 1px dashed #cbd5e0;
}

.input-help {
    display: block;
    font-size: 0.8rem;
    color: #718096;
    margin-top: 5px;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 15px;
    margin-top: 20px;
    padding-top: 20px;
    border-top: 1px solid #e2e8f0;
}

.btn-submit, 
.btn-cancel {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 12px 20px;
    border-radius: 6px;
    font-weight: 500;
    font-size: 0.95rem;
    transition: all 0.3s ease;
    cursor: pointer;
}

.btn-submit {
    background: linear-gradient(135deg, #2c5282, #3182ce);
    color: white;
    border: none;
    box-shadow: 0 4px 6px rgba(49, 130, 206, 0.25);
}

.btn-submit:hover {
    background: linear-gradient(135deg, #1a365d, #2c5282);
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(49, 130, 206, 0.3);
}

.btn-cancel {
    background-color: white;
    color: #718096;
    border: 1px solid #e2e8f0;
}

.btn-cancel:hover {
    background-color: #f8fafc;
    color: #4a5568;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

/* Estilos para el selector de avatar */
.avatar-row {
    margin-bottom: 25px;
}

.avatar-upload-group {
    width: 100%;
}

.avatar-container {
    display: flex;
    align-items: center;
    gap: 20px;
    margin-top: 10px;
}

.avatar-preview {
    position: relative;
    width: 120px;
    height: 120px;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(49, 130, 206, 0.2);
    border: 3px solid #3182ce;
}

.avatar-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.remove-image {
    position: absolute;
    top: 5px;
    right: 5px;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.9);
    border: none;
    color: #e53e3e;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s ease;
}

.remove-image:hover {
    background-color: #e53e3e;
    color: white;
}

.avatar-upload {
    flex: 1;
    padding: 20px;
    border: 2px dashed #e2e8f0;
    border-radius: 8px;
    background-color: #f8fafc;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
}

.avatar-upload:hover {
    border-color: #3182ce;
    background-color: #ebf8ff;
}

.upload-icon-container {
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, #2c5282, #3182ce);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 12px;
    color: white;
    font-size: 20px;
}

.upload-text {
    font-weight: 500;
    color: #2c5282;
    margin-bottom: 8px;
}

.upload-info small {
    color: #718096;
    font-size: 12px;
}

.hidden-file-input {
    display: none;
}
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
    padding-top: 2px;
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
    transition: color 0.2s;
    padding: 0;
    margin-left: 8px;
}

.toast-close:hover {
    color: #4b5563;
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

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
        gap: 0;
    }
    .avatar-container {
        flex-direction: column;
        align-items: center;
    }
    
    .avatar-upload {
        width: 100%;
        margin-top: 15px;
    }
    .settings-header {
        flex-direction: column;
        align-items: flex-start;
    }
    
    .header-icon {
        margin-bottom: 10px;
    }
    
    .settings-card {
        padding: 20px 15px;
    }
    
    .form-actions {
        flex-direction: column-reverse;
    }
    
    .btn-submit, 
    .btn-cancel {
        width: 100%;
        justify-content: center;
    }
}
</style>