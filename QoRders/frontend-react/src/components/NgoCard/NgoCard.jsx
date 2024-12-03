import React from 'react';
import NgoCarousel from '../NgoCarousel/NgoCarousel';
import { Card } from 'primereact/card';
import useNgoImages from '../../hooks/useNgoImages';
import './NgoCard.css';

const NgoCard = ({ ngo }) => {
    return (
        <Card className="ngo-card">
            <div className="ngo-card-content">
                <NgoCarousel images={useNgoImages(ngo)} />
                <div className="ngo-info">
                    <div className="ngo-header">
                        <h2>{ngo.name}</h2>
                        <img src={ngo.logoUrl} alt={`${ngo.name} Logo`} className="ngo-logo" />
                    </div>
                    <p className="ngo-description">{ngo.description}</p>
                </div>
            </div>
        </Card>
    );
};

export default NgoCard;
