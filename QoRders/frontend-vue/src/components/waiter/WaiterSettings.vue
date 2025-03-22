<template>
    <div class="settings-container">
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
            <i class="pi pi-cog"></i>
            <h2>Ajustes de Perfil</h2>
        </div>
        
        <form @submit.prevent="handleSubmit" class="settings-form">
            <div class="form-section">
                <h3>Información Personal</h3>
                
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
                            <i class="pi pi-user-plus"></i>
                            Apellido
                        </label>
                        <input type="text" id="lastName" v-model="form.lastName" placeholder="Introduce tu apellido" />
                    </div>
                </div>

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
                    <small class="field-info">El email no puede ser modificado</small>
                </div>
            </div>
            <div class="form-section">
                <h3>Perfil Público</h3>
                
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
            
                <div class="form-group">
                    <label for="bio">
                        <i class="pi pi-info-circle"></i>
                        Biografía
                    </label>
                    <textarea id="bio" v-model="form.bio" placeholder="Introduce tu biografía"></textarea>
                </div>
            </div>

            <div class="form-section" v-if="waiterData.userType === 'manager'">
                <h3>Información Laboral</h3>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="salary">
                            <i class="pi pi-euro"></i>
                            Salario
                        </label>
                        <input type="number" id="salary" v-model="form.salary" 
                            :disabled="waiterData.userType !== 'manager'"
                            placeholder="Introduce tu salario" />
                    </div>

                    <div class="form-group">
                        <label for="shift_disponibility">
                            <i class="pi pi-clock"></i>
                            Disponibilidad de Turno
                        </label>
                        <input type="text" id="shift_disponibility" v-model="form.shift_disponibility"
                            :disabled="waiterData.userType !== 'manager'" 
                            placeholder="Introduce tu disponibilidad de turno" />
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn-submit">
                    <i class="pi pi-check"></i>
                    Actualizar
                </button>
            </div>
        </form>
    </div>
    <Modal v-model:visible="isModalVisible" :message="modalMessage" :title="modalTitle" />
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import Modal from '../Modal.vue';

const store = useStore();
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
    return toastType.value === 'success' ? 'pi pi-check-circle' : 'pi pi-exclamation-triangle';
});

const waiterData = store.getters['storeAuth/getUserData'];

const form = ref({
    firstName: waiterData.firstName,
    lastName: waiterData.lastName,
    phone_number: waiterData.phone_number,
    email: waiterData.email,
    avatar_url: waiterData.avatar_url,
    bio: waiterData.bio,
    salary: waiterData.salary,
    shift_disponibility: waiterData.shift_disponibility,
});

// Inicializar la vista previa si ya hay una URL de avatar
onMounted(() => {
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
    
    // Crear URL para vista previa temporal
    const objectUrl = URL.createObjectURL(file);
    
    // Crear una imagen para procesar y comprimir
    const img = new Image();
    img.onload = () => {
        // Redimensionar y comprimir la imagen
        const maxWidth = 300;  // Reducido de 400 a 300 para menor tamaño
        const maxHeight = 300;  // Reducido de 400 a 300 para menor tamaño
        
        // Calcular nuevas dimensiones manteniendo proporciones
        let width = img.width;
        let height = img.height;
        
        if (width > height) {
            if (width > maxWidth) {
                height = Math.round(height * (maxWidth / width));
                width = maxWidth;
            }
        } else {
            if (height > maxHeight) {
                width = Math.round(width * (maxHeight / height));
                height = maxHeight;
            }
        }
        
        // Crear canvas para redimensionar
        const canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;
        
        // Dibujar imagen redimensionada
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, width, height);
        
        // Convertir a JPEG con calidad reducida (0.6 = 60% de calidad)
        const compressedDataUrl = canvas.toDataURL('image/jpeg', 0.6);
        
        // Actualizar vista previa
        imagePreview.value = compressedDataUrl;
        
        // Guardar en el formulario
        form.value.avatar_url = compressedDataUrl;
        
        // Liberar memoria
        URL.revokeObjectURL(objectUrl);
    };
    
    img.src = objectUrl;
};

const handleSubmit = async () => {
    try {
        // Sanitizar datos antes de enviar (opcional)
        const formData = {...form.value};
        
        // Si la imagen es demasiado grande, podemos intentar reducirla aún más
        if (formData.avatar_url && formData.avatar_url.length > 500000) {
            showToastNotification('Aviso', 'Optimizando imagen para mejor rendimiento...', 'info');
            
            // Usamos la imagen ya en preview para volver a comprimir
            const img = new Image();
            img.onload = async () => {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                
                // Usar dimensiones más pequeñas
                canvas.width = 250;
                canvas.height = 250;
                
                // Dibujar con suavizado
                ctx.drawImage(img, 0, 0, 250, 250);
                
                // Comprimir más
                const finalDataUrl = canvas.toDataURL('image/jpeg', 0.5);
                
                // Asignar y enviar
                formData.avatar_url = finalDataUrl;
                await submitFormData(formData);
            };
            img.src = imagePreview.value;
        } else {
            // Enviar normalmente si no es necesario comprimirla más
            await submitFormData(formData);
        }
    } catch (error) {
        showToastNotification('Error', 'Error al actualizar los datos: ' + error.message, 'error');
    }
};

