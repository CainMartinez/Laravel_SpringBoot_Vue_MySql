<template>
    <div class="recipe-toast-container" v-if="showToast">
            <div class="recipe-toast" :class="toastType">
                <div class="toast-icon">
                    <span>{{ toastIcon }}</span>
                </div>
                <div class="toast-content">
                    <div class="toast-title">{{ toastTitle }}</div>
                    <div class="toast-message">{{ toastMessage }}</div>
                </div>
                <button class="toast-close" @click="hideToast">
                    <span>×</span>
                </button>
            </div>
        </div>
    <div class="recipe-book">
        <div class="book-cover">
            <div class="book-title">
                <h2>Libro de Recetas Personal</h2>
                <div class="book-subtitle">Ingredientes para una experiencia perfecta</div>
                <div class="utensil-decoration">🍴</div>
            </div>

            <form @submit.prevent="handleSubmit" class="recipe-form">
                <div class="recipe-section">
                    <div class="section-header">
                        <div class="utensil-icon">👨‍🍳</div>
                        <h3>Sobre el Chef</h3>
                    </div>
                    
                    <div class="ingredient-group">
                        <div class="ingredient-row">
                            <div class="form-group">
                                <label for="firstName">Nombre</label>
                                <input type="text" id="firstName" v-model="form.firstName" placeholder="Tu nombre" />
                            </div>

                            <div class="form-group">
                                <label for="lastName">Apellido</label>
                                <input type="text" id="lastName" v-model="form.lastName" placeholder="Tu apellido" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" v-model="form.email" placeholder="Email" disabled />
                            <small class="recipe-note">*Este ingrediente no se puede modificar</small>
                        </div>

                        <div class="ingredient-row">
                            <div class="form-group">
                                <label for="age">Edad</label>
                                <input type="number" id="age" v-model="form.age" placeholder="Años de experiencia" />
                            </div>

                            <div class="form-group">
                                <label for="address">Dirección</label>
                                <input type="text" id="address" v-model="form.address" placeholder="Tu cocina personal" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="recipe-section">
                    <div class="section-header">
                        <div class="utensil-icon">🍽️</div>
                        <h3>Detalles de Sabor</h3>
                    </div>
                    
                    <div class="form-group">
                        <label for="avatar_url">Foto para el Recetario</label>
                        <div class="recipe-image-container">
                            <!-- Área de vista previa con estilo mejorado -->
                            <div class="preview-side">
                                <div class="preview-container polaroid" :class="{ 'empty-polaroid': !imagePreview }">
                                    <div class="polaroid-inner">
                                        <img v-if="imagePreview" :src="imagePreview" alt="Vista previa" class="image-preview" />
                                        <div v-else class="no-image-placeholder">
                                            <span class="placeholder-icon">👤</span>
                                        </div>
                                        <div class="polaroid-caption">Chef</div>
                                    </div>
                                    <div class="polaroid-tape"></div>
                                </div>
                                <button v-if="imagePreview" type="button" class="remove-image" @click="removeImage" title="Quitar foto">
                                    <span>×</span>
                                </button>
                            </div>
                            
                            <div class="upload-side">
                                <!-- Añadir pointer-events: all para asegurar que todo el área sea clickeable -->
                                <div class="upload-area cookbook-page" @click="triggerFileInput">
                                    <!-- Añadir eventos a elementos internos también para mayor seguridad -->
                                    <div class="dashed-border" @click.stop="triggerFileInput">
                                        <div class="upload-content" @click.stop="triggerFileInput">
                                            <div class="upload-icon-wrapper" @click.stop="triggerFileInput">
                                                <span class="upload-icon">📸</span>
                                            </div>
                                            <span class="upload-text">{{ imagePreview ? 'Cambiar foto' : 'Añadir foto' }}</span>
                                            <div class="upload-info">
                                                <small class="recipe-note">Formatos: JPG, PNG, GIF, WEBP (máx 2MB)</small>
                                            </div>
                                            <!-- Hacer que el botón sea explícitamente clickeable -->
                                            <button type="button" class="upload-button" @click.stop="triggerFileInput">
                                                <span>Seleccionar imagen</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Asegurarse de que el input file tenga los formatos adecuados -->
                            <input 
                                type="file" 
                                ref="fileInput" 
                                class="hidden-file-input" 
                                accept="image/jpeg, image/png, image/gif, image/webp"
                                @change="handleImageChange" 
                            />
                            
                            <input 
                                type="file" 
                                ref="fileInput" 
                                class="hidden-file-input" 
                                accept="image/jpeg, image/png, image/gif, image/webp"
                                @change="handleImageChange" 
                            />
                            <input type="hidden" id="avatar_url" v-model="form.avatarUrl" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="bio">Notas Personales</label>
                        <textarea id="bio" v-model="form.bio" placeholder="Tus preferencias culinarias y gustos..." />
                    </div>
                </div>

                <div class="recipe-actions">
                    <button type="submit" class="btn-submit">
                        <span class="btn-icon">📝</span>
                        Guardar en el Recetario
                    </button>
                </div>
            </form>
        </div>
        
        <div class="book-binding"></div>
        <div class="book-pages"></div>
    </div>
    <Modal v-model:visible="isModalVisible" :message="modalMessage" :title="modalTitle" />
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useStore } from 'vuex';
import Modal from '../Modal.vue';

