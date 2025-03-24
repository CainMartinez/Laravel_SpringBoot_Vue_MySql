<template>
    <div class="menu-card">
        <!-- Decoración superior -->
        <div class="menu-decoration top">
            <div class="decoration-line"></div>
            <div class="decoration-ornament">✦</div>
            <div class="decoration-line"></div>
        </div>

        <!-- Título principal -->
        <div class="menu-title">
            <h1>Carta del Cliente</h1>
            <div class="subtitle">Experiencia Gastronómica Personal</div>
        </div>

        <!-- Datos personales -->
        <div class="menu-section personal-data">
            <h2 class="section-title">Información del Comensal</h2>
            
            <div class="data-container">
                <div class="menu-item">
                    <span class="item-name">Nombre:</span>
                    <span class="item-value">{{ userData.firstName }} {{ userData.lastName }}</span>
                </div>
                
                <div class="menu-item">
                    <span class="item-name">Email:</span>
                    <span class="item-value">{{ userData.email }}</span>
                </div>
                
                <div class="menu-item">
                    <span class="item-name">Edad:</span>
                    <span class="item-value">{{ userData.age }} años</span>
                </div>
                
                <div class="menu-item">
                    <span class="item-name">Dirección:</span>
                    <span class="item-value">{{ userData.address }}</span>
                </div>
                
                <div class="menu-item">
                    <span class="item-name">Preferencias:</span>
                    <span class="item-value">{{ userData.bio || 'Sin preferencias especiales' }}</span>
                </div>
            </div>
        </div>
        <div class="menu-section">
            <h2 class="section-title">Programa de Fidelidad</h2>
            
            <div class="loyalty-container">
                <div class="loyalty-card">
                    <div class="loyalty-header">
                        <i class="pi pi-star"></i>
                        <span>Puntos de Fidelidad</span>
                    </div>
                    <div class="loyalty-value">{{ userData.loyalty_points || 0 }}</div>
                    <div class="loyalty-info">
                        <span>{{((userData.loyalty_points || 0) / 100) }}€ en tu próxima compra</span>
                    </div>
                    <div class="loyalty-explanation">
                        <p>Por cada 1,00€ que gastes, ganas 1 punto de fidelidad. </p>
                            <p> Cada 100 puntos equivalen a 1,00€</p>
                        
                        <p class="loyalty-note">* No acumulable con cupones de descuento.</p>
                    </div>
                </div>
            </div>
        </div>
        <!-- Sección de métricas -->
        <div class="menu-section metrics-data">
            <h2 class="section-title">Degustación Estadística</h2>
            
            <div class="chartsContainer">
                <div class="chart-wrapper">
                    <h3 class="chart-title">Aportaciones Solidarias</h3>
                    <div ref="donationsChart" class="chart"></div>
                </div>
                
                <div class="chart-wrapper">
                    <h3 class="chart-title">Historial de Visitas</h3>
                    <div ref="reservationsChart" class="chart"></div>
                </div>
            </div>
            
            <div class="coupon-section">
                <button 
                    v-if="isDonationComplete && !hasClientCoupon" 
                    @click="generateCoupon" 
                    class="coupon-button"
                >
                    <i class="pi pi-ticket"></i> Obtener cupón de agradecimiento
                </button>
                
                <div v-else-if="hasClientCoupon" class="coupon-active">
                    <i class="pi pi-check-circle"></i>
                    ¡Cupón de 20% de descuento activado para tu próximo pago!
                </div>
                
                <div v-else class="coupon-progress">
                    <div class="progress-bar">
                        <div class="progress-fill" :style="{width: `${Math.min(donationPercentage, 100)}%`}"></div>
                    </div>
                    <span class="progress-text">{{ donationPercentage.toFixed(1) }}% de donaciones acumuladas</span>
                </div>
            </div>
        </div>

        <!-- Decoración inferior -->
        <div class="menu-decoration bottom">
            <div class="decoration-line"></div>
            <div class="decoration-ornament">✦</div>
            <div class="decoration-line"></div>
        </div>

        <!-- Sello de cliente -->
        <div class="client-stamp">Cliente Distinguido</div>
    </div>
</template>

<script setup>
import { computed, onMounted, ref, watch } from 'vue';
import { useStore } from 'vuex';
import Highcharts from "highcharts";
import axios from 'axios';

const store = useStore();

// Datos del usuario
const userData = computed(() => store.getters['storeAuth/getUserData'].client);
const hasClientCoupon = computed(() => userData.value?.has_coupon || false);

const props = defineProps({
    reservations: {
        type: Array,
        required: true
    },
    reservationsCount: {
        type: Number,
        required: true
    }
});

