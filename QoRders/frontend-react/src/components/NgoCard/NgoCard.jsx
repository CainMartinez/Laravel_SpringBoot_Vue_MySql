import React from 'react';
import { Link } from 'react-router-dom';
import { Card } from 'primereact/card';
import NgoCarousel from '../NgoCarousel/NgoCarousel';
import useNgoImages from '../../hooks/useNgoImages';
import { FaArrowRight, FaHeartbeat, FaHandHoldingHeart } from 'react-icons/fa';
import './NgoCard.css';

const NgoCard = ({ ngo }) => {
    const descriptionParts = ngo.description.split(';');
    const ngoImages = useNgoImages(ngo);
    
    // Función para determinar la categoría
    const getCategory = () => {
        if (ngo.category) return ngo.category;
        
        // Inferir categoría del nombre o descripción si no existe explícitamente
        const name = ngo.ngo_name.toLowerCase();
        const desc = ngo.description.toLowerCase();
        
        if (name.includes('hambre') || desc.includes('alimentación') || desc.includes('comida'))
            return 'Alimentación';
        if (name.includes('educa') || desc.includes('enseñanza') || desc.includes('escuela'))
            return 'Educación';
        if (name.includes('salud') || desc.includes('médico') || desc.includes('hospital'))
            return 'Salud';
        if (name.includes('ambiente') || desc.includes('ecología') || desc.includes('naturaleza'))
            return 'Medioambiente';
            
        return 'Humanitaria';
    };

    return (
        <Card className="ngo-card">
            <div className="ngo-card-content">
                <div className="ngo-carousel-container">
                    <NgoCarousel images={ngoImages} />
                </div>
                <div className="ngo-info">
                    <div className="ngo-header">
                        <span className="ngo-category">{getCategory()}</span>
                        <h2>{ngo.ngo_name}</h2>
                        <img 
                            src={ngo.logo_url || ngoImages[0]} 
                            alt={`${ngo.ngo_name} Logo`} 
                            className="ngo-logo"
                            onError={(e) => {
                                e.target.src = ngoImages[0];
                                console.warn(`Error loading logo for ${ngo.ngo_name}, using fallback`);
                            }}
                        />
                    </div>
                    <p className="ngo-description">
                        {descriptionParts[0]?.trim() || "Organización comprometida con la mejora de la calidad de vida de las personas más necesitadas."}
                    </p>
                    <div className="ngo-actions">
                        <Link to={`/ngos/${ngo.ngo_slug}`} className="ngo-view-more">
                            Ver más <FaArrowRight />
                        </Link>
                        <div className="ngo-impact-badge">
                            <FaHandHoldingHeart />
                            <span>Tu ayuda marca la diferencia</span>
                        </div>
                    </div>
                </div>
            </div>
        </Card>
    );
};

export default NgoCard;