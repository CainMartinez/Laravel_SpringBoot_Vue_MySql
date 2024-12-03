import React from 'react';
import { Carousel } from 'primereact/carousel';
import './NgoCarousel.css';

const NgoCarousel = ({ images }) => {
    const carouselTemplate = (image) => (
        <img src={image.url} alt="NGO Image" className="carousel-image" />
    );

    return (
        <div className="ngo-carousel-container">
            <Carousel
                value={images}
                itemTemplate={carouselTemplate}
                numVisible={1}
                numScroll={1}
                showNavigators={false}
                showIndicators={false}
                circular
                className="ngo-carousel"
                autoplayInterval={5000}
            />
        </div>
    );
};

export default NgoCarousel;
