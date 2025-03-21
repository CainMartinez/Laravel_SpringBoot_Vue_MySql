<template>
    <div class="settings-container">
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

                <div class="form-row">
                    <div class="form-group">
                        <label for="avatar_url">
                            <i class="pi pi-image"></i>
                            URL del Avatar
                        </label>
                        <input type="text" id="avatar_url" v-model="form.avatar_url"
                            placeholder="Introduce la URL del avatar" />
                    </div>

                    <div class="form-group">
                        <label for="salary">
                            <i class="pi pi-euro"></i>
                            Salario
                        </label>
                        <input type="number" id="salary" v-model="form.salary" placeholder="Introduce tu salario" />
                        <small class="input-help">Solo visible para el personal autorizado</small>
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
import { ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import Modal from '../Modal.vue';

const store = useStore();
const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');

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
});

const resetForm = () => {
    form.value = { ...originalForm.value };
};

const handleSubmit = async () => {
    try {
        await store.dispatch('storeAuth/updateUser', form.value);
        modalTitle.value = 'Perfil Actualizado';
        modalMessage.value = 'Tus datos se han actualizado correctamente.';
        isModalVisible.value = true;
        
        // Actualizar los valores originales después de un guardado exitoso
        originalForm.value = { ...form.value };
    } catch (error) {
        modalTitle.value = 'Error';
        modalMessage.value = 'Ha ocurrido un error al actualizar tu perfil. Por favor, inténtalo de nuevo.';
        isModalVisible.value = true;
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

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
        gap: 0;
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