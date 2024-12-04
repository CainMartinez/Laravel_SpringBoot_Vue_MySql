import React from 'react';
import './Footer.css';

const Footer = () => {
    return (
        <div className="footer">
            <div className="footer-content">
                <p>&copy; 2024 QoRders</p>
            </div>
            <div className="footer-links">
                <a href="https://github.com/AngeletaT" target="_blank" rel="noopener noreferrer">Àngela Torró</a>
                <a href="https://github.com/CainMartinez" target="_blank" rel="noopener noreferrer">Caín Martínez</a>
                <a href="https://github.com/AlvaroGarCam" target="_blank" rel="noopener noreferrer">Álvaro Garrido</a>
            </div>
        </div>
    );
};

export default Footer;
