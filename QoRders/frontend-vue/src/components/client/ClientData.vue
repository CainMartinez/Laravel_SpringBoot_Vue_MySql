<template>
    <div class="personal-data">
        <h1>Datos Personales</h1>

        <div class="data-container">
            <p><strong>Nombre:</strong> {{ userData.firstName }} {{ userData.lastName }}</p>
            <p><strong>Email:</strong> {{ userData.email }}</p>
            <p><strong>Edad:</strong> {{ userData.age }}</p>
            <p><strong>Dirección:</strong> {{ userData.address }}</p>
            <p><strong>Bio:</strong> {{ userData.bio }}</p>
        </div>
    </div>
    <div class="metrics-data">
        <div class="chartsContainer">
            <div ref="donationsChart"></div>
            <div ref="reservationsChart"></div>
        </div>

        <!-- <p><strong>Feedback:</strong> {{ }}</p> -->
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
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
        backgroundColor: 'none',

    },
    title: {
        text: "Dinero donado",
    },
    xAxis: {
        categories: ["Donado", "Restante"],
    },
    yAxis: {
        title: {
            text: "Valores",
        },
    },
    series: [
        {
            name: 'Donado',
            colorByPoint: true,
            data: [
                {
                    name: 'Donado: ' + donationsAmount.value + ' €',
                    y: parseFloat(donationsAmount.value),
                    color: '#28a745', // Verde
                },
                {
                    name: 'Restante',
                    y: parseFloat(donationsRest.value),
                    color: '#6c757d', // Gris oscuro
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
        backgroundColor: 'none',

    },
    title: {
        text: "Reservas realizadas",
    },
    xAxis: {
        type: 'datetime', // Configura el eje X como fecha/hora
        title: {
            text: "Fecha de reserva",
        },
        labels: {
            format: '{value:%e %b}', // Formato del eje: "2 Dic"
        },
        tickInterval: 24 * 3600 * 1000, // Un tick por día (en milisegundos)
    },
    yAxis: {
        title: {
            text: "Número de personas",
        },
        min: 1,
        max: 10
    },
    series: [
        {
            name: 'Reservas',
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
</script>

<style scoped>
.personal-data {
    padding: 20px;
}

.data-container p {
    font-size: 16px;
    margin: 10px 0;
}

.metrics-data {
    padding: 20px;
}

.chartsContainer {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
}
</style>