const donationsAmount = computed(() => {
    const totalAmount = props.reservations.reduce((total, reservation) => {
        const ticketsTotal = reservation.tickets.reduce((sum, ticket) => sum + ticket.totalAmount, 0);
        return total + ticketsTotal;
    }, 0) * 0.009;
    return totalAmount.toFixed(2);
});

// Total histórico de donaciones (para el gráfico)
const historicalDonationsAmount = computed(() => {
  const totalAmount = props.reservations.reduce((total, reservation) => {
    const ticketsTotal = reservation.tickets.reduce((sum, ticket) => sum + ticket.totalAmount, 0);
    return total + ticketsTotal;
  }, 0) * 0.009;
  return totalAmount.toFixed(2);
});

// Cantidad de donaciones ya canjeadas por cupones (100€ por cada cupón)
const redeemedDonations = computed(() => {
  // Obtenemos esto del usuario - cada cupón canjeado equivale a 100€
  const redeemedCouponsCount = userData.value?.redeemed_coupons_count || 0;
  return redeemedCouponsCount * 100;
});

// Donaciones disponibles para el próximo cupón
const availableDonationsAmount = computed(() => {
  const available = Math.max(0, parseFloat(historicalDonationsAmount.value) - redeemedDonations.value);
  return available.toFixed(2);
});

// Cantidad restante para completar el próximo cupón
const availableDonationsRest = computed(() => {
  return (100 - availableDonationsAmount.value).toFixed(2);
});

// Porcentaje disponible para la barra de progreso
const availableDonationPercentage = computed(() => {
  return (parseFloat(availableDonationsAmount.value) / 100) * 100;
});

const donationsRest = computed(() => {
    return (100 - donationsAmount.value).toFixed(2);
});
const donationPercentage = computed(() => {
    return (parseFloat(donationsAmount.value) / 100) * 100;
});

const isDonationComplete = computed(() => {
    return parseFloat(donationsAmount.value) >= 100;
});
// Actualizar el método generateCoupon

const generateCoupon = async () => {
  try {
    const token = store.getters['storeAuth/getToken'];
    
    // Incrementar el contador de cupones canjeados
    const redeemedCouponsCount = (userData.value?.redeemed_coupons_count || 0) + 1;
    
    // Llamar al endpoint de actualización de cliente
    const response = await axios.put(
      'http://localhost:8090/spring/api/client', 
      { 
        has_coupon: true,
        redeemed_coupons_count: redeemedCouponsCount  // Este campo se debe agregar al backend
      },
      {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    if (response.status === 200) {
      // Actualizar el estado del usuario en el store
      store.commit('storeAuth/UPDATE_CLIENT_DATA', {
        ...userData.value,
        has_coupon: true,
        redeemed_coupons_count: redeemedCouponsCount
      });
      
      // Mostrar mensaje de éxito
      store.dispatch('storeNotifications/pushNotification', {
        type: 'success',
        message: '¡Cupón de 20% activado! Se aplicará en tu próximo pago y podrás seguir acumulando donaciones.'
      });
    }
  } catch (error) {
    console.error('Error al generar el cupón:', error);
    store.dispatch('storeNotifications/pushNotification', {
      type: 'error',
      message: 'No se pudo generar el cupón. Inténtalo de nuevo más tarde.'
    });
  }
};

const donationsChart = ref(null);
const reservationsChart = ref(null);
const chartOptions = {
    chart: {
        type: "pie",
        backgroundColor: 'rgba(255, 252, 245, 0.7)',
        borderRadius: 5,
        events: {
            load: function () {
                const chart = this;
                window.addEventListener('resize', function () {
                    chart.reflow();
                });
            }
        }
    },
    title: {
        text: "",
        style: {
            fontFamily: "'Playfair Display', serif",
            color: '#5D4037'
        }
    },
    tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
    },
    plotOptions: {
        pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
                enabled: true,
                format: '<b>{point.name}</b>',
                style: {
                    fontFamily: "'Playfair Display', serif",
                    color: '#5D4037'
                }
            }
        }
    },
    series: [
    {
      name: 'Donaciones',
      colorByPoint: true,
      data: [
        {
          name: historicalDonationsAmount.value + ' € acumulados',
          y: parseFloat(historicalDonationsAmount.value),
          color: '#8D6E63', // Marrón claro
        },
        {
          name: 'Impacto necesario',
          y: Math.max(0, 100 - parseFloat(historicalDonationsAmount.value) % 100),
          color: '#D7CCC8', // Beige
        },
      ]
    }
  ]
};

const reservationSeriesData = props.reservations?.map((reservation) => {
    return {
        y: reservation.guestCount,
        x: new Date(reservation.bookingDate).getTime()
    };
});

