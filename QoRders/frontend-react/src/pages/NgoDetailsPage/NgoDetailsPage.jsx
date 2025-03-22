import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import useFetchNgoDetails from '../../hooks/useFetchNgoDetails';
import { FaArrowLeft, FaHandHoldingHeart, FaMapMarkerAlt, FaEnvelope, FaPhone, FaGlobe, FaQuoteLeft } from 'react-icons/fa';
import './NgoDetailsPage.css';

const NgoDetailsPage = () => {
    const { ngo_slug } = useParams();
    const { ngo, loading, error } = useFetchNgoDetails(ngo_slug);
    const [isDataLoaded, setIsDataLoaded] = useState(false);
    const [isHeaderVisible, setIsHeaderVisible] = useState(true);

    const handleBackButton = () => {
        window.history.back();
    };
    
    useEffect(() => {
        if (ngo) {
            setIsDataLoaded(true);
            // Scroll to top when page loads
            window.scrollTo(0, 0);
        }
        
        // Añadir efecto de scroll para el header
        const handleScroll = () => {
            const currentScrollPos = window.pageYOffset;
            setIsHeaderVisible(currentScrollPos < 100);
        };
        
        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, [ngo]);

    if (loading) return (
        <div className="loading-container">
            <div className="loading-icon"></div>
            <h2>Cargando información</h2>
            <p>Por favor espera mientras obtenemos los detalles de la organización...</p>
        </div>
    );
    
    if (error) return (
        <div className="error-container">
            <div className="error-icon">⚠️</div>
            <h2>No pudimos cargar los detalles</h2>
            <p>{error}</p>
            <button className="back-button" onClick={handleBackButton}>
                <FaArrowLeft /> Volver a la página anterior
            </button>
        </div>
    );

    if (!isDataLoaded) return (
        <div className="loading-container">
            <div className="loading-icon"></div>
            <h2>Preparando información</h2>
            <p>Estamos optimizando los datos para brindarte la mejor experiencia.</p>
        </div>
    );

    // Dividir la descripción en partes
    const descriptionParts = ngo.description?.split(';') || [];

    // Función refinada para determinar la categoría
    const getCategory = () => {
        const name = ngo.ngo_name?.toLowerCase() || '';
        const desc = ngo.description?.toLowerCase() || '';
        
        if (name.includes('hambre') || desc.includes('alimentación') || desc.includes('comida'))
            return 'Alimentación';
        if (name.includes('educa') || desc.includes('educación') || desc.includes('escuela'))
            return 'Educación';
        if (name.includes('salud') || desc.includes('médico') || desc.includes('hospital'))
            return 'Salud';
        if (name.includes('ambiente') || desc.includes('ecología') || desc.includes('planeta'))
            return 'Medioambiente';
            
        return 'Humanitaria';
    };

    return (
        <div className="ngo-details-page">
            {/* Hero Section Mejorado */}
            <div className={`ngo-hero ${isHeaderVisible ? '' : 'scrolled'}`}>
                <header className="ngo-header">
                    <img 
                        src={ngo.logo_url} 
                        alt={`${ngo.ngo_name} Logo`} 
                        className="ngo-logo" 
                        onError={(e) => {
                            e.target.src = 'https://via.placeholder.com/150?text=ONG';
                            console.warn(`Error loading logo for ${ngo.ngo_name}`);
                        }}
                    />
                    <span className="ngo-category-badge">{getCategory()}</span>
                    <h1>{ngo.ngo_name}</h1>
                </header>
            </div>

            <div className="ngo-content">
                {/* Sección "Nuestra función" */}
                <section className="ngo-section function-section">
                    <div className="image-container">
                        <img 
                            src={ngo.image_url} 
                            alt="Imagen de la organización" 
                            className="main-image"
                            onError={(e) => {
                                e.target.src = 'https://via.placeholder.com/700x400?text=Organización';
                                console.warn(`Error loading image for ${ngo.ngo_name}`);
                            }}
                        />
                    </div>
                    <div className="text-container">
                        <h2>Nuestra misión</h2>
                        <p>{descriptionParts[0]?.trim() || "Trabajamos incansablemente para mejorar la calidad de vida de las personas más vulnerables."}</p>
                        {descriptionParts.length > 1 && <p>{descriptionParts[1].trim()}</p>}
                        
                        <Link to={`/donations?ngo=${ngo_slug}`} className="donate-button">
                            <FaHandHoldingHeart /> Realizar una donación
                        </Link>
                    </div>
                </section>
                
                                {/* Sección "Contacto" (Reemplazar esta sección) */}
                <section className="ngo-section about-section">
                    <div className="image-container">
                        <img 
                            src={ngo.description_img_url || ngo.image_url} 
                            alt="Impacto de la organización" 
                            className="secondary-image"
                            onError={(e) => {
                                e.target.src = 'https://via.placeholder.com/700x400?text=Impacto';
                                console.warn(`Error loading description image for ${ngo.ngo_name}`);
                            }}
                        />
                    </div>
                    <div className="text-container">
                        <h2>Contacto y colaboración</h2>
                        <p>
                            <FaQuoteLeft style={{marginRight: '10px', color: 'var(--secondary-color)', fontSize: '1.2rem'}} />
                            Conecta con nosotros para descubrir cómo tu apoyo puede transformar vidas y comunidades enteras.
                        </p>
                        <div className="contact-info">
                            <div className="contact-item">
                                <div className="contact-icon">
                                    <FaMapMarkerAlt />
                                </div>
                                <div className="contact-content">
                                    <p className="contact-label">País</p>
                                    <p className="contact-value">{ngo.country || 'Internacional'}</p>
                                </div>
                            </div>
                            
                            <div className="contact-item">
                                <div className="contact-icon">
                                    <FaEnvelope />
                                </div>
                                <div className="contact-content">
                                    <p className="contact-label">Email</p>
                                    <p className="contact-value">{ngo.email || 'contacto@organización.org'}</p>
                                </div>
                            </div>
                            
                            <div className="contact-item">
                                <div className="contact-icon">
                                    <FaPhone />
                                </div>
                                <div className="contact-content">
                                    <p className="contact-label">Teléfono</p>
                                    <p className="contact-value">{ngo.phone_number || 'No disponible'}</p>
                                </div>
                            </div>
                            
                            <div className="contact-item">
                                <div className="contact-icon">
                                    <FaGlobe />
                                </div>
                                <div className="contact-content">
                                    <p className="contact-label">Web</p>
                                    <p className="contact-value">
                                        <a 
                                            href={ngo.website_url || '#'} 
                                            target="_blank" 
                                            rel="noopener noreferrer"
                                        >
                                            {ngo.website_url || 'Sitio web oficial'}
                                        </a>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
            
            <div className="back-button-container">
                <button 
                    className="back-button" 
                    onClick={handleBackButton}
                    aria-label="Volver a la página anterior"
                >
                    <FaArrowLeft /> <p class="text-back">Atrás</p>
                </button>
            </div>
        </div>
    );
};

export default NgoDetailsPage;  