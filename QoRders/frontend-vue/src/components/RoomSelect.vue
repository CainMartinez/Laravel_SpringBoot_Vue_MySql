<template>
    <div class="room-select">
        <label for="room">Selecciona tu sala:</label>
        <Select v-model="selectedRoom" :options="rooms" optionLabel="name" placeholder="Selecciona una sala"
            class="w-full md:w-56 light-mode-select" @update:modelValue="changeRoom" @click="forceStylesUpdate">
        </Select>
    </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue';

const props = defineProps({
    rooms: Array
});

const selectedRoom = ref(null);

const emit = defineEmits(['update:selectedRoom']);
const changeRoom = (value) => {
    emit('update:selectedRoom', value.name);
};

// Función específica para los elementos problemáticos
const forceStylesUpdate = () => {
    setTimeout(() => {
        // Elemento UL específico
        const lists = document.querySelectorAll('.p-select-list');
        lists.forEach(list => {
            list.style.backgroundColor = '#ffffff';
            list.style.color = '#000000';
        });

        // SVG y sus componentes
        const svgs = document.querySelectorAll('svg.p-select-dropdown-icon');
        svgs.forEach(svg => {
            svg.style.color = '#000000';
            svg.style.fill = '#000000';
            
            // También afectar directamente al path dentro del SVG
            const paths = svg.querySelectorAll('path');
            paths.forEach(path => {
                path.setAttribute('fill', '#000000');
            });
        });

        // Elemento LI y spans dentro de ellos
        const options = document.querySelectorAll('.p-select-option');
        options.forEach(option => {
            option.style.backgroundColor = '#ffffff';
            option.style.color = '#000000';
            
            const spans = option.querySelectorAll('span');
            spans.forEach(span => {
                span.style.backgroundColor = '#ffffff';
                span.style.color = '#000000';
            });
        });

        // Atacar específicamente el div.p-select-dropdown
        const dropdowns = document.querySelectorAll('.p-select-dropdown');
        dropdowns.forEach(dropdown => {
            dropdown.style.cssText = 'background-color: #ffffff !important;';
        });

        // Otros elementos que podrían necesitar estilos
        const allElements = document.querySelectorAll('.p-dropdown, .p-dropdown-panel, .p-dropdown-items, .p-dropdown-items-wrapper, .p-dropdown-label, .p-dropdown-trigger, .p-select-panel');
        allElements.forEach(el => {
            el.style.backgroundColor = '#ffffff';
            el.style.color = '#000000';
        });
    }, 50);

    // Repetir la operación varias veces para asegurar que capture los elementos cuando aparezcan
    setTimeout(updateProblemElements, 100);
    setTimeout(updateProblemElements, 200);
    setTimeout(updateProblemElements, 300);
};

// Función especializada para atacar los elementos problemáticos
const updateProblemElements = () => {
    // Atacar específicamente el div.p-select-dropdown
    const selectDropdowns = document.querySelectorAll('.p-select-dropdown');
    selectDropdowns.forEach(dropdown => {
        dropdown.style.cssText = 'background-color: #ffffff !important;';
    });
    
    // Atacar específicamente las UL con ID que contienen "list"
    const idLists = Array.from(document.querySelectorAll('ul[id*="list"]'));
    idLists.forEach(list => {
        list.style.cssText = 'background-color: #ffffff !important; color: #000000 !important;';
        
        // También modificar todos los elementos hijos
        Array.from(list.children).forEach(child => {
            child.style.cssText = 'background-color: #ffffff !important; color: #000000 !important;';
            
            // Y los spans dentro de ellos
            const spans = child.querySelectorAll('span');
            spans.forEach(span => {
                span.style.cssText = 'background-color: #ffffff !important; color: #000000 !important;';
            });
        });
    });

    // Atacar específicamente los SVG con data-pc-section="dropdownicon"
    const dropdownIcons = document.querySelectorAll('svg[data-pc-section="dropdownicon"]');
    dropdownIcons.forEach(svg => {
        svg.style.cssText = 'color: #000000 !important; fill: #000000 !important;';
        
        // Y los paths dentro de ellos
        const paths = svg.querySelectorAll('path');
        paths.forEach(path => {
            path.setAttribute('fill', '#000000');
        });
        
        // También el contenedor padre del SVG
        if (svg.parentNode) {
            svg.parentNode.style.cssText = 'background-color: #ffffff !important;';
        }
    });
};

