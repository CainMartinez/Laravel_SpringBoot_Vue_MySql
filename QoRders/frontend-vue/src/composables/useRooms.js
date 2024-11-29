import { computed, ref } from 'vue';
import { useStore } from 'vuex';

export const useRooms = () => {
    const store = useStore();
    const allRooms = computed(() => store.getters['storeRooms/getRooms']);
    const visibleRooms = ref([]);
    const currentPage = ref(0);
    const pageSize = 1;

    const loadMoreRooms = () => {
        const start = currentPage.value * pageSize;
        const end = start + pageSize;

        visibleRooms.value.push(...allRooms.value.slice(start, end));
        currentPage.value++;
    };

    return {
        allRooms,
        visibleRooms,
        loadMoreRooms
    };
};
