<template>
    <Dialog 
      :visible="visible" 
      :header="title" 
      :closable="false" 
      :style="{ width: '50vw' }"
      @update:visible="closeModal"
    >
      <p>{{ message }}</p>
      <template #footer>
        <Button label="Aceptar" icon="pi pi-check" @click="closeModal" />
      </template>
    </Dialog>
</template>

<script setup>
import { ref } from 'vue';
import Dialog from 'primevue/dialog';
import Button from 'primevue/button';

const props = defineProps({
  visible: Boolean,
  message: String,
  title: String
});

const emit = defineEmits(['update:visible']);

const closeModal = () => {
  emit('update:visible', false);
};
</script>

<style scoped>
</style>