import React from 'react';
import { Link } from 'react-router-dom';
import { Card } from 'primereact/card';
import NgoCarousel from '../NgoCarousel/NgoCarousel';
import useNgoImages from '../../hooks/useNgoImages';
import './NgoCard.css';

const NgoCard = ({ ngo }) => {
    const descriptionParts = ngo.description.split(';');

    return (
        <Card className="ngo-card">
            <div className="ngo-card-content">
                <NgoCarousel images={useNgoImages(ngo)} />
                <div className="ngo-info">
                    <div className="ngo-header">
                        <h2>{ngo.ngo_name}</h2>
                        <img src={ngo.logo_url} alt={`${ngo.ngo_name} Logo`} className="ngo-logo" />
                    </div>
                    <p className="ngo-description">{descriptionParts[0].trim()}</p>
                    <div className="ngo-actions">
                        <Link to={`/ngos/${ngo.ngo_slug}`} className="ngo-view-more">
                            Ver más
                        </Link>
                    </div>
                </div>
            </div>
        </Card>
    );
};

export default NgoCard;
