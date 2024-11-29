import { ref } from 'vue';

export default function useScroll({ totalItems, pageSize }) {
    const currentPage = ref(0);
    const loading = ref(false);
    const visibleItems = ref([]);
    
    const loadMoreItems = () => {
        if (loading.value) return;
        loading.value = true;

        setTimeout(() => {
            const start = currentPage.value * pageSize;
            const end = start + pageSize;
            visibleItems.value.push(...totalItems.value.slice(start, end));
            currentPage.value++;

            loading.value = false;
        }, 500);
    };

    return { visibleItems, loadMoreItems, loading };
}