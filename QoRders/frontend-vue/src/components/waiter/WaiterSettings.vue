<template>
    <div class="settings-container">
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
                
                <div class="form-group">
                    <label for="avatar_url">
                        <i class="pi pi-image"></i>
                        URL del Avatar
                    </label>
                    <input type="text" id="avatar_url" v-model="form.avatar_url"
                        placeholder="Introduce la URL del avatar" />
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
import { ref } from 'vue';
import { useStore } from 'vuex';
import Modal from '../Modal.vue';

const store = useStore();
const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');

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

const handleSubmit = async () => {
    try {
        await store.dispatch('storeAuth/updateUser', form.value);
        modalMessage.value = 'Datos actualizados correctamente';
        modalTitle.value = 'Éxito';
        isModalVisible.value = true;
    } catch (error) {
        modalMessage.value = 'Error al actualizar los datos';
        modalTitle.value = 'Error';
        isModalVisible.value = true;
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
}
</style>