<template>
  <div class="gastronomy-showcase">
    <div class="menu-cover">
      <div class="menu-decoration top"></div>
      <h1>Experiencias Gastronómicas</h1>
      <p class="subtitle">Seleccione un ambiente para su viaje culinario</p>
      <div class="menu-decoration bottom"></div>
    </div>
    
    <div class="culinary-introduction">
      <div class="intro-icon">
        <i class="pi pi-star"></i>
      </div>
      <p>
        Cada una de nuestras salas está diseñada para transportarle a un universo gastronómico único, 
        donde los sabores, aromas y texturas se unen para crear una experiencia sensorial inolvidable.
      </p>
    </div>

    <div class="gastronomic-rooms">
      <RoomCard 
        v-for="room in rooms" 
        :key="room.uuid" 
        :room="room" 
        size="medium" 
        class="gastronomic-room-card"
      />
    </div>
    
    <div class="chef-signature">
      <div class="signature-line"></div>
      <p>"La cocina es un lenguaje mediante el cual se puede expresar armonía, creatividad, felicidad, belleza, poesía, complejidad, magia, humor, provocación, cultura."</p>
      <span class="signature-author">— Ferran Adrià</span>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRooms } from '../composables/useRooms';
import RoomCard from '../components/RoomCard.vue';

const { allRooms } = useRooms();

const rooms = computed(() => allRooms.value);
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,600;0,700;1,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&display=swap');

.gastronomy-showcase {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px 30px;
  background-color: #f9f6f0;
  color: #4a3933;
  min-height: 100vh;
  font-family: 'Lora', serif;
  background-image: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0L50 50L100 0L50 100L0 0Z" fill="%23f2e8dc" fill-opacity="0.3"/></svg>');
  background-size: 300px;
}

.menu-cover {
  text-align: center;
  margin-bottom: 40px;
  position: relative;
  padding: 20px 0;
}

.menu-decoration {
  width: 80%;
  max-width: 500px;
  height: 2px;
  background: linear-gradient(90deg, transparent, #8B4513, transparent);
  margin: 15px auto;
  position: relative;
}

.menu-decoration::before,
.menu-decoration::after {
  content: "•";
  position: absolute;
  color: #8B4513;
  font-size: 18px;
}

.menu-decoration.top::before {
  left: 45%;
  top: -10px;
}

.menu-decoration.top::after {
  right: 45%;
  top: -10px;
}

.menu-decoration.bottom::before {
  left: 45%;
  top: -10px;
}

.menu-decoration.bottom::after {
  right: 45%;
  top: -10px;
}

h1 {
  font-family: 'Playfair Display', serif;
  font-size: 3rem;
  font-weight: 700;
  color: #6b4423;
  margin: 10px 0;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
  letter-spacing: 1px;
}

.subtitle {
  font-family: 'Lora', serif;
  font-style: italic;
  font-size: 1.2rem;
  color: #8B4513;
  margin: 5px 0 15px;
  letter-spacing: 0.5px;
}

.culinary-introduction {
  display: flex;
  align-items: center;
  background-color: #fff;
  border-radius: 12px;
  padding: 25px 30px;
  max-width: 900px;
  margin: 0 auto 50px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.08);
  border: 1px solid #e8d9c5;
  position: relative;
  text-align: center;
}

.culinary-introduction::before {
  content: "";
  position: absolute;
  top: 10px;
  left: 10px;
  right: 10px;
  bottom: 10px;
  border: 1px dashed #e8d9c5;
  border-radius: 8px;
  pointer-events: none;
}

.intro-icon {
  flex-shrink: 0;
  font-size: 1.8rem;
  color: #d4b48f;
  margin-right: 20px;
}

.culinary-introduction p {
  font-size: 1.1rem;
  line-height: 1.7;
  color: #6b4423;
  margin: 0;
}

/* Reemplaza tu actual .gastronomic-rooms por esto */
.gastronomic-rooms {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 30px;
  width: 100%;
  max-width: 1200px;
  margin: 0 auto 40px;
}

/* Añade esto para controlar el ancho de cada RoomCard */
:deep(.gastronomic-room-card) {
  flex: 0 0 calc(33.333% - 20px);
  max-width: 350px;
  min-width: 280px;
  margin-bottom: 10px;
  transition: all 0.3s ease;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(212, 180, 143, 0.3);
}

:deep(.gastronomic-room-card:hover) {
  transform: translateY(-10px);
  box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
}

:deep(.gastronomic-room-card .room-card-title) {
  font-family: 'Playfair Display', serif !important;
  font-weight: 600 !important;
  letter-spacing: 0.5px !important;
}

:deep(.gastronomic-room-card .room-card-description) {
  font-family: 'Lora', serif !important;
}

.chef-signature {
  background-color: #fdfbf7;
  border-radius: 8px;
  padding: 30px;
  max-width: 800px;
  margin: 20px auto 0;
  text-align: center;
  border-left: 3px solid #d4b48f;
  position: relative;
}

.signature-line {
  width: 80px;
  height: 2px;
  background-color: #d4b48f;
  margin: 0 auto 15px;
}

.chef-signature p {
  font-style: italic;
  font-size: 1.1rem;
  color: #6b4423;
  margin: 0 0 15px;
  line-height: 1.6;
}

.signature-author {
  display: block;
  font-weight: 600;
  color: #8B4513;
  font-size: 1rem;
}

/* Responsividad */
@media (max-width: 1024px) {
  .gastronomic-rooms {
    grid-template-columns: repeat(2, 1fr);
  }
  
  h1 {
    font-size: 2.5rem;
  }
}

@media (max-width: 768px) {
  .gastronomy-showcase {
    padding: 30px 20px;
  }
  
  h1 {
    font-size: 2rem;
  }
  
  .subtitle {
    font-size: 1rem;
  }
  
  .culinary-introduction {
    flex-direction: column;
    padding: 20px;
  }
  
  .intro-icon {
    margin: 0 0 15px 0;
  }
  
  .gastronomic-rooms {
    grid-template-columns: 1fr;
    gap: 20px;
  }
  
  .chef-signature {
    padding: 20px;
  }
}

@media (max-width: 480px) {
  h1 {
    font-size: 1.8rem;
  }
  
  .menu-decoration {
    width: 70%;
  }
  
  .culinary-introduction p,
  .chef-signature p {
    font-size: 1rem;
  }
}
</style>