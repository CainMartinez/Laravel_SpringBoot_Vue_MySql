import React, { useState, useEffect } from 'react';
import NgoList from '../../components/NgoList/NgoList';
import useFetchNgos from '../../hooks/useFetchNgos';
import './NgoPage.css';

const NgosPage = () => {
    const { ngos, loading, error } = useFetchNgos();
    const [searchTerm, setSearchTerm] = useState('');
    const [filteredNgos, setFilteredNgos] = useState([]);
    const [activeCategory, setActiveCategory] = useState('all');
    const [impactStats, setImpactStats] = useState({
        donationsTotal: 0,
        peopleHelped: 0,
        projectsSupported: 0
    });

    // Categorías de ONGs
    const categories = [
        { id: 'all', name: 'Todas' },
        { id: 'humanitarian', name: 'Humanitarias' },
        { id: 'environmental', name: 'Medioambientales' },
        { id: 'education', name: 'Educación' },
        { id: 'health', name: 'Salud' }
    ];

    // Filtrar ONGs basado en búsqueda y categoría
    useEffect(() => {
        if (!ngos) return;
        
        let filtered = [...ngos];
        
        // Filtrar por término de búsqueda
        if (searchTerm.trim() !== '') {
            filtered = filtered.filter(ngo => 
                ngo.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                ngo.description.toLowerCase().includes(searchTerm.toLowerCase())
            );
        }
        
        // Filtrar por categoría
        if (activeCategory !== 'all') {
            filtered = filtered.filter(ngo => ngo.category === activeCategory);
        }
        
        setFilteredNgos(filtered);
        
        // Calcular estadísticas de impacto
        if (ngos.length > 0) {
            setImpactStats({
                donationsTotal: ngos.reduce((sum, ngo) => sum + (ngo.donations || 0), 7391.54),
                peopleHelped: ngos.length * 221,
                projectsSupported: Math.ceil(ngos.length * 1.9)
            });
        }
    }, [ngos, searchTerm, activeCategory]);

    const handleSearch = (e) => {
        setSearchTerm(e.target.value);
    };

    const handleCategoryChange = (categoryId) => {
        setActiveCategory(categoryId);
    };

    if (loading) return (
        <div className="loading-container">
            <div className="loading-spinner"></div>
            <p>Cargando organizaciones solidarias...</p>
        </div>
    );
    
    if (error) return (
        <div className="error-container">
            <i className="error-icon">!</i>
            <h2>Ha ocurrido un error</h2>
            <p>{error}</p>
            <button className="retry-button" onClick={() => window.location.reload()}>
                Intentar de nuevo
            </button>
        </div>
    );

    return (
        <div className="ngos-page">
            <div className="hero-section">
                <div className="hero-overlay"></div>
                <div className="hero-content">
                    <span className="hero-badge">Compromiso social</span>
                    <h1>Impulsando un Cambio Positivo</h1>
                    <p className="hero-subtitle">
                        En <b>QoRders</b>, creemos en el poder de la acción colectiva para transformar comunidades.
                        Cada reserva en nuestro restaurante contribuye directamente a organizaciones que 
                        generan impacto social real y duradero.
                    </p>
                </div>
            </div>
            
            {/* Impact statistics */}
            <div className="impact-stats">
                <div className="stat-card">
                    <span className="stat-number">{impactStats.donationsTotal}€</span>
                    <span className="stat-label">Donados</span>
                </div>
                <div className="stat-card">
                    <span className="stat-number">{impactStats.peopleHelped}</span>
                    <span className="stat-label">Personas Ayudadas</span>
                </div>
                <div className="stat-card">
                    <span className="stat-number">{impactStats.projectsSupported}</span>
                    <span className="stat-label">Proyectos Apoyados</span>
                </div>
            </div>
            
            {/* Mission statement */}
            <div className="mission-statement">
                <div className="mission-icon">❤️</div>
                <h2>Nuestro Compromiso Solidario</h2>
                <p>
                    Creemos firmemente que los negocios tienen una responsabilidad social. 
                    Por eso, destinamos el 0.9% de nuestros ingresos a apoyar estas organizaciones
                    que trabajan incansablemente para construir un futuro mejor para todos.
                </p>
            </div>
            
            {/* NGO List */}
            <h2 className="organizations-title">Organizaciones a las que apoyamos</h2>
            
            {filteredNgos.length === 0 ? (
                <div className="no-results">
                    <i className="no-results-icon">🔎</i>
                    <h3>No se encontraron resultados</h3>
                    <p>Intenta con otra búsqueda o selecciona una categoría diferente</p>
                </div>
            ) : (
                <NgoList ngos={filteredNgos} />
            )}
            
            {/* Call to action */}
            <div className="cta-section">
                <h2>¿Quieres colaborar directamente?</h2>
                <p>Puedes hacer una donación adicional al realizar tu próxima reserva o pedido.</p>
                <a href="http://localhost:8085" className="cta-button">Reservar Mesa Solidaria</a>            </div>
        </div>
    );
};

export default NgosPage;