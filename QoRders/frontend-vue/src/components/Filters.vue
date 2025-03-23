<template>
    <div class="filters-container" :class="countryThemeClass">
        <div class="menu-card">
            <div class="menu-header">
                <h3>Selección a tu gusto</h3>
                <div class="menu-ornament"></div>
            </div>
            
            <div class="menu-options">
                <div class="menu-section">
                    <span class="section-title">Ordenar por</span>
                    <div class="orderby-options">
                        <button class="menu-option" 
                               :class="{ active: localOrderBy === 'none' }" 
                               @click="updateOrderBy('none')">
                            <i class="pi pi-list"></i>
                            <span>Por defecto</span>
                        </button>
                        <button class="menu-option" 
                               :class="{ active: localOrderBy === 'asc' }" 
                               @click="updateOrderBy('asc')">
                            <i class="pi pi-sort-amount-down-alt"></i>
                            <span>Menor precio</span>
                        </button>
                        <button class="menu-option" 
                               :class="{ active: localOrderBy === 'desc' }" 
                               @click="updateOrderBy('desc')">
                            <i class="pi pi-sort-amount-up"></i>
                            <span>Mayor precio</span>
                        </button>
                    </div>
                </div>
                
                <div class="menu-divider"></div>
                
                <div class="menu-section">
                    <span class="section-title">Categorías</span>
                    <div class="category-options">
                        <button :class="['category-btn', { active: selectedType === 'STARTER' }]"
                                @click="updateSelectedType('STARTER')">
                            <i class="pi pi-circle-fill category-icon starter-icon"></i>
                            <span>Entrantes</span>
                        </button>
                        <button :class="['category-btn', { active: selectedType === 'MAIN_COURSE' }]"
                                @click="updateSelectedType('MAIN_COURSE')">
                            <i class="pi pi-circle-fill category-icon main-icon"></i>
                            <span>Principales</span>
                        </button>
                        <button :class="['category-btn', { active: selectedType === 'DESSERT' }]"
                                @click="updateSelectedType('DESSERT')">
                            <i class="pi pi-circle-fill category-icon dessert-icon"></i>
                            <span>Postres</span>
                        </button>
                        <button :class="['category-btn', { active: selectedType === 'DRINK' }]"
                                @click="updateSelectedType('DRINK')">
                            <i class="pi pi-circle-fill category-icon drink-icon"></i>
                            <span>Bebidas</span>
                        </button>
                    </div>
                </div>
                
                <div class="reset-container">
                    <button class="reset-btn" @click="resetFilters">
                        <i class="pi pi-replay"></i>
                        <span>Ver todo el menú</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, watch, computed } from 'vue';

const props = defineProps({
    selectedType: String,
    orderBy: String,
    theme: {
        type: String,
        default: 'default'
    }
});

const emit = defineEmits(['update:selectedType', 'update:orderBy', 'resetFilters']);

const localOrderBy = ref(props.orderBy || 'none');

watch(() => props.orderBy, (newOrderBy) => {
    localOrderBy.value = newOrderBy || 'none';
});

const updateOrderBy = (value) => {
    localOrderBy.value = value;
    emit('update:orderBy', value);
};

const updateSelectedType = (type) => {
    emit('update:selectedType', type);
};

const resetFilters = () => {
    emit('resetFilters');
};

// Convertir el tema a una clase CSS válida
const countryThemeClass = computed(() => {
    if (!props.theme) return '';
    
    // Convertir el tema a minúsculas y quitar caracteres especiales para CSS
    const theme = props.theme.toLowerCase()
        .replace('ñ', 'n')
        .replace('é', 'e')
        .replace('ó', 'o')
        .replace('í', 'i')
        .replace('á', 'a')
        .replace('ú', 'u');
    
    return `${theme}-theme`;
});
</script>

<style scoped>
.filters-container {
    width: 100%;
    max-width: 850px;
    margin-bottom: 25px;
    padding: 0 10px;
}

.menu-card {
    background-color: rgba(255, 255, 255, 0.95);
    border-radius: 12px;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
}

.menu-header {
    padding: 18px 20px;
    text-align: center;
    background-color: #f5f5f5;
    border-bottom: 1px solid #e0e0e0;
    position: relative;
}

