<template>
  <div class="culinary-home">
    <!-- Hero Section con Carousel -->
    <div class="carousel-container">
      <Carousel :rooms="rooms" @slide-change="handleSlideChange" />
      
    </div>

    <!-- Sección de donaciones -->
    <div class="donation-highlight">
      <div class="donation-icon">
        <i class="pi pi-heart-fill"></i>
      </div>
      <div class="donation-content">
        <h2>Gastronomía con Propósito</h2>
        <p>
            Con cada plato que disfrutas, contribuyes a un mundo mejor. Donamos el 0.9% de cada consumición 
          a organizaciones benéficas que luchan para hacer un mundo mejor, transformando tu experiencia 
          gastronómica en un acto de solidaridad.
        </p>
        <router-link to="/donations" class="learn-more">
          Conocer Nuestras ONG Asociadas
          <i class="pi pi-angle-right"></i>
        </router-link>
      </div>
    </div>

    <!-- Separador Gourmet -->
    <div class="gourmet-separator">
      <div class="separator-line"></div>
      <div class="separator-text">
        <i class="pi pi-box"></i>
        <span>Nuestras Experiencias Culinarias</span>
        <i class="pi pi-box"></i>
      </div>
      <div class="separator-line"></div>
    </div>

    <!-- Salas Temáticas Gastronómicas -->
    <div class="culinary-spaces">
      <RoomCard 
        v-for="room in rooms" 
        :key="room.uuid" 
        :room="room" 
        size="large" 
        class="culinary-room-card"
      />
    </div>

    <!-- Cita Gastronómica -->
    <div class="culinary-quote">
      <div class="quote-decoration"></div>
      <blockquote>
        "La cocina es un arte y un acto de amor. Cada plato cuenta una historia, preserva una tradición 
        y crea un momento inolvidable alrededor de la mesa."
      </blockquote>
      <div class="quote-attribution">— Nuestro Chef Ejecutivo</div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import { useStore } from 'vuex';
import { useRouter } from 'vue-router';
import Carousel from '../components/Carousel.vue';
import RoomCard from '../components/RoomCard.vue';

// Setup store y router
const store = useStore();
const router = useRouter();
const rooms = ref([]);
const activeIndex = ref(0);

// Computar la sala actual basada en el activeIndex
const currentRoom = computed(() => {
  return rooms.value && rooms.value.length > 0 && activeIndex.value >= 0 
    ? rooms.value[activeIndex.value] 
    : null;
});

// Función para cargar las salas
const fetchRooms = async () => {
  try {
    await store.dispatch('storeRooms/fetchRooms');
    rooms.value = store.getters['storeRooms/getRooms'];
  } catch (error) {
    console.error('Error al cargar las salas:', error);
  }
};

// Función para actualizar el índice activo del carousel
const handleSlideChange = (index) => {
  activeIndex.value = index;
};

// Función para navegar a la sala seleccionada
const navigateToRoom = (room) => {
  if (room && room.slug) {
    router.push({ name: 'menu', params: { slug: room.slug } });
  }
};

// Cargar todas las salas al montar el componente
onMounted(() => {
  fetchRooms();
});
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.culinary-home {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #f9f6f0;
  color: #4a3933;
  width: 100%;
  min-height: 100vh;
  font-family: 'Lora', serif;
  background-image: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0L50 50L100 0L50 100L0 0Z" fill="%23f2e8dc" fill-opacity="0.3"/></svg>');
  background-size: 300px;
}

/* Carousel y Hero Section */
.carousel-container {
  width: 100%;
  position: relative;
  height: 80vh;
  min-height: 500px;
  max-height: 800px;
  overflow: hidden;
  cursor: pointer;
  transition: transform 0.3s ease;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
}

.carousel-container:hover {
  transform: scale(1.01);
}

.carousel-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to bottom, rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.7));
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 0 50px;
  text-align: center;
  color: white;
  z-index: 10;
}

