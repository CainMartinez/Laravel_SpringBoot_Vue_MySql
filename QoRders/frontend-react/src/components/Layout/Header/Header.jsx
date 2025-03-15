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
                <a
                    href="http://localhost:8086"
                    className="link"
                >
                    ONGs
                </a>
                <NavLink
                    to="/donations"
                    className="link"
                >
                    Donaciones
                </NavLink>
            </div>
        </div>
    );
};

export default Header;