const reservationsChartOptions = {
    chart: {
        type: "column",
        backgroundColor: 'rgba(255, 252, 245, 0.7)',
        borderRadius: 5,
        events: {
            load: function () {
                const chart = this;
                window.addEventListener('resize', function () {
                    chart.reflow();
                });
            }
        }
    },
    title: {
        text: "",
        style: {
            fontFamily: "'Playfair Display', serif",
            color: '#5D4037'
        }
    },
    xAxis: {
        type: 'datetime',
        title: {
            text: "Fecha de visita",
            style: {
                fontFamily: "'Playfair Display', serif",
                color: '#5D4037'
            }
        },
        labels: {
            format: '{value:%e %b}',
            style: {
                fontFamily: "'Playfair Display', serif",
                color: '#5D4037'
            }
        },
        tickInterval: 24 * 3600 * 1000,
    },
    yAxis: {
        title: {
            text: "Comensales",
            style: {
                fontFamily: "'Playfair Display', serif",
                color: '#5D4037'
            }
        },
        min: 1,
        max: 10,
        labels: {
            style: {
                fontFamily: "'Playfair Display', serif",
                color: '#5D4037'
            }
        }
    },
    plotOptions: {
        column: {
            color: '#8D6E63',
            borderColor: '#5D4037',
            borderWidth: 1
        }
    },
    series: [
        {
            name: 'Comensales',
            data: reservationSeriesData
        }
    ]
};

onMounted(() => {
    if (donationsChart.value) {
        Highcharts.chart(donationsChart.value, chartOptions);
    }

    if (reservationsChart.value) {
        Highcharts.chart(reservationsChart.value, reservationsChartOptions);
    }
});

watch([donationsAmount, donationsRest], () => {
    if (donationsChart.value) {
        Highcharts.chart(donationsChart.value, chartOptions);
    }
});
</script>

<style scoped>
.menu-card {
    max-width: 1200px;
    margin: 40px auto;
    background-color: #FFFCF5;
    border: 1px solid #D7CCC8;
    border-radius: 8px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
    padding: 40px;
    position: relative;
    font-family: 'Playfair Display', serif;
    color: #5D4037;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23FFFCF5"/><path d="M0,0 L100,100 M100,0 L0,100" stroke="%23EFEBE9" stroke-width="0.5"/></svg>');
    background-repeat: repeat;
}

.menu-decoration {
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 20px 0;
}