.menu-header h3 {
    font-size: 1.5rem;
    margin: 0;
    font-weight: 600;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.menu-ornament {
    height: 10px;
    margin-top: 10px;
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="8" viewBox="0 0 100 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 L100 4" stroke="%23888" stroke-width="1" stroke-dasharray="1 5"/></svg>');
    background-repeat: repeat-x;
    background-size: 100px 8px;
    opacity: 0.5;
}

.menu-options {
    padding: 20px;
}

.menu-section {
    margin-bottom: 20px;
}

.section-title {
    display: block;
    font-size: 0.9rem;
    font-weight: 600;
    text-transform: uppercase;
    margin-bottom: 12px;
    color: #555;
    padding-left: 5px;
    border-left: 3px solid #ddd;
}

.orderby-options {
    display: flex;
    gap: 10px;
    flex-wrap: wrap;
}

.menu-option {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 15px;
    border: 1px solid #ddd;
    border-radius: 6px;
    background-color: #f9f9f9;
    color: #333;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all 0.2s ease;
}

.menu-option:hover {
    background-color: #f0f0f0;
}

.menu-option.active {
    background-color: #4a4a4a;
    color: white;
    border-color: #4a4a4a;
}

.menu-divider {
    height: 1px;
    background-color: #eaeaea;
    margin: 15px 0;
    position: relative;
}

.menu-divider::before {
    content: "♦";
    position: absolute;
    top: -10px;
    left: 50%;
    transform: translateX(-50%);
    background-color: white;
    padding: 0 15px;
    color: #aaa;
    font-size: 12px;
}

.category-options {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    justify-content: center;
}

.category-btn {
    flex: 1;
    min-width: 120px;
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
    padding: 12px;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    background-color: white;
    color: #333;
    font-size: 0.9rem;
    cursor: pointer;
    transition: all 0.25s ease;
}

.category-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.category-btn.active {
    background-color: #f5f5f5;
    border-color: #ccc;
    box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.1);
    font-weight: 600;
}

.category-icon {
    font-size: 1.2rem;
}

