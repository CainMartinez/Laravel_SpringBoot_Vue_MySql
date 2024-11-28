<template>
    <div class="filters">
        <div class="filters-orderby">
            <label for="orderBy">Ordenar</label>
            <select id="orderBy" @change="updateOrderBy($event)">
                <option value="asc">Por más barato</option>
                <option value="desc">Por más caro</option>
            </select>
        </div>
        <div class="filters-radio">
            <label>Tipo de producto</label>
            <div class="filter-buttons">
                <button :class="{ active: selectedType === 'STARTER' }"
                    @click="updateSelectedType('STARTER')">Entrantes</button>
                <button :class="{ active: selectedType === 'MAIN_COURSE' }"
                    @click="updateSelectedType('MAIN_COURSE')">Principales</button>
                <button :class="{ active: selectedType === 'DESSERT' }"
                    @click="updateSelectedType('DESSERT')">Postres</button>
                <button :class="{ active: selectedType === 'DRINK' }"
                    @click="updateSelectedType('DRINK')">Bebidas</button>
                <button class="reset-button" @click="resetFilters">Eliminar filtros</button>
            </div>
        </div>
    </div>
</template>

<script setup>
const props = defineProps({
    selectedType: String,
    orderBy: String,
});

const emit = defineEmits(['update:selectedType', 'update:orderBy']);

const updateOrderBy = (event) => {
    emit('update:orderBy', event.target.value);
};

const updateSelectedType = (type) => {
    emit('update:selectedType', type);
};

const resetFilters = () => {
    emit('resetFilters');
};
</script>

<style scoped>
.filters {
    margin-bottom: 20px;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
    background-color: #fafafa;
    border-radius: 8px;
    padding: 15px;
    gap: 60px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    color: #333;
}

.filters label {
    font-size: medium;
}

.filters select,
.filters input[type="range"] {
    width: 100%;
    padding: 10px;
    background-color: #f1f1f1;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.filters .filters-orderby {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
}

.filters .filters-radio {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    gap: 20px;
    align-items: center;
}

.filter-buttons {
    display: flex;
    flex-direction: row;
    gap: 10px;
}

.filter-buttons button {
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    background-color: #f4f4f4;
    cursor: pointer;
    color: #555;
}

.filter-buttons button.active {
    background-color: #ccc;
    color: #333;
}

.filter-buttons .reset-button {
    background-color: red;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.reset-button:hover {
    background-color: #ff6666; 
}
</style>
