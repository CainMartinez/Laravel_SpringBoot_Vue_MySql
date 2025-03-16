<template>
    <div class="calendar-container">
        <DatePicker v-model="selectedDate" :dateFormat="'dd-mm-yy'" :inline="true" class="white-calendar">
            <template #date="slotProps">
                <div :class="{'selectable-day': isFutureDate(slotProps.date), 'disabled-day': !isFutureDate(slotProps.date)}"
                    @click="selectDay(slotProps.date)">
                    {{ slotProps.date.day }}
                </div>
            </template>
        </DatePicker>
    </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';

const emit = defineEmits(['update:selectedDay']);
const selectedDate = ref(null);

// Función para convertir la fecha a formato YYYY-MM-DD
const translateDate = (date) => {
    const padZero = (num) => (num < 10 ? '0' + num : num);
    return `${date.year}-${padZero(date.month + 1)}-${padZero(date.day)}`;
};

// Obtener la fecha actual en formato YYYY-MM-DD
const today = new Date();
const todayString = translateDate({
    year: today.getFullYear(),
    month: today.getMonth(),
    day: today.getDate()
});

// Verifica si la fecha es hoy o en el futuro
const isFutureDate = (date) => {
    return translateDate(date) >= todayString;
};

// Emitir la fecha seleccionada solo si es hoy o en el futuro
const selectDay = (date) => {
    const translatedDate = translateDate(date);
    if (isFutureDate(date)) {
        emit('update:selectedDay', { day: translatedDate, isDisabled: false });
    }
};

// Función para aplicar estilos al fondo del calendario
const applyCalendarStyles = () => {
    setTimeout(() => {
        // Aplicar estilo al panel del calendario
        const calendarPanels = document.querySelectorAll('.p-datepicker-panel, .p-datepicker-calendar-container, .p-datepicker-header');
        calendarPanels.forEach(panel => {
            panel.style.backgroundColor = '#ffffff';
            panel.style.color = '#000000';
        });

        // Aplicar estilo al contenedor de la tabla
        const tableContainers = document.querySelectorAll('.p-datepicker-calendar-container');
        tableContainers.forEach(container => {
            container.style.backgroundColor = '#ffffff';
        });

        // Aplicar estilo al encabezado
        const headers = document.querySelectorAll('.p-datepicker-header');
        headers.forEach(header => {
            header.style.backgroundColor = '#ffffff';
            header.style.color = '#000000';
        });

        // Aplicar estilo a los días de la semana
        const weekdays = document.querySelectorAll('.p-datepicker-weekday, .p-datepicker-weekday-cell');
        weekdays.forEach(weekday => {
            weekday.style.backgroundColor = '#ffffff';
            weekday.style.color = '#000000';
        });

        // Asegurarse de que los botones tengan fondo blanco
        const buttons = document.querySelectorAll('.p-datepicker-prev-button, .p-datepicker-next-button');
        buttons.forEach(button => {
            button.style.backgroundColor = '#ffffff';
        });

        // Los días seleccionables y no seleccionables los dejamos como están
    }, 100);
};

onMounted(() => {
    // Inyectar estilos CSS específicos para el calendario
    const style = document.createElement('style');
    style.textContent = `
        /* Estilos para el fondo del calendario */
        .p-datepicker-panel,
        .p-datepicker-calendar-container,
        .p-datepicker-header,
        .p-datepicker-title,
        .p-datepicker-select-month,
        .p-datepicker-select-year {
            background-color: #ffffff !important;
            color: #000000 !important;
        }

        /* Estilos para los días de la semana */
        .p-datepicker-weekday,
        .p-datepicker-weekday-cell {
            background-color: #ffffff !important;
            color: #000000 !important;
        }

        /* Estilos para los botones del calendario */
        .p-datepicker-prev-button,
        .p-datepicker-next-button {
            background-color: #ffffff !important;
        }

        /* Mantener el estilo original para las celdas de los días */
        .p-datepicker-day-cell {
            background-color: transparent !important;
        }
    `;
    document.head.appendChild(style);

    // Aplicar estilos al montar el componente
    nextTick(() => {
        applyCalendarStyles();
    });

    // Observer para aplicar estilos cuando se renderice el calendario
    const observer = new MutationObserver((mutations) => {
        let needsUpdate = false;
        
        mutations.forEach(mutation => {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                mutation.addedNodes.forEach(node => {
                    if (node.nodeType === 1) { // Elemento DOM
                        if (
                            node.classList?.contains('p-datepicker-panel') ||
                            node.classList?.contains('p-datepicker-calendar-container')
                        ) {
                            needsUpdate = true;
                        }
                    }
                });
            }
        });
        
        if (needsUpdate) {
            applyCalendarStyles();
        }
    });
    
    observer.observe(document.body, { childList: true, subtree: true });
    
    // Limpiar al desmontar
    return () => observer.disconnect();
});
</script>

<style>
/* Estilos globales para el fondo del calendario */
.p-datepicker-panel,
.p-datepicker-calendar-container,
.p-datepicker-header {
    background-color: #ffffff !important;
    color: #000000 !important;
}

.p-datepicker-weekday,
.p-datepicker-weekday-cell {
    background-color: #ffffff !important;
    color: #000000 !important;
}

.p-datepicker-title,
.p-datepicker-select-month,
.p-datepicker-select-year {
    background-color: #ffffff !important;
    color: #000000 !important;
}

.p-datepicker-prev-button,
.p-datepicker-next-button {
    background-color: #ffffff !important;
}

/* Los elementos internos del botón también deben ser blancos */
.p-datepicker-prev-button span,
.p-datepicker-next-button span,
.p-datepicker-prev-button svg,
.p-datepicker-next-button svg {
    color: #000000 !important;
    fill: #000000 !important;
}
</style>

<style scoped>
.calendar-container {
    padding: 10px;
    border-radius: 8px;
}

.white-calendar {
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.selectable-day {
    background-color: #80cc80;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
}

.selectable-day:hover {
    background-color: #66a366;
}

.disabled-day {
    background-color: #e48383;
    border-radius: 50%;
    width: 30px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    cursor: not-allowed;
    opacity: 0.6;
}

/* Usar :deep para afectar a elementos renderizados por PrimeVue */
:deep(.p-datepicker) {
    background-color: #ffffff !important;
}

:deep(.p-datepicker-panel) {
    background-color: #ffffff !important;
}

:deep(.p-datepicker-header) {
    background-color: #ffffff !important;
    color: #000000 !important;
    border-bottom-color: #e9ecef !important;
}

:deep(.p-datepicker-calendar-container) {
    background-color: #ffffff !important;
}

:deep(.p-datepicker-calendar) {
    background-color: #ffffff !important;
}

:deep(.p-datepicker-weekday) {
    background-color: #ffffff !important;
    color: #000000 !important;
}

:deep(.p-datepicker-title) {
    background-color: #ffffff !important;
    color: #000000 !important;
}
</style>