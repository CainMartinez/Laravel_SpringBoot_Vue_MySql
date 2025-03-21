<template>
    <div class="user-type-selector">
        <h3 class="selector-title">Seleccione su tipo de cuenta</h3>
        <div class="radio-input">
            <label>
                <input type="radio" value="client" v-model="selectedType" />
                <div class="option-content">
                    <i class="pi pi-user"></i>
                    <p>Cliente</p>
                </div>
            </label>
            <label>
                <input type="radio" value="waiter" v-model="selectedType" />
                <div class="option-content">
                    <i class="pi pi-briefcase"></i>
                    <p>Camarero</p>
                </div>
            </label>
            <label>
                <input type="radio" value="manager" v-model="selectedType" />
                <div class="option-content">
                    <i class="pi pi-shield"></i>
                    <p>Manager</p>
                </div>
            </label>
            <span class="selection" :style="selectionStyle"></span>
        </div>
    </div>
</template>

<script setup>
import { ref, watch, onMounted, computed } from 'vue';

const selectedType = ref('client');
const emit = defineEmits(['update:selectedType']);

// Calcular la posición de la selección basada en el tipo seleccionado
const selectionStyle = computed(() => {
    let translateX = '0';
    
    switch(selectedType.value) {
        case 'client':
            translateX = '0';
            break;
        case 'waiter':
            translateX = 'calc(100% - 0px)';
            break;
        case 'manager':
            translateX = 'calc(200% - 0px)';
            break;
    }
    
    return {
        transform: `translateX(${translateX})`
    };
});

watch(selectedType, (newValue) => {
    emit('update:selectedType', newValue);
});

// Asegurar que la selección se aplique desde el inicio
onMounted(() => {
    emit('update:selectedType', selectedType.value);
});
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.user-type-selector {
    margin-bottom: 25px;
    width: 100%;
}

.selector-title {
    font-family: 'Playfair Display', serif;
    font-size: 1.1rem;
    color: #6b4423;
    margin-bottom: 12px;
    text-align: center;
    font-weight: 600;
}

.radio-input {
    --container_width: 100%;
    position: relative;
    display: flex;
    align-items: stretch;
    border-radius: 8px;
    background-color: #fff;
    color: #6b4423;
    width: var(--container_width);
    overflow: hidden;
    border: 1px solid #e8d9c5;
    font-family: 'Lora', serif;
    height: 50px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.radio-input input {
    display: none;
}

.radio-input label {
    width: 33.33%;
    padding: 0;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 2;
    font-weight: 500;
    font-size: 0.95rem;
    transition: color 0.3s ease;
    margin: 0;
    position: relative;
}

.option-content {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 8px;
    justify-content: center;
    width: 100%;
    height: 100%;
    padding: 10px;
}

.option-content i {
    font-size: 1rem;
}

.option-content p {
    margin: 0;
}

.selection {
    display: inline-block;
    position: absolute;
    height: calc(100% - 4px);
    width: calc(33.33% - 4px);
    z-index: 1;
    left: 2px;
    top: 2px;
    transition: transform 0.3s ease;
    border-radius: 6px;
    background: linear-gradient(135deg, #d4b48f, #8B4513);
    box-shadow: 0 2px 10px rgba(139, 69, 19, 0.2);
}

/* Estilo para las opciones cuando están seleccionadas */
.radio-input input:checked + .option-content {
    color: #fff;
    position: relative;
    z-index: 3;
    font-weight: 600;
}

/* Estilos responsivos */
@media (max-width: 768px) {
    .selector-title {
        font-size: 1rem;
    }
    
    .radio-input {
        height: 45px;
    }
    
    .option-content {
        gap: 5px;
    }
    
    .option-content i {
        font-size: 0.9rem;
    }
    
    .option-content p {
        font-size: 0.85rem;
    }
}

@media (max-width: 480px) {
    .option-content {
        flex-direction: column;
        gap: 3px;
        padding: 5px;
    }
    
    .option-content p {
        font-size: 0.8rem;
    }
}
</style>