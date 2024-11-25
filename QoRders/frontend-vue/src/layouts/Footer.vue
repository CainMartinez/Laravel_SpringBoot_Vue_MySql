<template>
  <div class="footer">
    <div class="footer-content">
      <p>&copy; 2024 QoRders</p>
    </div>
    <div class="footer-links">
      <a href="https://github.com/AngeletaT">Àngela Torró </a>
      <a href="https://github.com/CainMartinez">Caín Martínez </a>
      <a href="https://github.com/AlvaroGarCam">Álvaro Garrido </a>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
</script>

<style scoped>
.footer {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 20px;
  background-color: #f8f9fa;
  box-shadow: 0 -4px 8px rgba(0, 0, 0, 0.1);
  background-color: #f3f3f3;
  color: #333;
}

p {
  color: #495057;
}

a {
  padding: 6px 12px;
  background-color: #f8f9fa;
  color: #495057;
  border: none;
  border-radius: 4px;
  text-decoration: none;
}

a:hover {
  background-color: #e9ecef;
}
</style>
