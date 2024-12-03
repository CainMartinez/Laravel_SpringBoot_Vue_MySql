<template>
    <div class="radio-input">
        <label>
            <input type="radio" value="cliente" v-model="selectedType" />
            <p>Cliente</p>
        </label>
        <label>
            <input type="radio" value="camarero" v-model="selectedType" />
            <p>Camarero</p>
        </label>
        <label>
            <input type="radio" value="gerente" v-model="selectedType" />
            <p>Gerente</p>
        </label>
        <span class="selection"></span>
    </div>
</template>

<script setup>
import { ref } from 'vue';

const selectedType = ref('cliente');

// Emitir tipo de usuario cuando cambie
const emit = defineEmits(['update:selectedType']);
</script>

<style scoped>
.radio-input {
    --container_width: 300px;
    position: relative;
    display: flex;
    align-items: center;
    border-radius: 10px;
    background-color: #fff;
    color: #000000;
    width: var(--container_width);
    overflow: hidden;
    border: 1px solid rgba(53, 52, 52, 0.226);
    margin-bottom: 20px;
}

.radio-input input {
    display: none;
}

.radio-input label {
    width: 100%;
    padding: 10px;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1;
    font-weight: 300;
    font-size: 14px;
}

.radio-input label p {
    margin: 0;
}

.selection {
    display: none;
    position: absolute;
    height: 100%;
    width: calc(var(--container_width) / 3);
    z-index: 0;
    left: 0;
    top: 0;
    transition: 0.15s ease;
}

.radio-input label:has(input:checked) {
    color: #fff;
}

.radio-input label:has(input:checked)~.selection {
    background-color: #333;
    display: inline-block;
}

.radio-input label:nth-child(1):has(input:checked)~.selection {
    transform: translateX(calc(var(--container_width) * 0 / 3));
}

.radio-input label:nth-child(2):has(input:checked)~.selection {
    transform: translateX(calc(var(--container_width) * 1 / 3));
}

.radio-input label:nth-child(3):has(input:checked)~.selection {
    transform: translateX(calc(var(--container_width) * 2 / 3));
}
</style>