const store = useStore();
const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');
const fileInput = ref(null);
const imagePreview = ref('');

const showToast = ref(false);
const toastMessage = ref('');
const toastTitle = ref('');
const toastType = ref('success');
const toastTimeout = ref(null);

// Icono del toast basado en el tipo
const toastIcon = computed(() => {
    if (toastType.value === 'success') return '✅';
    if (toastType.value === 'error') return '❌';
    return '📝';
});

const userData = store.getters['storeAuth/getUserData'].client;

const form = ref({
    firstName: userData.firstName,
    lastName: userData.lastName,
    email: userData.email,
    age: userData.age,
    address: userData.address,
    avatarUrl: userData.avatar_url,
    bio: userData.bio,
});
onMounted(() => {
    if (form.value.avatarUrl) {
        imagePreview.value = form.value.avatarUrl;
    }
});
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
const triggerFileInput = () => {
    fileInput.value.click();
};

const handleImageChange = (event) => {
    const file = event.target.files[0];
    if (!file) return;
    
    // Verificar tamaño (2MB máximo)
    if (file.size > 2 * 1024 * 1024) {
        modalMessage.value = 'La imagen es demasiado grande. El tamaño máximo es 2MB.';
        modalTitle.value = 'Error';
        isModalVisible.value = true;
        return;
    }
    
    // Crear URL para vista previa temporal
    const objectUrl = URL.createObjectURL(file);
    
    // Crear una imagen para procesar y comprimir
    const img = new Image();
    img.onload = () => {
        // Redimensionar y comprimir la imagen
        const maxWidth = 400;
        const maxHeight = 400;
        
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
        
        // Convertir a JPEG con calidad reducida (0.7 = 70% de calidad)
        const compressedDataUrl = canvas.toDataURL('image/jpeg', 0.7);
        
        // Actualizar vista previa
        imagePreview.value = compressedDataUrl;
        
        // Guardar en el formulario
        form.value.avatarUrl = compressedDataUrl;
        
        // Liberar memoria
        URL.revokeObjectURL(objectUrl);
    };
    
    img.src = objectUrl;
};

const removeImage = () => {
    imagePreview.value = '';
    form.value.avatarUrl = '';
    fileInput.value.value = '';  // Limpiar el input file
};

const handleSubmit = async () => {
    try {
        await store.dispatch('storeAuth/updateUser', form.value);
        showToastNotification('¡Receta guardada!', 'Tus datos se han actualizado correctamente en el recetario.', 'success');
    } catch (error) {
        showToastNotification('Error en la receta', 'No pudimos guardar tus cambios. ¡Inténtalo de nuevo!', 'error');
    }
};
</script>

<style scoped>
.recipe-book {
    max-width: 800px;
    margin: 40px auto;
    position: relative;
    perspective: 1500px;
}

.book-cover {
    background-color: #f9f3e9;
    border-radius: 8px 16px 16px 8px;
    box-shadow: 10px 10px 30px rgba(0, 0, 0, 0.2), 
                0 0 8px rgba(0, 0, 0, 0.1) inset;
    padding: 40px;
    position: relative;
    transform-style: preserve-3d;
    transform: rotateY(-3deg);
    z-index: 10;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23f9f3e9"/><rect x="0" y="0" width="100" height="100" fill="none" stroke="%23d9c7a3" stroke-width="0.5" stroke-dasharray="2,2"/></svg>');
}

.book-binding {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 30px;
    background: linear-gradient(to right, #a86832, #d4a76a, #a86832);
    border-radius: 3px 0 0 3px;
    box-shadow: -2px 0 5px rgba(0, 0, 0, 0.2) inset;
    transform-origin: left;
    transform: rotateY(15deg) translateZ(-10px);
    z-index: 5;
}

.book-pages {
    position: absolute;
    left: 28px;
    top: 5px;
    bottom: 5px;
    width: calc(100% - 28px);
    background-color: #fff;
    border-radius: 0 5px 5px 0;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    transform-origin: left;
    transform: rotateY(-3deg) translateZ(-20px);
    z-index: 1;
}

.book-title {
    text-align: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 2px dashed #d9c7a3;
    position: relative;
}

.book-title h2 {
    font-family: 'Brush Script MT', cursive;
    font-size: 36px;
    margin: 0 0 8px;
    color: #8b4513;
    text-shadow: 1px 1px 0 #f0e6d2;
}

.book-subtitle {
    font-family: 'Georgia', serif;
    font-style: italic;
    color: #a0522d;
    font-size: 16px;
}

.utensil-decoration {
    font-size: 24px;
    margin: 10px 0;
}

.recipe-form {
    font-family: 'Georgia', serif;
}

.recipe-section {
    background-color: rgba(255, 255, 255, 0.6);
    border: 1px solid #e0d3b8;
    border-radius: 8px;
    padding: 25px;
    margin-bottom: 25px;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
}

.section-header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    border-bottom: 1px solid #e0d3b8;
    padding-bottom: 10px;
}

