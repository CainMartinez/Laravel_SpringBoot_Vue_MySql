import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import useFetchNgoDetails from '../../hooks/useFetchNgoDetails';
import './NgoDetailsPage.css';

const NgoDetailsPage = () => {
    const { ngo_slug } = useParams();
    const { ngo, loading, error } = useFetchNgoDetails(ngo_slug);
    const [isDataLoaded, setIsDataLoaded] = useState(false);

    useEffect(() => {
        if (ngo) {
            setIsDataLoaded(true);
        }
    }, [ngo]);

    if (loading) return <p>Cargando detalles de la ONG...</p>;
    if (error) return <p>Error: {error}</p>;

    if (!isDataLoaded) return <p>No se encontraron detalles de la ONG. Por favor, espera a que carguen los datos.</p>;

    // Dividir la descripción en partes
    const descriptionParts = ngo.description.split(';');

    return (
        <div className="ngo-details-page">
            {/* Encabezado */}
            <header className="ngo-header">
                <h1>{ngo.ngo_name}</h1>
                <img src={ngo.logo_url} alt={`${ngo.ngo_name} Logo`} className="ngo-logo" />
            </header>

            {/* Sección "Nuestra función" */}
            <section className="ngo-section function-section">
                <div className="image-container">
                    <img src={ngo.image_url} alt="Principal" className="main-image" />
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
                    <img src={ngo.description_img_url} alt="Secundaria" className="secondary-image" />
                </div>
            </section>
            <hr />
            <br />
            {/* Sección "Donar" */}
            <section className="ngo-section donate-section">
                <p className="donate-text">"Haz una diferencia, dona hoy."</p>
                <Link to={`/donaciones?ngo=${ngo.ngo_slug}`} className="ngo-donate-button">
                    Donar
                </Link>
            </section>
        </div>
    );
};

export default NgoDetailsPage;