/* Badge de sala actual */
.room-badge {
  position: absolute;
  top: 40px;
  background: linear-gradient(135deg, #d4b48f, #8B4513);
  color: white;
  padding: 8px 20px;
  border-radius: 30px;
  font-size: 1.2rem;
  font-weight: 600;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  transform: translateY(-20px);
  opacity: 0;
  animation: fadeInDown 1s ease forwards 0.2s;
  font-family: 'Playfair Display', serif;
  letter-spacing: 0.5px;
  z-index: 20;
}

@keyframes fadeInDown {
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

.hero-title {
  font-family: 'Playfair Display', serif;
  font-size: 3.5rem;
  font-weight: 700;
  margin-bottom: 20px;
  letter-spacing: 1px;
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.4);
  transform: translateY(-20px);
  opacity: 0;
  animation: fadeInUp 1s ease forwards 0.3s;
}

.hero-subtitle {
  font-size: 1.4rem;
  font-weight: 400;
  max-width: 800px;
  margin-bottom: 30px;
  letter-spacing: 0.5px;
  line-height: 1.5;
  transform: translateY(-20px);
  opacity: 0;
  animation: fadeInUp 1s ease forwards 0.6s;
}

.hero-cta {
  background: linear-gradient(135deg, #d4b48f, #8B4513);
  border: none;
  color: white;
  padding: 14px 28px;
  font-size: 1.1rem;
  font-weight: 600;
  border-radius: 50px;
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  transform: translateY(-20px);
  opacity: 0;
  animation: fadeInUp 1s ease forwards 0.9s;
  transition: all 0.3s ease;
  box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
}

.hero-cta:hover {
  background: linear-gradient(135deg, #c4a583, #7b3b0c);
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 69, 19, 0.4);
}

@keyframes fadeInUp {
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* Sección de donaciones */
.donation-highlight {
  display: flex;
  align-items: center;
  background-color: #fff;
  border-radius: 12px;
  padding: 40px;
  max-width: 1000px;
  margin: -50px auto 60px;
  position: relative;
  z-index: 20;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8d9c5;
}

.donation-highlight::before {
  content: "";
  position: absolute;
  top: 15px;
  left: 15px;
  right: 15px;
  bottom: 15px;
  border: 1px dashed #e8d9c5;
  border-radius: 8px;
  pointer-events: none;
}

.donation-icon {
  background: linear-gradient(135deg, #e74c3c, #c0392b);
  width: 70px;
  height: 70px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 2rem;
  flex-shrink: 0;
  margin-right: 30px;
  box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
}

.donation-content {
  flex: 1;
}

.donation-content h2 {
  font-family: 'Playfair Display', serif;
  font-size: 1.8rem;
  color: #6b4423;
  margin: 0 0 15px;
}

.donation-content p {
  color: #6b4423;
  line-height: 1.7;
  margin-bottom: 20px;
  font-size: 1.05rem;
}

.learn-more {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  color: #e74c3c;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  font-size: 1rem;
}

.learn-more:hover {
  color: #c0392b;
  gap: 12px;
}

/* Separador Gourmet */
.gourmet-separator {
  display: flex;
  align-items: center;
  width: 100%;
  max-width: 1000px;
  margin: 30px 0;
}

.separator-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, transparent, #8B4513, transparent);
}

.separator-text {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 0 20px;
  color: #8B4513;
  font-family: 'Playfair Display', serif;
  font-size: 1.4rem;
  white-space: nowrap;
}

/* Sección de Salas Temáticas */
.culinary-spaces {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 40px;
  padding: 20px;
  width: 100%;
  max-width: 1200px;
  margin-bottom: 60px;
}

:deep(.culinary-room-card) {
  flex: 0 0 calc(33.333% - 27px);
  max-width: 350px;
  min-width: 280px;
  transition: all 0.3s ease;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(212, 180, 143, 0.3);
}

:deep(.culinary-room-card:hover) {
  transform: translateY(-10px);
  box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
}

:deep(.culinary-room-card .room-card-title) {
  font-family: 'Playfair Display', serif !important;
  font-weight: 600 !important;
  letter-spacing: 0.5px !important;
}

:deep(.culinary-room-card .room-card-description) {
  font-family: 'Lora', serif !important;
}

/* Cita Gastronómica */
.culinary-quote {
  background-color: #fdfbf7;
  border-radius: 8px;
  padding: 40px;
  max-width: 800px;
  margin: 0 auto 60px;
  text-align: center;
  position: relative;
}

.quote-decoration {
  width: 100px;
  height: 2px;
  background-color: #d4b48f;
  margin: 0 auto 20px;
}

.culinary-quote blockquote {
  font-style: italic;
  font-size: 1.3rem;
  color: #6b4423;
  margin: 0 0 20px;
  line-height: 1.6;
  position: relative;
}

.culinary-quote blockquote::before,
.culinary-quote blockquote::after {
  content: '"';
  font-family: 'Playfair Display', serif;
  font-size: 4rem;
  color: rgba(212, 180, 143, 0.3);
  position: absolute;
}

.culinary-quote blockquote::before {
  top: -30px;
  left: -15px;
}

.culinary-quote blockquote::after {
  bottom: -50px;
  right: -15px;
}

.quote-attribution {
  font-weight: 600;
  color: #8B4513;
  font-size: 1rem;
}

/* Responsive Design */
@media (max-width: 992px) {
  .hero-title {
    font-size: 2.8rem;
  }
  
  .hero-subtitle {
    font-size: 1.2rem;
  }
  
  .donation-highlight {
    flex-direction: column;
    padding: 30px;
    margin-top: -40px;
  }
  
  .donation-icon {
    margin: 0 0 20px 0;
  }
  
  :deep(.culinary-room-card) {
    flex: 0 0 calc(50% - 20px);
  }
  
  .room-badge {
    font-size: 1.1rem;
    padding: 6px 16px;
  }
}

@media (max-width: 768px) {
  .carousel-container {
    height: 60vh;
  }
  
  .hero-title {
    font-size: 2.2rem;
  }
  
  .hero-subtitle {
    font-size: 1.1rem;
  }
  
  .donation-highlight {
    padding: 25px;
    margin: -30px 20px 40px;
  }
  
  .donation-content h2 {
    font-size: 1.5rem;
  }
  
  .separator-text {
    font-size: 1.2rem;
  }
  
  :deep(.culinary-room-card) {
    flex: 0 0 100%;
    max-width: 400px;
  }
  
  .culinary-quote {
    padding: 30px 20px;
    margin-bottom: 40px;
  }
  
  .culinary-quote blockquote {
    font-size: 1.15rem;
  }
  
  .room-badge {
    top: 20px;
    font-size: 1rem;
  }
}

@media (max-width: 480px) {
  .carousel-overlay {
    padding: 0 20px;
  }
  
  .hero-title {
    font-size: 1.8rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .hero-cta {
    padding: 12px 24px;
    font-size: 1rem;
  }
  
  .donation-highlight::before {
    display: none;
  }
  
  .donation-icon {
    width: 50px;
    height: 50px;
    font-size: 1.5rem;
  }
  
  .separator-text span {
    font-size: 1rem;
  }
  
  .room-badge {
    padding: 5px 12px;
    font-size: 0.9rem;
  }
}
</style>