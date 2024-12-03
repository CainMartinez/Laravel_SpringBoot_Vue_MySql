import { useState, useEffect } from 'react';
import { getNgos } from '../services/client/NgoService';

const useFetchNgos = () => {
    const [ngos, setNgos] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        const fetchNgos = async () => {
            try {
                const data = await getNgos();
                setNgos(data);
            } catch (err) {
                setError(err.message);
            } finally {
                setLoading(false);
            }
        };

        fetchNgos();
    }, []);

    return { ngos, loading, error };
};

export default useFetchNgos;
