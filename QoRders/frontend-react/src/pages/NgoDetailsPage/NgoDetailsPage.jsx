import React from 'react';
import { useParams, Link } from 'react-router-dom';
import useFetchNgoDetails from '../../hooks/useFetchNgoDetails';
import './NgoDetailsPage.css';

const NgoDetailsPage = () => {
    const { slug } = useParams();
    const { ngo, loading, error } = useFetchNgoDetails(slug);

    if (loading) return <p>Cargando detalles de la ONG...</p>;
    if (error) return <p>Error: {error}</p>;

    // Dividir la descripción en partes
    const descriptionParts = ngo.description.split(';');

    console.log(ngo);

    return (
        <div className="ngo-details-page">
            {/* Encabezado */}
            <header className="ngo-header">
                <h1>{ngo.name}</h1>
                <img src={ngo.logoUrl} alt={`${ngo.name} Logo`} className="ngo-logo" />
            </header>

            {/* Sección "Nuestra función" */}
            <section className="ngo-section function-section">
                <div className="image-container">
                    <img src={ngo.imageUrl} alt="Principal" className="main-image" />
                </div>
                <div className="text-container">
                    <h2>Nuestra función</h2>
                    <p>{descriptionParts[0].trim()}</p>
                    <p>{descriptionParts[1].trim()}</p>
                </div>
            </section>
            <hr />
            <br />
            {/* Sección "Sobre nosotros" */}
            <section className="ngo-section about-section">
                <div className="text-container">
                    <h2>Sobre nosotros</h2>
                    <p><strong>País:</strong> {ngo.country}</p>
                    <p><strong>Email:</strong> {ngo.email}</p>
                    <p><strong>Teléfono:</strong> {ngo.phone_number || 'No disponible'}</p>
                    <p><strong>Web:</strong> <a href={ngo.website_url} target="_blank" rel="noopener noreferrer">{ngo.website_url}</a></p>
                </div>
                <div className="image-container">
                    <img src={ngo.descriptionImageUrl} alt="Secundaria" className="secondary-image" />
                </div>
            </section>
            <hr />
            <br />
            {/* Sección "Donar" */}
            <section className="ngo-section donate-section">
                <p className="donate-text">"Haz una diferencia, dona hoy."</p>
                <Link to={`/donaciones?ngo=${ngo.slug}`} className="ngo-donate-button">
                    Donar
                </Link>
            </section>
        </div>
    );
};

export default NgoDetailsPage;
