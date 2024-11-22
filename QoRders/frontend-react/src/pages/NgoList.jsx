import React, { useEffect, useState } from 'react';
import CardNgo from '../components/CardNgo/CardNgo';
import '../components/CardNgo/CardNgo.css';

const NgoList = () => {
    const [ngos, setNgos] = useState([]);

    useEffect(() => {
        const fetchNgos = async () => {
            try {
                const response = await fetch(`${import.meta.env.VITE_API_BASE_URL}/api/ngos`);
                if (!response.ok) {
                    throw new Error('Error fetching NGOs');
                }
                const data = await response.json();
                console.log('Data fetched from server:', data);
                setNgos(data);
            } catch (error) {
                console.error('Error fetching NGOs:', error);
            }
        };

        fetchNgos();
    }, []);

    return (
        <div>
            <h1>NGO List</h1>
            {ngos.map((ngo) => (
                <CardNgo
                    key={ngo.uuid}
                    name={ngo.name}
                    description={ngo.description}
                    country={ngo.country}
                    uuid={ngo.uuid}
                    slug={ngo.slug}
                    logoUrl={ngo.logoUrl}
                    imageUrl={ngo.imageUrl}
                    descriptionImageUrl={ngo.descriptionImageUrl}
                />
            ))}
        </div>
    );
};

export default NgoList;