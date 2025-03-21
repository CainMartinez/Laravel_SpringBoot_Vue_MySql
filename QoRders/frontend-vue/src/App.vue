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
  <Footer></Footer>
</template>

<script setup>
import Header from './layouts/Header.vue';
import Footer from './layouts/Footer.vue';
import { ref, onMounted } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

// Estado para controlar si la fuente de accesibilidad está activa
const isAccessibilityFontActive = ref(false);

const toggleAccessibilityFont = () => {
  isAccessibilityFontActive.value = !isAccessibilityFontActive.value;
  localStorage.setItem('accessibilityFont', isAccessibilityFontActive.value);
};

if (typeof window !== 'undefined') {
  const savedPreference = localStorage.getItem('accessibilityFont');
  if (savedPreference !== null) {
    isAccessibilityFontActive.value = savedPreference === 'true';
  }
}

onMounted(() => {
  store.dispatch('storeOrders/initializeFromLocalStorage');
});
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

/* Estilos base */
body {
  margin: 0;
  padding: 0;
  font-family: var(--font-default);
  font-weight: normal;
  background-color: #f3f3f3;
  color: #333;
}

/* Estilos para tipografías según país */
.japón { font-family: var(--font-japan); letter-spacing: 1px; }
.italia { font-family: var(--font-italy); letter-spacing: 1px; }
.méxico { font-family: var(--font-mexico); letter-spacing: 2px; }
.españa { font-family: var(--font-spain); letter-spacing: 2px; }
.india { font-family: var(--font-india); letter-spacing: 1px; }
.turquía { font-family: var(--font-turkey); letter-spacing: 1px; }

/* Anula las fuentes temáticas en modo accesible */
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

/* Estilos del botón de cambio de fuente en modo claro */
.font-switcher {
  position: fixed;
  top: 170px;
  right: 20px;
  z-index: 1000;
}

.font-switcher button {
  display: flex;
  align-items: center;
  padding: 8px 12px;
  background-color: #fff;
  color: #333;
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

html, body {
  height: 100%;
  margin: 0;
  padding: 0;
}

#app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  /* Añadir el mismo fondo que usan tus páginas principales */
  /* background-color: #f9f6f0; */
  /* background-image: url('data:image/svg+xml;utf8,<svg width="100" height="100" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><path d="M0 0L50 50L100 0L50 100L0 0Z" fill="%23f2e8dc" fill-opacity="0.3"/></svg>'); */
  background-size: 300px;
}

/* El contenido principal debe tener flex-grow para expandirse y empujar el footer hacia abajo */
main, .content-wrapper, .culinary-home, .gastronomy-showcase, .menu-page-wrapper {
  flex: 1 0 auto;
  /* Asegura que el fondo no se repita en componentes internos */
  background-color: transparent;
}

/* Para páginas que definen su propio fondo, podríamos necesitar anularlo */
.culinary-home, .gastronomy-showcase, .menu-page-wrapper {
  background-image: none;
}

/* Ajuste adicional para asegurar que el Router View ocupe todo el espacio disponible */
router-view {
  display: flex;
  flex-direction: column;
  flex: 1;
}

/* Sobrescribir estilos para modo oscuro: botón en negro sin tono azulado */
@media (prefers-color-scheme: dark) {
  .font-switcher button {
    background-color: #ffffff81 !important;
    color: #000000 !important;
    border: 1px solid #000 !important;
    box-shadow: 0 2px 5px rgba(255,255,255,0.1) !important;
  }
  .font-switcher button:hover {
    background-color: #ffffff !important;
    box-shadow: 0 2px 8px rgba(116, 115, 115, 0.15) !important;
  }
  .font-switcher button.active {
    background-color: #ffffff !important;
    border-color: #000 !important;
    font-weight: bold !important;

  }
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
