import { ref, computed } from 'vue';

export default function usePagination() {
    const currentPage = ref(0);
    const pageSize = ref(10);
    const offset = computed(() => currentPage.value * pageSize.value);

    const onPageChange = (event) => {
        currentPage.value = event.page;
    };

    return {
        currentPage,
        pageSize,
        offset,
        onPageChange,
    };
}
