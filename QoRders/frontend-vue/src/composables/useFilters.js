import { ref, computed } from 'vue';

export default function useFilters(products, updateStore) {
     // Estado de los filtros
     const selectedType = ref(null);
     const orderBy = ref('none');

     // Filtrar productos
     const filteredProducts = computed(() => {
          if (!products.value) return [];

          let filtered = [...products.value];

          // Ordenar productos
          if (orderBy.value === 'asc') {
               filtered = filtered.sort((a, b) => a.unitPrice - b.unitPrice);
          } else if (orderBy.value === 'desc') {
               filtered = filtered.sort((a, b) => b.unitPrice - a.unitPrice);
          } else if (orderBy.value === null || orderBy.value === 'none') {
               filtered = filtered;
          }

          // Filtrar por tipo de producto
          if (selectedType.value) {
               filtered = filtered.filter((product) => product.productType === selectedType.value);
          }

          return filtered;
     });

     // Funciones para actualizar filtros
     const setProductType = (type, room_slug) => {
          selectedType.value = type;
          updateStore(room_slug);
     };

     const setOrderBy = (order, room_slug) => {
          orderBy.value = order;
          updateStore(room_slug);
     };

     // Función para resetear los filtros
     const resetFilters = (room_slug) => {
          selectedType.value = null;
          orderBy.value = null;
          updateStore(room_slug);
     };

     return {
          selectedType,
          orderBy,
          filteredProducts,
          setProductType,
          setOrderBy,
          resetFilters,
     };
}
