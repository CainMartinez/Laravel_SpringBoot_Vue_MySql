import React, { createContext, useContext, useState } from 'react';
import { getNgoBySlug } from '../services/client/NgoService';

const NgoContext = createContext();

export const NgoProvider = ({ children }) => {
    const [ngos, setNgos] = useState([]);
    const [selectedNgo, setSelectedNgo] = useState(null);

    const fetchNgoDetails = async (ngoSlug) => {
        try {
            const data = await getNgoBySlug(ngoSlug);
            setSelectedNgo(data);
        } catch (error) {
            console.error('Error fetching NGO details:', error.message);
            throw error;
        }
    };

    return (
        <NgoContext.Provider value={{ ngos, setNgos, selectedNgo, fetchNgoDetails }}>
            {children}
        </NgoContext.Provider>
    );
};

export const useNgoContext = () => useContext(NgoContext);
