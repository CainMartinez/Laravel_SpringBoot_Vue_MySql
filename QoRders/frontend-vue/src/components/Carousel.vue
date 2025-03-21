<template>
  <div class="carousel-container" v-if="rooms.length">
    <Carousel 
      :value="rooms" 
      :numVisible="1" 
      :numScroll="1" 
      :showNavigators="false"
      :showIndicators="true" 
      :autoplayInterval="5000" 
      :circular="true"
      v-model:activeIndex="activeIndex"
      @page="handlePageChange"
    >
      <template #item="slotProps">
        <div class="carousel-image-container">
          <img :src="slotProps.data.imageUrl" alt="Imagen de la sala" class="carousel-image" />
          <div class="overlay"></div>
          <div class="carousel-content">
            <h2 class="carousel-title">{{ slotProps.data.theme }}</h2>
            <p class="carousel-description" v-if="slotProps.data.description">
              {{ slotProps.data.description }}
            </p>
            <button class="visit-button" @click="visitRoom(slotProps.data)">
              Visitar Sala
              <i class="pi pi-arrow-right"></i>
            </button>
          </div>
        </div>
      </template>
    </Carousel>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue';
import { useRouter } from 'vue-router';

const router = useRouter();

const props = defineProps({
  rooms: {
    type: Array,
    required: true
  }
});

const emit = defineEmits(['slide-change']);

// Índice activo del carousel
const activeIndex = ref(0);

// Emitir evento cuando cambie el índice activo
watch(activeIndex, (newIndex) => {
  emit('slide-change', newIndex);
});

// Manejar cambio de página
const handlePageChange = (event) => {
  activeIndex.value = event.page;
  emit('slide-change', event.page);
};

// Función para visitar la sala
const visitRoom = (room) => {
  if (room && room.slug) {
    router.push({ name: 'menu', params: { slug: room.slug } });
  }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.carousel-container {
  margin-bottom: 0;
  width: 100%;
  height: 80vh;
  position: relative;
  background-color: #f3f3f3;
  color: #333;
  overflow: hidden;
}

.carousel-image-container {
  position: relative;
  width: 100%;
  height: 80vh;
  display: flex;
  justify-content: center;
  align-items: center;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.4);
}

.carousel-content {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80%;
  max-width: 800px;
  padding: 30px;
  text-align: center;
  color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 5;
}

.carousel-title {
  font-family: 'Playfair Display', serif;
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 15px;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
  animation: fadeIn 1s ease-out;
}

.carousel-description {
  font-family: 'Lora', serif;
  font-size: 1.3rem;
  margin: 0 auto 30px;
  line-height: 1.6;
  text-shadow: 0 1px 5px rgba(0, 0, 0, 0.5);
  animation: fadeIn 1s ease-out 0.3s both;
  max-width: 600px;
}

.visit-button {
  background: linear-gradient(135deg, #d4b48f, #8B4513);
  color: white;
  font-family: 'Lora', serif;
  font-weight: 600;
  font-size: 1.1rem;
  padding: 14px 28px;
  border: none;
  border-radius: 50px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s ease;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  animation: fadeIn 1s ease-out 0.6s both;
}

.visit-button:hover {
  background: linear-gradient(135deg, #c4a583, #7b3b0c);
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.4);
}

.visit-button i {
  transition: transform 0.3s ease;
}

.visit-button:hover i {
  transform: translateX(5px);
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Estilos para los indicadores de PrimeVue (puntos de navegación) */
:deep(.p-carousel-indicators) {
  position: absolute;
  bottom: 25px;
  left: 0;
  right: 0;
  display: flex;
  justify-content: center;
  margin-top: 0;
  z-index: 10;
}

:deep(.p-carousel-indicator > button) {
  width: 12px !important;
  height: 12px !important;
  border-radius: 50% !important;
  margin: 0 5px !important;
  background-color: rgba(255, 255, 255, 0.5) !important;
  transition: all 0.3s ease !important;
  border: 2px solid transparent !important;
}

:deep(.p-carousel-indicator.p-highlight > button) {
  background-color: white !important;
  transform: scale(1.2) !important;
  border-color: rgba(212, 180, 143, 0.8) !important;
}

/* Responsive */
@media (max-width: 992px) {
  .carousel-title {
    font-size: 3rem;
  }
  
  .carousel-description {
    font-size: 1.2rem;
  }
}

@media (max-width: 768px) {
  .carousel-container,
  .carousel-image-container {
    height: 70vh;
  }
  
  .carousel-title {
    font-size: 2.5rem;
  }
  
  .carousel-description {
    font-size: 1.1rem;
    margin-bottom: 25px;
  }
  
  .visit-button {
    padding: 12px 24px;
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .carousel-container,
  .carousel-image-container {
    height: 60vh;
  }
  
  .carousel-content {
    width: 90%;
    padding: 20px;
  }
  
  .carousel-title {
    font-size: 2rem;
    margin-bottom: 10px;
  }
  
  .carousel-description {
    font-size: 0.95rem;
    margin-bottom: 20px;
    line-height: 1.5;
  }
  
  .visit-button {
    padding: 10px 20px;
    font-size: 0.95rem;
  }
}
</style>