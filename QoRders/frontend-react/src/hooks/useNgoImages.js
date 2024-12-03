import { useMemo } from 'react';

const useNgoImages = (ngo) => {
    return useMemo(() => {
        const images = [];
        if (ngo.imageUrl) images.push({ url: ngo.imageUrl });
        if (ngo.descriptionImageUrl) images.push({ url: ngo.descriptionImageUrl });
        return images;
    }, [ngo]);
};

export default useNgoImages;