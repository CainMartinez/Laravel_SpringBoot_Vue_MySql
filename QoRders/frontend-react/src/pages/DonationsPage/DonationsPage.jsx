import React, { useEffect, useState } from 'react';
import { Carousel } from 'primereact/carousel';
import { Card } from 'primereact/card';
import './DonationsPage.css';

const DonationsPage = () => {
    const [ngos, setNgos] = useState([]);

    // Simulamos la carga de datos desde una API
    useEffect(() => {
        const fetchNgos = async () => {
            try {
                const response = await fetch(`${import.meta.env.VITE_API_BASE_URL}/api/ngos`);
                const data = await response.json();
                console.log('Data fetched from server:', data);
                setNgos(data);
            } catch (error) {
                console.error('Error fetching NGOs:', error);
            }
        };

        fetchNgos();
    }, []);

    // Genera las imágenes para el carrusel de cada ONG
    const generateCarouselImages = (ngo) => {
        const images = [];
        if (ngo.imageUrl) images.push({ url: ngo.imageUrl });
        if (ngo.descriptionImageUrl) images.push({ url: ngo.descriptionImageUrl });
        console.log('Images for carousel:', images);
        return images;
    };

    // Plantilla del carrusel dentro de la tarjeta
    const carouselTemplate = (image) => {
        return <img src={image.url} alt="NGO Image" className="carousel-image" />;
    };


    // Genera la lista de cards con el carrusel dentro de cada una
    return (
        <div className="donations-page">
            <h2>Organizaciones a las que apoyamos</h2>
            <div className="ngo-list">
                {ngos.map((ngo) => (
                    <Card key={ngo.name} className="ngo-card">
                        <div className="ngo-card-content">
                            <div className="ngo-carousel-container">
                                <Carousel
                                    value={generateCarouselImages(ngo)}
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
                            <div className="ngo-info">
                                <div className="ngo-header">
                                    <h2>{ngo.name}</h2>
                                    <img
                                        src={ngo.logoUrl}
                                        alt={`${ngo.name} Logo`}
                                        className="ngo-logo"
                                    />
                                </div>
                                <p className="ngo-description">{ngo.description}</p>
                            </div>
                        </div>
                    </Card>
                ))}
            </div>
        </div>
    );
};

export default DonationsPage;