.decoration-line {
    flex-grow: 1;
    height: 1px;
    background: linear-gradient(90deg, transparent, #8D6E63, transparent);
}

.decoration-ornament {
    margin: 0 20px;
    font-size: 20px;
    color: #8D6E63;
}

.menu-title {
    text-align: center;
    margin-bottom: 40px;
}

.menu-title h1 {
    font-size: 36px;
    font-weight: 700;
    margin: 0 0 10px;
    color: #5D4037;
    letter-spacing: 1px;
}

.subtitle {
    font-size: 18px;
    font-style: italic;
    color: #8D6E63;
}

.menu-section {
    margin-bottom: 40px;
    padding: 30px;
    background-color: rgba(255, 255, 255, 0.5);
    border: 1px solid #EFEBE9;
    border-radius: 5px;
    position: relative;
}

.section-title {
    text-align: center;
    font-size: 24px;
    font-weight: normal;
    margin-top: 0;
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 1px solid #EFEBE9;
    color: #5D4037;
}

.data-container {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.menu-item {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px dashed #D7CCC8;
}

.item-name {
    font-weight: bold;
    font-size: 16px;
    color: #5D4037;
}

.item-value {
    font-size: 16px;
    font-style: italic;
    color: #795548;
}

.chartsContainer {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    gap: 30px;
}

.chart-wrapper {
    flex: 1 1 45%;
    min-width: 300px;
    margin-bottom: 20px;
}

.chart-title {
    text-align: center;
    font-size: 20px;
    font-weight: normal;
    margin: 0 0 20px;
    color: #5D4037;
}

.chart {
    height: 300px;
    border: 1px solid #EFEBE9;
    border-radius: 5px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

.client-stamp {
    position: absolute;
    bottom: 30px;
    right: 40px;
    transform: rotate(-15deg);
    font-family: 'Dancing Script', cursive;
    font-size: 24px;
    color: rgba(139, 69, 19, 0.3);
    border: 2px solid rgba(139, 69, 19, 0.3);
    border-radius: 5px;
    padding: 8px 20px;
}
.coupon-section {
    margin-top: 30px;
    text-align: center;
    padding: 20px;
    background-color: rgba(255, 255, 255, 0.7);
    border-radius: 8px;
    border: 1px dashed #D7CCC8;
}

.coupon-button {
    background: linear-gradient(135deg, #4CAF50, #2E7D32);
    color: white;
    border: none;
    border-radius: 25px;
    padding: 12px 25px;
    font-size: 16px;
    font-weight: 600;
    font-family: 'Playfair Display', serif;
    cursor: pointer;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
}

.coupon-button:hover {
    transform: translateY(-3px);
    box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
}

.coupon-button i {
    font-size: 18px;
}

.coupon-active {
    background-color: #E8F5E9;
    color: #2E7D32;
    padding: 15px;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    border: 1px solid #A5D6A7;
}

.coupon-active i {
    font-size: 22px;
    color: #4CAF50;
}

.coupon-progress {
    display: flex;
    flex-direction: column;
    gap: 10px;
    align-items: center;
}

.progress-bar {
    width: 100%;
    height: 12px;
    background-color: #EFEBE9;
    border-radius: 6px;
    overflow: hidden;
    position: relative;
}

.progress-fill {
    height: 100%;
    background: linear-gradient(to right, #8D6E63, #5D4037);
    border-radius: 6px;
    transition: width 0.5s ease-in-out;
}

.progress-text {
    font-size: 14px;
    color: #795548;
    font-style: italic;
}
/* Añadir estos estilos a la sección de estilos */

.progress-info {
  display: flex;
  justify-content: space-between;
  width: 100%;
  margin-bottom: 8px;
}

.progress-label {
  font-size: 14px;
  font-weight: 600;
  color: #5D4037;
}

.progress-total {
  font-size: 14px;
  color: #8D6E63;
  font-style: italic;
}

/* Mejorar la apariencia de la barra de progreso */
.progress-bar {
  width: 100%;
  height: 14px;
  background-color: #EFEBE9;
  border-radius: 7px;
  overflow: hidden;
  position: relative;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
}

.progress-fill {
  height: 100%;
  background: linear-gradient(to right, #8D6E63, #5D4037);
  border-radius: 7px;
  transition: width 0.5s ease-in-out;
  position: relative;
}

.progress-fill::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(
    45deg,
    rgba(255, 255, 255, 0.2) 25%,
    transparent 25%,
    transparent 50%,
    rgba(255, 255, 255, 0.2) 50%,
    rgba(255, 255, 255, 0.2) 75%,
    transparent 75%
  );
  background-size: 15px 15px;
  animation: move-stripes 1s linear infinite;
}

@keyframes move-stripes {
  0% { background-position: 0 0; }
  100% { background-position: 15px 0; }
}

.progress-text {
  font-size: 14px;
  color: #795548;
  font-style: italic;
  margin-top: 8px;
}
/* Añadir estos estilos a la sección de estilos */

.loyalty-section {
  background-color: rgba(255, 248, 225, 0.5);
  border: 1px dashed #FFD54F;
}

.loyalty-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 15px 0;
}

.loyalty-card {
  background: linear-gradient(135deg, #FFF8E1, #FFECB3);
  border-radius: 12px;
  padding: 20px;
  width: 100%;
  max-width: 450px;
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.05);
  text-align: center;
  border: 1px solid rgba(255, 193, 7, 0.2);
}

.loyalty-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-bottom: 15px;
  color: #FB8C00;
  font-size: 18px;
  font-weight: 600;
}

.loyalty-header i {
  font-size: 24px;
  color: #FFA000;
}

.loyalty-value {
  font-size: 48px;
  font-weight: 700;
  color: #E65100;
  margin: 10px 0;
  text-shadow: 1px 1px 0 rgba(0,0,0,0.1);
  font-family: 'Playfair Display', serif;
}

.loyalty-info {
  margin: 15px 0;
  padding: 8px 0;
  border-top: 1px dashed #FFD54F;
  border-bottom: 1px dashed #FFD54F;
  color: #795548;
  font-weight: 500;
}

.loyalty-explanation {
  margin-top: 15px;
  text-align: left;
  color: #795548;
  font-size: 14px;
}

.loyalty-explanation p {
  margin: 5px 0;
}

.loyalty-note {
  font-style: italic;
  font-size: 13px;
  color: #BF360C;
  margin-top: 10px;
}
/* Responsive */
@media (max-width: 768px) {
    .menu-card {
        padding: 20px;
        margin: 20px;
    }
    .coupon-button {
        padding: 10px 20px;
        font-size: 14px;
    }
    
    .coupon-active {
        padding: 12px;
        font-size: 14px;
    }
    .chartsContainer {
        flex-direction: column;
    }
    
    .chart-wrapper {
        width: 100%;
    }
    
    .menu-title h1 {
        font-size: 28px;
    }
    
    .section-title {
        font-size: 20px;
    }
    
    .client-stamp {
        font-size: 18px;
        bottom: 20px;
        right: 20px;
    }
}
</style>