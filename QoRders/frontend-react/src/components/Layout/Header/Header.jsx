import React, { useState, useEffect } from 'react';
import { NavLink, useNavigate } from 'react-router-dom';
import { FaHome, FaUtensils, FaHandHoldingHeart, FaUser, FaBars, FaSignOutAlt } from 'react-icons/fa';
import './Header.css';
import logo from '../../../assets/logo.png';

const Header = () => {
    const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
    const [scrolled, setScrolled] = useState(false);
    const navigate = useNavigate();
    
    // Detectar scroll para cambiar apariencia del header
    useEffect(() => {
        const handleScroll = () => {
            if (window.scrollY > 50) {
                setScrolled(true);
            } else {
                setScrolled(false);
            }
        };
        
        window.addEventListener('scroll', handleScroll);
        return () => window.removeEventListener('scroll', handleScroll);
    }, []);
    
    // Cerrar el menú móvil al cambiar de ruta
    const closeMenu = () => {
        setMobileMenuOpen(false);
    };
    
    // Simular el estado de autenticación (en una app real, vendría de un contexto o Redux)
    const isAuthenticated = false; // Cambiar según necesidades
    const userName = "Usuario"; // Cambiar según necesidades
    
    const handleLogout = () => {
        // Lógica de cierre de sesión aquí
        closeMenu();
        navigate('/');
    };

    return (
        <header className={`header-container ${scrolled ? 'scrolled' : ''}`}>
            <div className="header-content">
                <div className="logo-container">
                    <NavLink to="/" onClick={closeMenu}>
                        <img src={logo} alt="QoRders Logo" className="logo-image" />
                    </NavLink>
                </div>

                <button 
                    className="mobile-menu-button" 
                    onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
                    aria-label="Menú de navegación"
                >
                    <FaBars />
                </button>

                <nav className={`main-navigation ${mobileMenuOpen ? 'mobile-menu-open' : ''}`}>
                    <div className="nav-section left-menu">
                        <a href="http://localhost:8085" className="nav-link" onClick={closeMenu}>
                            <FaUtensils className="nav-icon" />
                            <span>Restaurante</span>
                        </a>

                        <NavLink to="/" className="nav-link" onClick={closeMenu}>
                            <FaHome className="nav-icon" />
                            <span>ONGs</span>
                        </NavLink>
                        
                        <NavLink to="/donations" className="nav-link" onClick={closeMenu}>
                            <FaHandHoldingHeart className="nav-icon" />
                            <span>Donaciones</span>
                        </NavLink>
                    </div>
                    
        
                        
                       
                </nav>
            </div>
        </header>
    );
};

export default Header;