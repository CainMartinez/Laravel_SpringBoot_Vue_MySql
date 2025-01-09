import React from 'react';
import { NavLink } from 'react-router-dom';
import './Header.css';

const Header = () => {
    return (
        <div className="header">
            <div className="logo">
                <img src="/assets/logo.png" alt="Logo" />
            </div>

            <div className="menu">
                <NavLink
                    to="/home"
                    className={({ isActive }) => (isActive ? 'active-link' : 'link')}
                >
                    Inicio
                </NavLink>
                
                <a
                    href="http://localhost:8085"
                    className="link"
                >
                    Restaurante
                </a>
                <NavLink
                    to="/donations"
                    className={({ isActive }) => (isActive ? 'active-link' : 'link')}
                >
                    Donaciones
                </NavLink>
            </div>

            <div className="login-button">
                <NavLink
                    to="/login"
                    className={({ isActive }) => (isActive ? 'active-link' : 'link')}
                >
                    Iniciar sesión
                </NavLink>
            </div>
        </div>
    );
};

export default Header;
