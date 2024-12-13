import React, { createContext, useContext, useState } from 'react';
import { getNgoBySlug } from '../services/client/NgoService';

const NgoContext = createContext();

export const NgoProvider = ({ children }) => {
    const [ngos, setNgos] = useState([]);
    const [selectedNgo, setSelectedNgo] = useState(null);

    const fetchNgoDetails = async (ngo_slug) => {
        try {
            const data = await getNgoBySlug(ngo_slug);
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