.utensil-icon {
    font-size: 24px;
    margin-right: 15px;
}

.section-header h3 {
    font-family: 'Georgia', serif;
    font-size: 20px;
    color: #8b4513;
    margin: 0;
}

.ingredient-group {
    padding: 0 10px;
}

.ingredient-row {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}

.form-group {
    margin-bottom: 20px;
    flex: 1;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
    color: #8b4513;
    font-size: 15px;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #d9c7a3;
    border-radius: 6px;
    font-size: 15px;
    background-color: #fffcf5;
    color: #5a3921;
    font-family: 'Georgia', serif;
    transition: all 0.3s ease;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05) inset;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #a86832;
    box-shadow: 0 0 8px rgba(168, 104, 50, 0.2);
}

.form-group input:disabled {
    background-color: #f0e6d2;
    cursor: not-allowed;
}

.form-group textarea {
    min-height: 120px;
    resize: vertical;
}

.recipe-note {
    display: block;
    margin-top: 5px;
    font-style: italic;
    color: #a0522d;
    font-size: 12px;
}

.recipe-actions {
    text-align: center;
    margin-top: 30px;
}

.btn-submit {
    background-color: #8b4513;
    color: #fff;
    border: none;
    padding: 12px 25px;
    font-size: 16px;
    font-family: 'Georgia', serif;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.btn-submit:hover {
    background-color: #a0522d;
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.btn-icon {
    margin-right: 10px;
    font-size: 18px;
}

.recipe-image-uploader {
    margin-bottom: 25px;
    display: flex;
    justify-content: center;
}

/* Nuevo contenedor para ambos elementos */
.recipe-image-container {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 30px;
    margin-bottom: 25px;
    flex-wrap: wrap;
}

.preview-side, .upload-side {
    flex: 1;
    min-width: 240px;
    display: flex;
    justify-content: center;
    position: relative;
}

/* Estilos para placeholder cuando no hay imagen */
.no-image-placeholder {
    width: 100%;
    height: 200px;
    background-color: #f5f0e5;
    display: flex;
    align-items: center;
    justify-content: center;
    border: 1px dashed #d9c7a3;
}

.placeholder-icon {
    font-size: 64px;
    color: #d9c7a3;
}

.empty-polaroid {
    opacity: 0.7;
}

.upload-area.cookbook-page {
    width: 100%;
    max-width: 320px;
    height: 240px;
    background-color: #fffef7;
    border-radius: 8px;
    box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    pointer-events: all; /* Asegurar que los eventos de clic funcionan */
}

/* Hacer que el botón sea un elemento real de botón para mejor accesibilidad */
.upload-button {
    background-color: #8b4513;
    color: white;
    padding: 8px 16px;
    border-radius: 6px;
    margin-top: 12px;
    font-weight: bold;
    font-size: 14px;
    transition: all 0.2s ease;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
    border: none; /* Eliminar borde por defecto del botón */
    cursor: pointer; /* Asegurar que el cursor es pointer */
    width: auto;
    display: inline-block;
}

.upload-button:hover {
    background-color: #a0522d;
    transform: translateY(-2px);
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.15);
}

.hidden-file-input {
    display: none;
}

.upload-area.cookbook-page {
    width: 100%;
    max-width: 320px;
    height: 240px;
    background-color: #fffef7;
    border-radius: 8px;
    box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    transition: all 0.3s ease;
    position: relative;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
}

.upload-area.cookbook-page:hover {
    transform: translateY(-5px);
    box-shadow: 5px 8px 15px rgba(0, 0, 0, 0.15);
}

.dashed-border {
    position: absolute;
    top: 10px;
    left: 10px;
    right: 10px;
    bottom: 10px;
    border: 2px dashed #d9c7a3;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
}

.upload-area.cookbook-page:hover .dashed-border {
    border-color: #a86832;
}

.upload-content {
    text-align: center;
    padding: 20px;
}

.upload-icon-wrapper {
    width: 70px;
    height: 70px;
    background-color: #f9f3e9;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 15px;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.1);
    transform: rotate(-5deg);
    border: 2px solid #e0d3b8;
}

.upload-icon {
    font-size: 36px;
}

.upload-text {
    display: block;
    margin-bottom: 12px;
    font-weight: bold;
    color: #8b4513;
    font-size: 16px;
    font-family: 'Georgia', serif;
}

.upload-info {
    margin-top: 15px;
}

/* Vista previa estilo polaroid */
.preview-container.polaroid {
    background-color: white;
    padding: 10px 10px 20px 10px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
    transform: rotate(-2deg);
    width: 260px;
    position: relative;
    transition: all 0.3s ease;
    margin: 20px 0;
}

.preview-container.polaroid:hover {
    transform: rotate(0deg) scale(1.03);
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
}

.polaroid-inner {
    position: relative;
    overflow: hidden;
}

.image-preview {
    width: 100%;
    height: auto;
    display: block;
    border: 1px solid #f0e6d2;
}

.polaroid-caption {
    font-family: 'Brush Script MT', cursive;
    text-align: center;
    margin-top: 10px;
    color: #8b4513;
    font-size: 18px;
}

.polaroid-tape {
    position: absolute;
    top: -10px;
    left: 50%;
    transform: translateX(-50%);
    width: 80px;
    height: 30px;
    background-color: rgba(255, 255, 255, 0.6);
    opacity: 0.7;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    transform-origin: bottom center;
    transform: translateX(-50%) rotate(2deg);
}

.remove-image {
    position: absolute;
    top: -10px;
    right: -10px;
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background-color: #8b4513;
    border: 2px solid white;
    color: white;
    font-size: 18px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.2s ease;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    opacity: 0.8;
}

.remove-image:hover {
    opacity: 1;
    transform: scale(1.1);
    background-color: #a0522d;
}

.recipe-toast-container {
    position: fixed;
    top: 20px;
    right: 20px;
    z-index: 9999;
    max-width: 350px;
    width: 100%;
}

.recipe-toast {
    display: flex;
    align-items: flex-start;
    padding: 15px;
    border-radius: 8px;
    background-color: #fffcf5;
    border: 1px solid #d9c7a3;
    box-shadow: 5px 5px 15px rgba(0, 0, 0, 0.15);
    margin-bottom: 10px;
    animation: recipeToastIn 0.5s ease-out forwards;
    position: relative;
    overflow: hidden;
}

.recipe-toast::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 5px;
    background: linear-gradient(to right, #8b4513, #a0522d);
    opacity: 0.8;
}

.recipe-toast.error::before {
    background: linear-gradient(to right, #c53030, #e53e3e);
}

.recipe-toast.success::before {
    background: linear-gradient(to right, #2f855a, #38a169);
}

.toast-icon {
    width: 35px;
    height: 35px;
    background-color: #f9f3e9;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    border: 1px solid #d9c7a3;
    font-size: 16px;
    transform: rotate(-5deg);
    box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.1);
}

.toast-content {
    flex: 1;
    font-family: 'Georgia', serif;
}

.toast-title {
    font-weight: bold;
    font-size: 16px;
    margin-bottom: 4px;
    color: #8b4513;
    font-family: 'Brush Script MT', cursive;
}

.toast-message {
    font-size: 14px;
    color: #5a3921;
    font-style: italic;
}

.toast-close {
    background: transparent;
    border: none;
    color: #a0522d;
    cursor: pointer;
    font-size: 20px;
    line-height: 1;
    padding: 0;
    margin-left: 8px;
    opacity: 0.7;
    transition: all 0.2s;
}

.toast-close:hover {
    opacity: 1;
    transform: scale(1.2);
}

@keyframes recipeToastIn {
    0% {
        transform: translateX(100%) rotate(3deg);
        opacity: 0;
    }
    30% {
        transform: translateX(-10px) rotate(-2deg);
    }
    100% {
        transform: translateX(0) rotate(0deg);
        opacity: 1;
    }
}
@media (max-width: 768px) {
    .book-cover {
        padding: 25px;
        transform: none;
    }
    
    .book-binding, .book-pages {
        display: none;
    }
    
    .ingredient-row {
        flex-direction: column;
        gap: 0;
    }
    
    .book-title h2 {
        font-size: 28px;
    }
    .preview-container.polaroid {
        width: 220px;
    }
    
    .upload-area.cookbook-page {
        height: 200px;
    }
    .recipe-image-container {
        flex-direction: column;
        gap: 20px;
    }
    
    .preview-side, .upload-side {
        width: 100%;
    }
    
    .upload-area.cookbook-page {
        max-width: 260px;
        height: 180px;
    }
    
    .upload-icon-wrapper {
        width: 60px;
        height: 60px;
    }
    
    .upload-icon {
        font-size: 30px;
    }
    
    .upload-text {
        font-size: 15px;
    }
}
</style>