onMounted(() => {
    // Inyectar estilos específicos para los elementos problemáticos
    const style = document.createElement('style');
    style.textContent = `
        /* Para el UL específico */
        ul.p-select-list,
        ul[id*="list"] {
            background-color: #ffffff !important;
            color: #000000 !important;
        }

        /* Para el div.p-select-dropdown */
        .p-select-dropdown {
            background-color: #ffffff !important;
        }

        /* Para el SVG */
        svg.p-icon.p-select-dropdown-icon,
        svg[data-pc-section="dropdownicon"] {
            color: #000000 !important;
            fill: #000000 !important;
        }

        /* Para el path dentro del SVG */
        svg[data-pc-section="dropdownicon"] path {
            fill: #000000 !important;
        }

        /* Para background general de todos los elementos relevantes */
        .p-dropdown,
        .p-dropdown-panel,
        .p-dropdown-items,
        .p-dropdown-items-wrapper,
        .p-dropdown-label,
        .p-dropdown-trigger,
        .p-select-panel,
        .p-select-items,
        .p-select-items-wrapper,
        .p-select-label,
        .p-select-option,
        .p-select-option-label,
        .p-select-list,
        .p-select-dropdown {
            background-color: #ffffff !important;
            color: #000000 !important;
        }
    `;
    document.head.appendChild(style);
    
    // Aplicar estilos iniciales
    nextTick(() => {
        forceStylesUpdate();
        updateProblemElements();
    });
    
    // Configurar observer específico para los elementos problemáticos
    const observer = new MutationObserver((mutations) => {
        let needsUpdate = false;
        
        mutations.forEach(mutation => {
            if (mutation.type === 'childList' && mutation.addedNodes.length > 0) {
                // Revisar si alguno de los nodos añadidos es uno que nos interesa
                mutation.addedNodes.forEach(node => {
                    if (node.nodeType === 1) { // Elemento DOM
                        if (
                            node.classList?.contains('p-select-list') ||
                            node.classList?.contains('p-select-dropdown') ||
                            (node.id && node.id.includes('list')) ||
                            node.tagName === 'SVG' ||
                            node.classList?.contains('p-select-option')
                        ) {
                            needsUpdate = true;
                        }
                    }
                });
            }
        });
        
        if (needsUpdate) {
            forceStylesUpdate();
            updateProblemElements();
        }
    });
    
    observer.observe(document.body, { childList: true, subtree: true });
    
    // Limpiar al desmontar
    return () => observer.disconnect();
});

// Evento para manejar cambios del tema del sistema
if (typeof window !== 'undefined') {
    window.addEventListener('load', () => {
        forceStylesUpdate();
        updateProblemElements();
    });
    
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    mediaQuery.addEventListener('change', () => {
        forceStylesUpdate();
        updateProblemElements();
    });
}
</script>

<style>
/* Estilos globales para garantizar que afecten a elementos fuera del componente */
ul.p-select-list,
ul[id*="list"],
.p-select-list {
    background-color: #ffffff !important;
    color: #000000 !important;
}

.p-select-option,
li.p-select-option {
    background-color: #ffffff !important;
    color: #000000 !important;
}

.p-select-option-label {
    background-color: #ffffff !important;
    color: #000000 !important;
}

/* Estilo específico para el div.p-select-dropdown */
.p-select-dropdown {
    background-color: #ffffff !important;
}

svg.p-icon.p-select-dropdown-icon,
svg[data-pc-section="dropdownicon"] {
    color: #000000 !important;
    fill: #000000 !important;
    background-color: transparent !important;
}

svg[data-pc-section="dropdownicon"] path {
    fill: #000000 !important;
}

/* Para el contenedor del icono */
div > svg.p-icon.p-select-dropdown-icon,
div > svg[data-pc-section="dropdownicon"] {
    background-color: #ffffff !important;
}

/* Para las opciones al hacer hover */
.p-dropdown-item:hover,
.p-select-option:hover {
    background-color: #f0f0f0 !important;
    color: #000000 !important;
}

/* Para las opciones seleccionadas */
.p-highlight,
.p-dropdown-item.p-highlight,
.p-select-option[data-p-selected="true"],
.p-select-option[data-p-focused="true"] {
    background-color: #e6f7ff !important;
    color: #000000 !important;
}
</style>

<style scoped>
.room-select {
    margin: 20px 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: 10px;
    font-size: 18px;
}

@media (max-width: 768px) {
    .room-select {
        font-size: 16px;
        gap: 8px;
    }
}
form input,
form input:focus {
  background-color: #ffffff !important;
  color: #333 !important;
}
</style>