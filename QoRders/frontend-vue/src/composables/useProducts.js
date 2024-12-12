import { computed, ref } from 'vue';
import { useStore } from 'vuex';

export default function useProducts(room_slug) {
    const store = useStore();
    const products = computed(() => store.getters['storeProducts/getProductsByRoom']);
    const totalProducts = computed(() => store.getters['storeProducts/getTotalProducts']);

    // Filtros
    const selectedType = ref(null);
    const orderBy = ref('asc');

    // Filtrar productos
    const filteredProducts = computed(() => {
        let filtered = [...products.value];

        // Ordenar productos
        if (orderBy.value === 'asc') {
            filtered = filtered.sort((a, b) => a.unitPrice - b.unitPrice);
        } else {
            filtered = filtered.sort((a, b) => b.unitPrice - a.unitPrice);
        }

        // Filtrar por tipo de producto
        if (selectedType.value) {
            filtered = filtered.filter((product) => product.productType === selectedType.value);
        }

        return filtered;
    });

    // Funciones para actualizar filtros
    const setProductType = (type) => {
        selectedType.value = type;
        updateStore();
    };

    const setOrderBy = (order) => {
        orderBy.value = order;
        updateStore();
    };

    // Función para resetear los filtros
    const resetFilters = () => {
        selectedType.value = null;
        orderBy.value = 'asc';
        updateStore();
    };

    // Función para actualizar el store
    const updateStore = () => {
        if (!room_slug) {
            console.error("room_slug no está definido.");
            return;
        }

        const filters = {
            limit: 10,
            offset: 0,
            order: orderBy.value,
            productType: selectedType.value,
        };

        store.dispatch('storeProducts/fetchProductsByRoom', { room_slug: room_slug, filters });
    };

    return {
        products,
        totalProducts,
        filteredProducts,
        setProductType,
        setOrderBy,
        resetFilters,
        updateStore
    };
}
