<template>
  <div class="footer">
    <div class="footer-decoration"></div>
    
    <div class="footer-content">
      <div class="footer-info">
        <img class="footer-logo" src="/src/assets/logo.png" alt="QoRders Logo" />
        <p class="copyright">&copy; 2025 QoRders</p>
      </div>
      
      <div class="footer-links">
        <a href="https://github.com/CainMartinez" target="_blank" rel="noopener noreferrer" class="github-link">
          <svg 
              class="github-icon" 
              height="20" 
              width="20" 
              viewBox="0 0 16 16" 
              aria-hidden="true"
          >
              <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z" fill="currentColor"></path>
          </svg>
          <span>Caín Martínez Bernabeu</span>
        </a>
      </div>
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
  background-color: #f8f9fa;
  color: #212529;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
  position: relative;
  margin-top: auto; /* Esto ayuda a empujar el footer hacia abajo cuando se usa con flexbox */
  width: 100%;
}

.footer-decoration {
  height: 3px;
  background: linear-gradient(to right, #0056b3 30%, #212529 100%);
  width: 100%;
}

.footer-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 30px;
  flex-wrap: wrap;
  gap: 20px;
}

.footer-info {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.footer-logo {
  height: 40px;
  width: auto;
  margin-bottom: 10px;
}

.copyright {
  font-size: 0.9rem;
  color: #6c757d;
  margin: 0;
}

.footer-links {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  flex-wrap: wrap;
}

a {
  color: #495057;
  text-decoration: none;
  padding: 8px 16px;
  border-radius: 4px;
  transition: all 0.3s ease;
  background-color: transparent;
  display: inline-flex;
  align-items: center;
}

a:hover {
  background-color: rgba(0, 86, 179, 0.08);
  color: #0056b3;
  transform: translateY(-2px);
}

.github-link {
  display: flex;
  align-items: center;
  gap: 8px;
  border: 1px solid rgba(0, 86, 179, 0.2);
}

.github-icon {
  transition: transform 0.3s ease;
}

.github-link:hover .github-icon {
  transform: rotate(10deg);
  color: #0056b3;
}

@media (max-width: 768px) {
  .footer-content {
    flex-direction: column;
    text-align: center;
    padding: 20px;
  }
  
  .footer-info {
    align-items: center;
    margin-bottom: 15px;
  }
  
  .footer-links {
    justify-content: center;
    width: 100%;
  }
}

@media (max-width: 480px) {
  .footer-links {
    flex-direction: column;
    align-items: center;
  }
  
  a {
    width: 100%;
    justify-content: center;
  }
}
</style>