.starter-icon { color: #e67e22; }
.main-icon { color: #c0392b; }
.dessert-icon { color: #9b59b6; }
.drink-icon { color: #3498db; }

.reset-container {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.reset-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    background-color: transparent;
    border: 2px solid #ccc;
    border-radius: 30px;
    color: #666;
    font-size: 0.9rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s ease;
}

.reset-btn:hover {
    background-color: #f0f0f0;
    border-color: #aaa;
    color: #333;
}

.reset-btn i {
    font-size: 1rem;
}

/* Estilos específicos por país */

/* España */
.espana-theme .menu-card {
    background-color: rgba(255, 253, 245, 0.97);
    border: 2px solid #ffcc00;
    box-shadow: 0 8px 25px rgba(198, 11, 30, 0.18);
}

.espana-theme .menu-header {
    background-color: #c60b1e;
    border-bottom: 3px solid #ffcc00;
}

.espana-theme .menu-header h3 {
    color: #ffcc00;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.espana-theme .menu-ornament {
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="8" viewBox="0 0 100 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 L100 4" stroke="%23ffcc00" stroke-width="1" stroke-dasharray="3 3"/></svg>');
}

.espana-theme .section-title {
    color: #c60b1e;
    border-left: 3px solid #ffcc00;
}

.espana-theme .menu-option.active {
    background-color: #c60b1e;
    border-color: #c60b1e;
}

.espana-theme .menu-divider::before {
    content: "●";
    color: #c60b1e;
}

.espana-theme .category-btn.active {
    background-color: #fff5e0;
    border-color: #ffcc00;
    color: #c60b1e;
}

.espana-theme .reset-btn {
    border-color: #c60b1e;
    color: #c60b1e;
}

.espana-theme .reset-btn:hover {
    background-color: #c60b1e;
    color: white;
}

/* México */
.mexico-theme .menu-card {
    background-color: rgba(252, 246, 238, 0.97);
    border: 2px solid #ce1126;
    box-shadow: 0 8px 25px rgba(0, 99, 65, 0.18);
}

.mexico-theme .menu-header {
    background-color: #006341;
    border-bottom: 3px solid #ce1126;
}

.mexico-theme .menu-header h3 {
    color: white;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.mexico-theme .menu-ornament {
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="8" viewBox="0 0 100 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 L100 4" stroke="%23ce1126" stroke-width="1" stroke-dasharray="3 3"/></svg>');
}

.mexico-theme .section-title {
    color: #006341;
    border-left: 3px solid #ce1126;
}

.mexico-theme .menu-option.active {
    background-color: #006341;
    border-color: #006341;
}

.mexico-theme .menu-divider::before {
    content: "♣";
    color: #006341;
}

.mexico-theme .category-btn.active {
    background-color: #f8efe8;
    border-color: #ce1126;
    color: #006341;
}

.mexico-theme .reset-btn {
    border-color: #006341;
    color: #006341;
}

.mexico-theme .reset-btn:hover {
    background-color: #006341;
    color: white;
}

/* India */
.india-theme .menu-card {
    background-color: rgba(248, 241, 229, 0.97);
    border: 2px solid #ff9933;
    box-shadow: 0 8px 25px rgba(19, 136, 8, 0.18);
}

.india-theme .menu-header {
    background-color: #138808;
    border-bottom: 3px solid #ff9933;
}

.india-theme .menu-header h3 {
    color: white;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.india-theme .menu-ornament {
    background-image: url('data:image/svg+xml;utf8,<svg width="120" height="8" viewBox="0 0 120 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 C20 0, 40 8, 60 4 C80 0, 100 8, 120 4" stroke="%23ff9933" stroke-width="1" fill="none"/></svg>');
}

.india-theme .section-title {
    color: #000080;
    border-left: 3px solid #ff9933;
}

.india-theme .menu-option.active {
    background-color: #138808;
    border-color: #138808;
}

.india-theme .menu-divider::before {
    content: "✱";
    color: #ff9933;
}

.india-theme .category-btn.active {
    background-color: #fff9f0;
    border-color: #ff9933;
    color: #000080;
}

.india-theme .reset-btn {
    border-color: #ff9933;
    color: #000080;
}

.india-theme .reset-btn:hover {
    background-color: #ff9933;
    color: #000080;
}

/* Japón */
.japon-theme .menu-card {
    background-color: rgba(255, 255, 255, 0.97);
    border: 1px solid #ddd;
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
}

.japon-theme .menu-header {
    background-color: #bc002d;
    border-bottom: 2px solid #333;
}

.japon-theme .menu-header h3 {
    color: white;
    letter-spacing: 3px;
    font-weight: 300;
}

.japon-theme .menu-ornament {
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="8" viewBox="0 0 100 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 L100 4" stroke="%23333" stroke-width="1" stroke-dasharray="8 4"/></svg>');
}

.japon-theme .section-title {
    color: #bc002d;
    border-left: 3px solid #333;
    letter-spacing: 1.5px;
}

.japon-theme .menu-option.active {
    background-color: #bc002d;
    border-color: #bc002d;
}

.japon-theme .menu-divider::before {
    content: "〇";
    color: #bc002d;
}

.japon-theme .category-btn.active {
    background-color: #f8f8f8;
    border-color: #bc002d;
    color: #333;
}

.japon-theme .reset-btn {
    border-color: #333;
    color: #333;
}

.japon-theme .reset-btn:hover {
    background-color: #333;
    color: white;
}

/* Turquía */
.turquia-theme .menu-card {
    background-color: rgba(245, 241, 233, 0.97);
    border: 2px solid #e30a17;
    box-shadow: 0 8px 25px rgba(29, 94, 168, 0.18);
}

.turquia-theme .menu-header {
    background-color: #1d5ea8;
    border-bottom: 3px solid #e30a17;
}

.turquia-theme .menu-header h3 {
    color: white;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.turquia-theme .menu-ornament {
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="8" viewBox="0 0 100 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 L100 4" stroke="%23e30a17" stroke-width="1" stroke-dasharray="1 1"/></svg>');
}

.turquia-theme .section-title {
    color: #1d5ea8;
    border-left: 3px solid #e30a17;
}

.turquia-theme .menu-option.active {
    background-color: #1d5ea8;
    border-color: #1d5ea8;
}

.turquia-theme .menu-divider::before {
    content: "★";
    color: #e30a17;
}

.turquia-theme .category-btn.active {
    background-color: #f8f5f0;
    border-color: #e30a17;
    color: #1d5ea8;
}

.turquia-theme .reset-btn {
    border-color: #1d5ea8;
    color: #1d5ea8;
}

.turquia-theme .reset-btn:hover {
    background-color: #1d5ea8;
    color: white;
}

/* Italia */
.italia-theme .menu-card {
    background-color: rgba(247, 243, 238, 0.97);
    border: 2px solid #008C45;
    box-shadow: 0 8px 25px rgba(205, 33, 42, 0.18);
}

.italia-theme .menu-header {
    background-color: #cd212a;
    border-bottom: 3px solid #008C45;
}

.italia-theme .menu-header h3 {
    color: white;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
}

.italia-theme .menu-ornament {
    background-image: url('data:image/svg+xml;utf8,<svg width="100" height="8" viewBox="0 0 100 8" xmlns="http://www.w3.org/2000/svg"><path d="M0 4 L100 4" stroke="%23008C45" stroke-width="1" stroke-dasharray="5 5"/></svg>');
}

.italia-theme .section-title {
    color: #cd212a;
    border-left: 3px solid #008C45;
}

.italia-theme .menu-option.active {
    background-color: #cd212a;
    border-color: #cd212a;
}

.italia-theme .menu-divider::before {
    content: "❀";
    color: #008C45;
}

.italia-theme .category-btn.active {
    background-color: #f8f4ef;
    border-color: #008C45;
    color: #cd212a;
}

.italia-theme .reset-btn {
    border-color: #cd212a;
    color: #cd212a;
}

.italia-theme .reset-btn:hover {
    background-color: #cd212a;
    color: white;
}

@media (max-width: 768px) {
    .menu-options {
        padding: 15px;
    }
    
    .orderby-options {
        flex-direction: column;
    }
    
    .menu-option {
        width: 100%;
        justify-content: center;
    }
    
    .category-options {
        flex-direction: row;
        flex-wrap: wrap;
        justify-content: center;
    }
    
    .category-btn {
        flex: 0 0 calc(50% - 10px);
        min-width: 0;
    }
}

@media (max-width: 480px) {
    .menu-header h3 {
        font-size: 1.2rem;
    }
    
    .section-title {
        font-size: 0.8rem;
    }
    
    .category-btn {
        padding: 8px;
        font-size: 0.8rem;
    }
    
    .category-icon {
        font-size: 1rem;
    }
    
    .menu-option {
        font-size: 0.8rem;
        padding: 6px 10px;
    }
}
</style>