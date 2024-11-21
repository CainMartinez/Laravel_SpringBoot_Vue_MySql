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

<style scoped>
body {
  margin: 0;
  padding: 0;
}
</style>
