import React from 'react';
import { Link } from 'react-router-dom';
import './Header.css';

const Header = () => {
    return (
        <div className="header">
            <div className="logo">
                <img src="src\assets\logo.png" alt="QoRders" />
            </div>

            <div className="menu">
                <Link to="/home">Inicio</Link>
                <Link to="/rooms">Carta</Link>
                <Link to="/reservation">Reserva</Link>
                <Link to="/ngos">Organizaciones</Link>
                <Link to="/donaciones">Donaciones</Link>
            </div>

            <div className="login-button">
                <Link to="/login">Iniciar sesión</Link>
            </div>
        </div>
    );
};

export default Header;
