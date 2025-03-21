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

const store = useStore();

// Datos del usuario
const userData = computed(() => store.getters['storeAuth/getUserData'].client);

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
    }, 0) * 0.05;
    return totalAmount.toFixed(2);
});

const donationsRest = computed(() => {
    return (100 - donationsAmount.value).toFixed(2);
});

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
                    name: donationsAmount.value + ' €',
                    y: parseFloat(donationsAmount.value),
                    color: '#8D6E63', // Marrón claro
                },
                {
                    name: 'Restante',
                    y: parseFloat(donationsRest.value),
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

/* Responsive */
@media (max-width: 768px) {
    .menu-card {
        padding: 20px;
        margin: 20px;
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