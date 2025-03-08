<template>
  <Header></Header>
  <div class="font-switcher">
    <button @click="toggleAccessibilityFont" :class="{ active: isAccessibilityFontActive }">
      <span class="accessibility-icon">
        <i class="pi pi-eye"></i>
      </span> 
      {{ isAccessibilityFontActive ? 'On' : 'Off' }}
    </button>
  </div>
  <router-view :class="{ 'accessibility-font': isAccessibilityFontActive }"></router-view>
  <Footer>
  </Footer>
</template>

<script setup>
import Header from './layouts/Header.vue';
import Footer from './layouts/Footer.vue';
import { ref } from 'vue';

// Estado para controlar si la fuente de accesibilidad está activa
const isAccessibilityFontActive = ref(false);

// Función para alternar entre fuente temática y fuente accesible
const toggleAccessibilityFont = () => {
  isAccessibilityFontActive.value = !isAccessibilityFontActive.value;
  
  // Opcional: Guardar la preferencia en localStorage para mantenerla entre sesiones
  localStorage.setItem('accessibilityFont', isAccessibilityFontActive.value);
};

// Al cargar el componente, verificar si hay una preferencia guardada
if (typeof window !== 'undefined') {
  const savedPreference = localStorage.getItem('accessibilityFont');
  if (savedPreference !== null) {
    isAccessibilityFontActive.value = savedPreference === 'true';
  }
}
</script>

<style>
:root {
  --font-default: 'Roboto', sans-serif;
  --font-japan: 'Sawarabi Mincho', serif;
  --font-italy: 'Playfair Display', serif;
  --font-mexico: 'Lobster', cursive;
  --font-spain: 'Dancing Script', cursive;
  --font-india: 'Mukta', sans-serif;
  --font-turkey: 'Cinzel Decorative', serif;
  --font-accessibility: Arial, Helvetica, sans-serif;
}

/* Estilo base de la página */
body {
  margin: 0;
  padding: 0;
  font-family: var(--font-default);
  font-weight: normal;
  background-color: #f3f3f3;
  color: #333;
}

/* Aplicar la tipografía según el país */
.japón {
  font-family: var(--font-japan);
  font-weight: normal;
  letter-spacing: 1px;
}

.italia {
  font-family: var(--font-italy);
  font-weight: normal;
  letter-spacing: 1px;
}

.méxico {
  font-family: var(--font-mexico);
  font-weight: normal;
  letter-spacing: 2px;
}

.españa {
  font-family: var(--font-spain);
  font-weight: normal;
  letter-spacing: 2px;
}

.india {
  font-family: var(--font-india);
  font-weight: normal;
  letter-spacing: 1px;
}

.turquía {
  font-family: var(--font-turkey);
  font-weight: normal;
  letter-spacing: 1px;
}

/* Clase para aplicar la fuente accesible que anula las fuentes temáticas */
.accessibility-font,
.accessibility-font .japón,
.accessibility-font .italia,
.accessibility-font .méxico,
.accessibility-font .españa,
.accessibility-font .india,
.accessibility-font .turquía {
  font-family: var(--font-accessibility) !important;
  letter-spacing: normal !important;
}

/* Estilos para el botón de cambio de fuente */
.font-switcher {
  position: fixed;
  top: 100px;
  right: 20px;
  z-index: 1000;
}

.font-switcher button {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
}

.font-switcher button:hover {
  background-color: #f9f9f9;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
}

.font-switcher button.active {
  background-color: #e6f7ff;
  border-color: #91d5ff;
}

.accessibility-icon {
  margin-right: 8px;
  font-weight: bold;
  font-size: 16px;
}

.highcharts-credits {
  display: none !important;
}
</style>