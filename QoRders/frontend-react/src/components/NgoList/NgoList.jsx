import React from 'react';
import NgoCard from '../NgoCard/NgoCard';
import './NgoList.css';

const NgoList = ({ ngos }) => {
    if (!Array.isArray(ngos)) {
        return <div className="ngo-list">No NGOs available</div>;
    }

    return (
        <div className="ngo-list">
            {ngos.map((ngo) => (
                <NgoCard key={ngo.ngo_slug} ngo={ngo} />
            ))}
        </div>
    );
};

export default NgoList;
