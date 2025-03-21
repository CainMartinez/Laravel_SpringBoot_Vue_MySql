<template>
    <Dialog 
        v-model:visible="dialogVisible"
        :header="title" 
        :style="{ width: '450px' }" 
        :modal="true"
        :closable="true"
        :closeOnEscape="true"
    >
        <div class="modal-content">
            <p>{{ message }}</p>
        </div>
        
        <template v-if="showActionButtons" #footer>
            <div class="modal-buttons">
                <Button 
                    :label="secondaryButtonText" 
                    icon="pi pi-home" 
                    class="p-button-secondary" 
                    @click="onSecondaryAction" 
                />
                
                <Button 
                    :label="primaryButtonText" 
                    icon="pi pi-user" 
                    class="p-button-primary" 
                    @click="onPrimaryAction" 
                />
            </div>
        </template>
    </Dialog>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    visible: {
        type: Boolean,
        required: true
    },
    title: {
        type: String,
        default: 'Mensaje'
    },
    message: {
        type: String,
        required: true
    },
    // Nuevas propiedades para botones de acción
    showActionButtons: {
        type: Boolean,
        default: false
    },
    primaryButtonText: {
        type: String,
        default: 'Aceptar'
    },
    secondaryButtonText: {
        type: String,
        default: 'Cancelar'
    }
});

const emit = defineEmits([
    'update:visible', 
    'closeModalWithRedirect', 
    'primaryAction', 
    'secondaryAction'
]);

// Variable local para controlar el diálogo
const dialogVisible = ref(props.visible);

// Observar cambios en la propiedad visible
watch(() => props.visible, (newValue) => {
    dialogVisible.value = newValue;
});

// Observar cambios en dialogVisible y emitir eventos al padre
watch(dialogVisible, (newValue) => {
    emit('update:visible', newValue);
});

// Función para manejar acción primaria (Ir al perfil)
const onPrimaryAction = () => {
    dialogVisible.value = false;
    emit('primaryAction');
};

// Función para manejar acción secundaria (Ir al inicio)
const onSecondaryAction = () => {
    dialogVisible.value = false;
    emit('secondaryAction');
};
</script>

<style scoped>
.modal-content {
    text-align: center;
    padding: 10px 0;
    font-family: 'Lora', serif;
    color: #4a3933;
    line-height: 1.6;
}

.modal-buttons {
    display: flex;
    justify-content: center;
    gap: 12px;
    width: 100%;
    padding-top: 10px;
}

/* Estilos para los botones */
:deep(.p-button.p-button-primary) {
    background: linear-gradient(135deg, #8B4513, #d4b48f);
    border: none;
    box-shadow: 0 2px 8px rgba(139, 69, 19, 0.2);
    transition: all 0.3s;
}

:deep(.p-button.p-button-primary:hover) {
    background: linear-gradient(135deg, #7b3b0c, #c4a583);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(139, 69, 19, 0.3);
}

:deep(.p-button.p-button-secondary) {
    background-color: #f8f5ef;
    color: #6b4423;
    border: 1px solid #e8d9c5;
    transition: all 0.3s;
}

:deep(.p-button.p-button-secondary:hover) {
    background-color: #f2ece2;
    color: #4a3933;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}
</style>