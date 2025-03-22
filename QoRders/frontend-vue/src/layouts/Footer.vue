<template>
  <footer class="footer">
    <div class="footer-pattern"></div>
    
    <div class="footer-container">
      <div class="footer-logo">
        <h3 class="footer-heading">GitHub</h3>
        <a 
          href="https://github.com/CainMartinez" 
          target="_blank" 
          rel="noopener noreferrer"
          class="github-link"
        >
          <font-awesome-icon :icon="['fab', 'github']" class="github-icon" />
          <span>Caín Martínez Bernabeu</span>
        </a>
      </div>
      
      <div class="footer-links-container">
        <h3 class="footer-heading">QoRders</h3>
        <p class="footer-description">
          Transformando corazones y comunidades a través de la solidaridad digital. 
          Conectamos donantes con organizaciones que hacen la diferencia.
        </p>
      </div>
      
      <div class="footer-links-container">
        <h3 class="footer-heading">Colaboradores</h3>
        <div class="footer-links">
          <a 
            class="footer-link"
            target="_blank" 
            rel="noopener noreferrer"
          >
            <font-awesome-icon :icon="['fas', 'arrow-right']" /> Àngela Torró
          </a>
          <a 
            class="footer-link"
            target="_blank" 
            rel="noopener noreferrer"
          >
            <font-awesome-icon :icon="['fas', 'arrow-right']" /> Álvaro Garrido
          </a>
          <a 
            class="footer-link"
            target="_blank" 
            rel="noopener noreferrer"
          >
            <font-awesome-icon :icon="['fas', 'arrow-right']" /> Caín Martínez
          </a>
        </div>
      </div>
    </div>
    
    <div class="footer-bottom">
      <p class="footer-copyright">
        &copy; {{ currentYear }} QoRders. Todos los derechos reservados.
      </p>
    </div>
  </footer>
</template>

<script setup>
import { computed } from 'vue';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

const currentYear = computed(() => new Date().getFullYear());
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap');

.footer {
  background: linear-gradient(to top, #2c3e50, #34495e);
  color: white;
  padding: 60px 5% 30px;
  position: relative;
  overflow: hidden;
  font-family: 'Poppins', sans-serif;
}

.footer::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-color, #e74c3c), var(--secondary-color, #e67e22));
}

.footer-pattern {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url('data:image/svg+xml;utf8,<svg width="60" height="60" xmlns="http://www.w3.org/2000/svg"><path d="M0,30 L30,0 M60,30 L30,60" stroke="rgba(255,255,255,0.03)" stroke-width="1"/></svg>');
  background-size: 30px 30px;
  opacity: 0.8;
  pointer-events: none;
}

.footer-container {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 40px;
  max-width: 1200px;
  margin: 0 auto;
  position: relative;
  z-index: 2;
}

.footer-logo {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.footer-logo-title {
  font-family: 'Playfair Display', serif;
  font-size: 2rem;
  font-weight: 700;
  margin: 0 0 15px;
  color: white;
  position: relative;
  display: inline-block;
}

.footer-logo-title span {
  background: linear-gradient(135deg, var(--secondary-color, #e67e22), var(--primary-color, #e74c3c));
  -webkit-background-clip: text;
  background-clip: text;
  color: transparent;
}

.footer-description {
  color: rgba(255, 255, 255, 0.7);
  line-height: 1.6;
  margin-bottom: 25px;
  font-size: 0.95rem;
}

.footer-links-container {
  display: flex;
  flex-direction: column;
}

.footer-heading {
  font-family: 'Playfair Display', serif;
  font-size: 1.3rem;
  font-weight: 600;
  margin-bottom: 20px;
  color: white;
  position: relative;
  padding-bottom: 12px;
}

.footer-heading::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 0;
  width: 40px;
  height: 2px;
  background: linear-gradient(to right, var(--secondary-color, #e67e22), var(--primary-color, #e74c3c));
}

.footer-links {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.footer-link {
  display: flex;
  align-items: center;
  gap: 10px;
  color: rgba(255, 255, 255, 0.7);
  text-decoration: none;
  transition: all 0.3s ease;
  background: transparent;
  padding: 0;
  font-size: 0.95rem;
}

.footer-link:hover {
  color: white;
  transform: translateX(5px);
  background: transparent;
}

.footer-link svg {
  font-size: 0.9rem;
  transition: all 0.3s ease;
}

.footer-link:hover svg {
  transform: translateX(3px);
}

.github-link {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 10px;
  background: rgba(255, 255, 255, 0.05);
  padding: 12px 16px;
  border-radius: 8px;
  transition: all 0.3s ease;
  text-decoration: none;
  color: white;
}

.github-link:hover {
  background: rgba(255, 255, 255, 0.1);
  transform: translateY(-3px);
}

.github-icon {
  transition: transform 0.3s ease;
}

.github-link:hover .github-icon {
  transform: rotate(5deg);
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
  width: 100%;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
}

.footer-copyright {
  color: rgba(255, 255, 255, 0.5);
  font-size: 0.85rem;
}

.footer-social {
  display: flex;
  gap: 15px;
}

.social-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  color: white;
  transition: all 0.3s ease;
  text-decoration: none;
}

.social-icon:hover {
  background: linear-gradient(135deg, var(--secondary-color, #e67e22), var(--primary-color, #e74c3c));
  transform: translateY(-3px);
}

/* Media queries para responsive */
@media screen and (max-width: 992px) {
  .footer-container {
    grid-template-columns: 1fr 1fr;
  }
  
  .footer-logo {
    grid-column: span 2;
    text-align: center;
    align-items: center;
  }
}

@media screen and (max-width: 768px) {
  .footer {
    padding: 50px 5% 20px;
  }
  
  .footer-container {
    grid-template-columns: 1fr;
    gap: 30px;
  }
  
  .footer-logo {
    grid-column: span 1;
  }
  
  .footer-heading {
    font-size: 1.2rem;
    margin-bottom: 15px;
  }
  
  .footer-bottom {
    flex-direction: column;
    gap: 15px;
    text-align: center;
  }
  
  .footer-copyright {
    order: 2;
  }
  
  .footer-social {
    order: 1;
  }
}

@media screen and (max-width: 576px) {
  .footer {
    padding: 40px 5% 20px;
  }
  
  .footer-logo-title {
    font-size: 1.8rem;
  }
  
  .github-link {
    width: 100%;
    justify-content: center;
  }
}
</style>