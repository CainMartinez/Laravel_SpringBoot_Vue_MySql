<template>
    <div class="people-select">
        <label for="people">¿Cuántos sois?</label>
        <input type="number" v-model="guestCount" min="2" max="10" id="people" />
    </div>
</template>

<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    modelValue: Number
});

const emit = defineEmits(['update:modelValue']);
const guestCount = ref(props.modelValue);

watch(guestCount, (newValue) => {
    emit('update:modelValue', newValue);
});
</script>

<style scoped>
.people-select {
    margin: 20px 0;
}

input {
    padding: 8px;
    font-size: 16px;
    width: 100%;
    max-width: 150px;
}
</style>