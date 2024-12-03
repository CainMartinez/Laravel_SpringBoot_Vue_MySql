import React, { createContext, useContext, useState } from 'react';

const NgoContext = createContext();

export const NgoProvider = ({ children }) => {
    const [ngos, setNgos] = useState([]);

    return (
        <NgoContext.Provider value={{ ngos, setNgos }}>
            {children}
        </NgoContext.Provider>
    );
};

export const useNgoContext = () => useContext(NgoContext);
