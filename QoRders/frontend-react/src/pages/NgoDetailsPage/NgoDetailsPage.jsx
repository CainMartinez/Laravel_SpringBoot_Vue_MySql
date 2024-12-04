import React from 'react';
import { useParams, Link } from 'react-router-dom';
import useFetchNgoDetails from '../../hooks/useFetchNgoDetails';
import NgoCarousel from '../../components/NgoCarousel/NgoCarousel';
import './NgoDetailsPage.css';

const NgoDetailsPage = () => {
    const { slug } = useParams();
    const { ngo, loading, error } = useFetchNgoDetails(slug);
    const images = ngo ? [{ url: ngo.imageUrl }, { url: ngo.descriptionImageUrl }] : [];

    if (loading) return <p>Cargando detalles de la ONG...</p>;
    if (error) return <p>Error: {error}</p>;

    return (
        <div className="ngo-details-page">
            <div className="ngo-details-content">
                {/* Sección de información a la izquierda */}
                <div className="ngo-info-section">
                    <h1>{ngo.name}</h1>
                    <p>{ngo.description}</p>
                    <img src={ngo.logoUrl} alt={`${ngo.name} Logo`} className="ngo-logo" />
                    <Link to={`/donaciones?ngo=${ngo.slug}`} className="ngo-donate-button">
                        Donar
                    </Link>
                </div>

                {/* Carrusel a la derecha */}
                <div className="ngo-carousel-section">
                    <NgoCarousel images={images} />
                </div>
            </div>
        </div>
    );
};

export default NgoDetailsPage;
