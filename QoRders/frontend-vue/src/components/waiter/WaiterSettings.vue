<template>
    <div class="settings-form">
        <h2>Ajustes de Perfil</h2>
        <form @submit.prevent="handleSubmit">
            <div class="form-group">
                <label for="firstName">Nombre</label>
                <input type="text" id="firstName" v-model="form.firstName" placeholder="Introduce tu nombre" />
            </div>

            <div class="form-group">
                <label for="lastName">Apellido</label>
                <input type="text" id="lastName" v-model="form.lastName" placeholder="Introduce tu apellido" />
            </div>

            <div class="form-group">
                <label for="phone_number">Número de Teléfono</label>
                <input type="text" id="phone_number" v-model="form.phone_number"
                    placeholder="Introduce tu número de teléfono" />
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" v-model="form.email" placeholder="Email" disabled />
            </div>

            <div class="form-group">
                <label for="avatar_url">URL del Avatar</label>
                <input type="text" id="avatar_url" v-model="form.avatar_url"
                    placeholder="Introduce la URL del avatar" />
            </div>

            <div class="form-group">
                <label for="bio">Biografía</label>
                <textarea id="bio" v-model="form.bio" placeholder="Introduce tu biografía"></textarea>
            </div>

            <div class="form-group">
                <label for="salary">Salario</label>
                <input type="number" id="salary" v-model="form.salary" :disabled="waiterData.userType !== 'manager'"
                    placeholder="Introduce tu salario" />
            </div>

            <div class="form-group">
                <label for="shift_disponibility">Disponibilidad de Turno</label>
                <input type="text" id="shift_disponibility" v-model="form.shift_disponibility"
                    :disabled="waiterData.userType !== 'manager'" placeholder="Introduce tu disponibilidad de turno" />
            </div>

            <button type="submit" class="btn-submit">Actualizar</button>
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
.settings-form {
    margin: auto;
    padding: 20px;
    max-height: 500px;
}

.settings-form h2 {
    font-size: 1.8rem;
    margin-bottom: 20px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 5px;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
}

.form-group input:disabled {
    background-color: #f9f9f9;
}

.btn-submit {
    width: 100%;
    padding: 10px;
    background-color: #007bff;
    color: white;
    font-size: 1rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.btn-submit:hover {
    background-color: #0056b3;
}
</style>
