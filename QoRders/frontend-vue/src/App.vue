<template>
  <Header></Header>
  <router-view></router-view>
  <Footer>
  </Footer>
</template>

<script setup>
import Header from './layouts/Header.vue';
import Footer from './layouts/Footer.vue';
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

.highcharts-credits {
  display: none !important;
}
</style>
