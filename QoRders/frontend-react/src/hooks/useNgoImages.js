import { useMemo } from 'react';

const useNgoImages = (ngo) => {
    return useMemo(() => {
        const images = [];
        if (ngo.image_url) images.push({ url: ngo.image_url });
        if (ngo.description_img_url) images.push({ url: ngo.description_img_url });
        return images;
    }, [ngo]);
};

export default useNgoImages;