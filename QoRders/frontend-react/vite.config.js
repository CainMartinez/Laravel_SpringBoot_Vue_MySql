import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import cssInjectedByJsPlugin from 'vite-plugin-css-injected-by-js';

export default defineConfig({
  plugins: [react(), cssInjectedByJsPlugin()],
  server: {
    port: 8086,
    changeOrigin: true,
    cors: true,
  },
  build: {
    lib: {
      entry: './src/pages/DonationsPage/DonationsPage.jsx',
      name: 'DonationsPage',
      fileName: (format) => `DonationsPage.${format}.js`,
      formats: ['umd'], // Exporta en formato UMD
    },
    rollupOptions: {
      external: ['react', 'react-dom'], // Estas serán proporcionadas por Vue
      output: {
        globals: {
          react: 'React',
          'react-dom': 'ReactDOM',
        },
      },
    },
  },
});