import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueJsx from '@vitejs/plugin-vue-jsx'; // Asegúrate de que el soporte para JSX está configurado

export default defineConfig({
  plugins: [vue(), vueJsx()],
  server: {
    port: 8085,
    host: true,
    cors: true,
    
  },
});
