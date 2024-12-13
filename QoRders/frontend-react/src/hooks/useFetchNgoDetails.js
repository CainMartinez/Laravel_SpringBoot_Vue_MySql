import { useState, useEffect } from 'react';
import { getNgoBySlug } from '../services/client/NgoService';

const useFetchNgo = (ngo_slug) => {
    const [ngo, setNgo] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchNgo = async () => {
            try {
                setLoading(true);
                const data = await getNgoBySlug(ngo_slug);
                setNgo(data.data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        if (ngo_slug) {
            fetchNgo();
        }
    }, [ngo_slug]);

    return { ngo, loading, error };
};

export default useFetchNgo;
