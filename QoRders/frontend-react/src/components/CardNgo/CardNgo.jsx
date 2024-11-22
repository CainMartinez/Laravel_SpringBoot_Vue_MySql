import React from 'react';

// Recibe las props para mostrar los datos de cada ONG
const CardNgo = ({
    name,
    description,
    country,
    imageUrl,
    logoUrl,
    descriptionImageUrl
}) => {
    return (
        <div className="ngo-card">
            <h3>{name}</h3>
            <p><strong>Country:</strong> {country}</p>
            <p><strong>Description:</strong> {description}</p>

            {/* Imágenes */}
            <div className="ngo-images">
                {logoUrl && (
                    <img src={logoUrl} alt={`${name} logo`} className="ngo-logo" />
                )}
                {imageUrl && (
                    <img src={imageUrl} alt={`${name}`} className="ngo-main-image" />
                )}
                {descriptionImageUrl && (
                    <img
                        src={descriptionImageUrl}
                        alt={`${name} description`}
                        className="ngo-description-image"
                    />
                )}
            </div>
        </div>
    );
};

export default CardNgo;