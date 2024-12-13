import { useState } from 'react';
import { submitDonation } from '../services/client/DonationsService';

const useDonation = () => {
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);

    const handleDonation = async (donationData) => {
        setLoading(true);
        setError(null);

        try {
            const response = await submitDonation(donationData);
            return response;
        } catch (err) {
            setError(err);
            throw err;
        } finally {
            setLoading(false);
        }
    };

    return { handleDonation, loading, error };
};

export default useDonation;
