import { onMounted, ref } from 'vue';

export const useScroll = (loadMoreItems) => {
    const loading = ref(false);

    const onScroll = () => {
        const container = document.documentElement || document.body;
        const scrollTop = container.scrollTop;
        const scrollHeight = container.scrollHeight;
        const clientHeight = container.clientHeight;

        if (scrollTop + clientHeight >= scrollHeight - 100 && !loading.value) {
            loading.value = true;
            loadMoreItems();
            loading.value = false;
        }
    };

    onMounted(() => {
        window.addEventListener('scroll', onScroll);
    });

    return {
        loading,
        onScroll
    };
};
