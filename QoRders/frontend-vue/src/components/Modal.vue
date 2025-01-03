<template>
  <Dialog :visible="visible" :header="title" :closable="false" :style="{ width: '50vw' }" @update:visible="closeModal">
    <p>{{ message }}</p>
    <template #footer>
      <Button label="Aceptar" icon="pi pi-check" @click="handleClose" />
    </template>
  </Dialog>
</template>

<script setup>
import { ref } from 'vue';

const props = defineProps({
  visible: Boolean,
  message: String,
  title: String
});

const emit = defineEmits(['update:visible', 'closeModalWithRedirect']);

const closeModal = () => {
  emit('update:visible', false);
};

const handleClose = () => {
  closeModal();
  emit('closeModalWithRedirect');
};
</script>

<style scoped></style>