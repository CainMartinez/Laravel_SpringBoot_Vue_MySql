import { useState, useEffect } from 'react';
import { getNgoBySlug } from '../services/client/NgoService';

const useFetchNgo = (ngoSlug) => {
    const [ngo, setNgo] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchNgo = async () => {
            try {
                setLoading(true);
                const data = await getNgoBySlug(ngoSlug);
                setNgo(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        if (ngoSlug) {
            fetchNgo();
        }
    }, [ngoSlug]);

    return { ngo, loading, error };
};

export default useFetchNgo;