// Función auxiliar para enviar datos
const submitFormData = async (formData) => {
    try {
        await store.dispatch('storeAuth/updateUser', formData);
        showToastNotification('Éxito', 'Datos actualizados correctamente', 'success');
    } catch (error) {
        showToastNotification('Error', 'Error al actualizar los datos', 'error');
        throw error;  // Re-lanzar para manejo superior
    }
};
</script>

<style scoped>
.settings-container {
    max-width: 900px;
    margin: 40px auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.settings-header {
    background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
    color: white;
    padding: 20px 30px;
    display: flex;
    align-items: center;
}

.settings-header i {
    font-size: 24px;
    margin-right: 15px;
}

.settings-header h2 {
    margin: 0;
    font-weight: 400;
    font-size: 24px;
    letter-spacing: 0.5px;
}

.settings-form {
    padding: 30px;
}

.form-section {
    margin-bottom: 30px;
    background-color: #f9fafb;
    border-radius: 8px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
    transition: all 0.3s ease;
}

.form-section:hover {
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    transform: translateY(-2px);
}

.form-section h3 {
    margin-top: 0;
    margin-bottom: 20px;
    color: #2c3e50;
    font-size: 18px;
    font-weight: 500;
    border-bottom: 1px solid #e0e0e0;
    padding-bottom: 10px;
}

.form-row {
    display: flex;
    gap: 20px;
}

.form-group {
    margin-bottom: 20px;
    flex: 1;
}

.form-group label {
    display: flex;
    align-items: center;
    font-weight: 500;
    margin-bottom: 8px;
    color: #4a5568;
    font-size: 14px;
}

.form-group label i {
    margin-right: 8px;
    color: #3498db;
    font-size: 16px;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 12px 15px;
    border: 1px solid #e2e8f0;
    border-radius: 6px;
    font-size: 15px;
    transition: all 0.2s ease;
    background-color: white;
    color: #2d3748;
}

.form-group input:focus,
.form-group textarea:focus {
    border-color: #3498db;
    outline: none;
    box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.15);
}

.form-group input:disabled {
    background-color: #f2f2f2;
    cursor: not-allowed;
    opacity: 0.7;
}

.form-group textarea {
    min-height: 120px;
    resize: vertical;
}

.field-info {
    display: block;
    margin-top: 5px;
    color: #718096;
    font-size: 12px;
    font-style: italic;
}

.form-actions {
    display: flex;
    justify-content: flex-end;
    gap: 15px;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #e0e0e0;
}

.btn-submit, .btn-cancel {
    padding: 12px 25px;
    border-radius: 6px;
    border: none;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-submit {
    background-color: #3498db;
    color: white;
}

.btn-submit:hover {
    background-color: #2980b9;
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
}

.btn-cancel {
    background-color: #f7fafc;
    color: #4a5568;
    border: 1px solid #e2e8f0;
}

.btn-cancel:hover {
    background-color: #edf2f7;
}

.btn-submit i {
    margin-right: 8px;
}
/* Estilos para el selector de avatar */
.avatar-upload-group {
    margin-bottom: 30px;
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
    border-radius: 50%;
    overflow: hidden;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    border: 3px solid #3498db;
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
    color: #e74c3c;
    font-size: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s ease;
}

.remove-image:hover {
    background-color: #e74c3c;
    color: white;
}

.avatar-upload {
    flex: 1;
    padding: 20px;
    border: 2px dashed #e2e8f0;
    border-radius: 8px;
    background-color: #f9fafb;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
}

.avatar-upload:hover {
    border-color: #3498db;
    background-color: #ebf8ff;
}

.upload-icon-container {
    width: 50px;
    height: 50px;
    background-color: #3498db;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: 10px;
    color: white;
    font-size: 20px;
}

.upload-text {
    font-weight: 500;
    color: #2c3e50;
    margin-bottom: 5px;
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
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
    font-size: 20px;
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

/* Responsive design */
@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
        gap: 0;
    }

    .settings-form {
        padding: 20px;
    }

    .form-section {
        padding: 20px;
    }

    .form-actions {
        flex-direction: column-reverse;
    }

    .btn-submit, .btn-cancel {
        width: 100%;
    }

    .avatar-container {
        flex-direction: column;
        align-items: center;
    }
    
    .avatar-upload {
        width: 100%;
        margin-top: 15px;
    }
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
</style>