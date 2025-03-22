import React, { useState, useEffect, useRef } from 'react';
import { useLocation } from 'react-router-dom';
import useFetchNgos from '../../hooks/useFetchNgos';
import useDonation from '../../hooks/useDonation';
import DonationsForm from '../../components/DonationsForm/DonationsForm';
import Modal from '../../components/Modal/Modal';
import { FaHeart, FaArrowLeft, FaHandHoldingHeart, FaHandsHelping, FaCheckCircle, FaInfoCircle } from 'react-icons/fa';
import './DonationsPage.css';

const DonationsPage = () => {
    const { ngos, loading: loadingNgos, error: errorNgos } = useFetchNgos();
    const { handleDonation, loading: loadingDonation, error: errorDonation } = useDonation();
    const [modalState, setModalState] = useState({ open: false, success: false, message: '' });
    const [selectedNgo, setSelectedNgo] = useState(null);
    const formRef = useRef(null);
    
    // Obtener parámetros de URL para preseleccionar ONG
    const location = useLocation();
    const queryParams = new URLSearchParams(location.search);
    const ngoSlug = queryParams.get('ngo');
    
    useEffect(() => {
        if (ngos && ngoSlug) {
            const matchedNgo = ngos.find(ngo => ngo.slug === ngoSlug);
            if (matchedNgo) {
                setSelectedNgo(matchedNgo);
            }
        }
        
        // Aplicar comportamiento de desplazamiento suave
        document.documentElement.style.scrollBehavior = 'smooth';
        
        return () => {
            document.documentElement.style.scrollBehavior = 'auto';
        };
    }, [ngos, ngoSlug]);

        // Solo necesitamos actualizar la parte donde se maneja el Modal y la donación exitosa
    
    const handleFormSubmit = async (formData) => {
        try {
            const donationData = {
                ngo_slug: formData.ngo_slug,
                customer_username: formData.donorName,
                quantity: formData.amount,
            };
    
            await handleDonation(donationData);
            setModalState({ 
                open: true, 
                success: true, 
                message: '¡Gracias por tu generosidad! Tu contribución de €' + formData.amount + ' ha sido procesada con éxito y será destinada a apoyar el trabajo de la organización seleccionada. Tu donación tendrá un impacto directo en las vidas de quienes más lo necesitan.'
            });
        } catch (error) {
            const errorMessage = typeof error === 'object' && error.message 
                ? error.message 
                : 'Ha ocurrido un error al procesar tu donación. Por favor, verifica la información e inténtalo de nuevo.';
            setModalState({ open: true, success: false, message: errorMessage });
        }
    };
    
    const handleBackButton = () => {
        window.location.href = '/home';
    };
    
    const scrollToForm = () => {
        if (formRef.current) {
            formRef.current.scrollIntoView();
        }
    };

    const renderLoadingState = () => (
        <div className="donations-loading">
            <div className="loading-spinner"></div>
            <p>Cargando información de organizaciones...</p>
        </div>
    );

    const renderErrorState = () => (
        <div className="donations-error">
            <h2>No pudimos cargar las organizaciones</h2>
            <p>{errorNgos}</p>
            <button className="retry-button" onClick={() => window.location.reload()}>
                Reintentar
            </button>
        </div>
    );

    if (loadingNgos) return renderLoadingState();
    if (errorNgos) return renderErrorState();

    return (
        <div className="donations-page">
            <div className="donations-hero">
                <div className="donations-hero-content">
                    <FaHandHoldingHeart className="donations-hero-icon" />
                    <h1>Tu Donación, Su Esperanza</h1>
                    <p>Cada aporte, por pequeño que sea, tiene el poder de transformar vidas. Únete a nuestra comunidad solidaria y sé parte del cambio que queremos ver en el mundo.</p>
                    <a href="#donationForm" className="donations-hero-cta" onClick={(e) => {
                        e.preventDefault();
                        scrollToForm();
                    }}>
                        Hacer una donación
                    </a>
                </div>
            </div>
            
            <div className="donations-container">
                
                {/* Nuevo componente para donaciones directas */}
                <div className="donation-direct-info">
                    <FaInfoCircle />
                    <div className="donation-direct-info-content">
                        <h3>Donaciones directas a las organizaciones</h3>
                        <p>
                            Si prefieres realizar una donación directamente a la organización sin intermediarios, 
                            puedes visitar la página web oficial de cada ONG desde su perfil de detalles. 
                            Allí encontrarás sus métodos de donación propios.
                        </p>
                        <a href="/">Ver todas las organizaciones</a>
                    </div>
                </div>
                
                <div className="donations-form-container" id="donationForm" ref={formRef}>
                    <div className="form-card">
                        <div className="form-header">
                            <FaHeart className="form-icon" />
                            <h2>Realiza tu Donación</h2>
                        </div>
                        <p className="form-subtitle">
                            Completa el formulario para hacer tu contribución a una causa que importa.
                            Todas las donaciones son procesadas de forma segura.
                        </p>
                        
                        <DonationsForm 
                            ngos={ngos} 
                            onSubmit={handleFormSubmit} 
                            loading={loadingDonation}
                            preselectedNgo={selectedNgo}
                        />
                        
                        {errorDonation && (
                            <div className="form-error-message">
                                <p>{errorDonation}</p>
                            </div>
                        )}
                    </div>
                    
                    <div className="donations-info">
                        <h3>¿Por qué donar?</h3>
                        <div className="donation-benefits">
                            <div className="benefit-item">
                                <div className="benefit-number">1</div>
                                <div className="benefit-content">
                                    <h4>Impacto Real</h4>
                                    <p>Tu donación llega directamente a quienes más lo necesitan, financiando proyectos concretos que generan cambios positivos en sus vidas.</p>
                                </div>
                            </div>
                            <div className="benefit-item">
                                <div className="benefit-number">2</div>
                                <div className="benefit-content">
                                    <h4>Transparencia</h4>
                                    <p>Todas nuestras organizaciones aliadas reportan periódicamente el uso de los fondos, garantizando que tu ayuda realmente hace la diferencia.</p>
                                </div>
                            </div>
                            <div className="benefit-item">
                                <div className="benefit-number">3</div>
                                <div className="benefit-content">
                                    <h4>Comunidad</h4>
                                    <p>Te unes a miles de personas que juntas están cambiando el mundo, creando un movimiento de solidaridad global.</p>
                                </div>
                            </div>
                            <div className="benefit-item">
                                <div className="benefit-number">4</div>
                                <div className="benefit-content">
                                    <h4>Facilidad</h4>
                                    <p>Nuestro proceso de donación es simple y seguro, permitiéndote contribuir en cualquier momento y desde cualquier lugar.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div className="donation-secure-badge">
                            <FaCheckCircle />
                            <span>Todas las donaciones son procesadas de forma segura</span>
                        </div>
                    </div>
                </div>
                
                <div className="donations-impact">
                    <div className="impact-header">
                        <FaHandsHelping className="impact-icon" />
                        <h2>Tu Impacto</h2>
                    </div>
                    <div className="impact-stats">
                        <div className="impact-stat">
                            <span className="stat-number">€25</span>
                            <span className="stat-text">Proporciona alimentos para una familia durante una semana</span>
                        </div>
                        <div className="impact-stat">
                            <span className="stat-number">€50</span>
                            <span className="stat-text">Garantiza acceso a agua potable para una comunidad</span>
                        </div>
                        <div className="impact-stat">
                            <span className="stat-number">€100</span>
                            <span className="stat-text">Financia la educación de un niño durante un mes</span>
                        </div>
                    </div>
                </div>
            </div>
            <div className="back-button-container">
                    <button 
                        className="back-button" 
                        onClick={handleBackButton}
                        aria-label="Volver a la página anterior"
                    >
                        <FaArrowLeft /> Volver
                    </button>
                </div>
            
            <Modal
                open={modalState.open}
                success={modalState.success}
                message={modalState.message}
                onClose={() => setModalState({ open: false })}
                redirectPath="/" // Redirigir a la página principal después de una donación exitosa
            />
        </div>
    );
};

export default DonationsPage;