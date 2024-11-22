import React from 'react';
import { Carousel } from 'primereact/carousel';
import './CardNgo.css';

const CardNgo = ({ name, description, country, imageUrl, logoUrl, descriptionImageUrl }) => {
    // Lista de imágenes para el carrusel
    const images = [
        { src: imageUrl, alt: `${name} - Main Image` },
        { src: logoUrl, alt: `${name} - Logo` },
        { src: descriptionImageUrl, alt: `${name} - Description Image` },
    ];

    // Plantilla del carrusel
    const imageTemplate = (image) => {
        return (
            <div className="ngo-carousel-item">
                <img src={image.src} alt={image.alt} className="ngo-carousel-image" />
            </div>
        );
    };

    return (
        <div className="ngo-card">
            <h3>{name}</h3>
            <p>
                <strong>Country:</strong> {country}
            </p>
            <p>
                <strong>Description:</strong> {description}
            </p>
            <Carousel
                value={images}
                numVisible={1}
                numScroll={1}
                orientation="vertical"
                verticalViewPortHeight="13em"
                itemTemplate={imageTemplate}
            />
        </div>
    );
};

export default CardNgo;