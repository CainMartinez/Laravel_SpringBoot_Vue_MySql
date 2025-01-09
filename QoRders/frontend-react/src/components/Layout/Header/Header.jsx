import React from 'react';
import { NavLink } from 'react-router-dom';
import './Header.css';
import logo from '../../../assets/logo.png';

const Header = () => {
    return (
        <div className="header">
            <div className="logo">
                <img src={logo} alt="Logo" />
            </div>

            <div className="menu">
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
                <a
                    href="http://localhost:8085/login"
                    className="link"
                >Iniciar sesión</a>
            </div>
        </div>
    );
};

export default Header;
