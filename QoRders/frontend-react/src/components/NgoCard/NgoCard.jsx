import React from 'react';
import { Link } from 'react-router-dom';
import { Card } from 'primereact/card';
import NgoCarousel from '../NgoCarousel/NgoCarousel';
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
                    <div className="ngo-actions">
                        <Link to={`/ngos/${ngo.slug}`} className="ngo-view-more">
                            Ver más
                        </Link>
                    </div>
                </div>
            </div>
        </Card>
    );
};

export default NgoCard;
