import { ref } from 'vue';

export default function useUserType() {
    const selectedType = ref('cliente');

    const setUserType = (type) => {
        selectedType.value = type;
    };

    return {
        selectedType,
        setUserType
    };
}
