import React from 'react';
import { Link } from 'react-router-dom';
import { FaGithub, FaLinkedin, FaTwitter, FaInstagram, FaArrowRight, FaHome, FaHeart, FaInfoCircle, FaHandsHelping, FaEnvelope } from 'react-icons/fa';
import './Footer.css';

const Footer = () => {
    return (
        <footer className="footer">
            <div className="footer-pattern"></div>
            
            <div className="footer-container">
                <div className="footer-logo">
                <h3 className="footer-heading">GitHub</h3>

                    <a 
                        href="https://github.com/CainMartinez" 
                        target="_blank" 
                        rel="noopener noreferrer"
                        className="github-link"
                    >
                        <FaGithub className="github-icon" size={20} />
                        <span>Caín Martínez Bernabeu</span>
                    </a>
                </div>
                
                <div className="footer-links-container">
                <h3 className="footer-heading">QoRders</h3>
                <p className="footer-description">
                        Transformando corazones y comunidades a través de la solidaridad digital. 
                        Conectamos donantes con organizaciones que hacen la diferencia.
                    </p>
                </div>
                
                <div className="footer-links-container">
                    <h3 className="footer-heading">Colaboradores</h3>
                    <div className="footer-links">
                        <a 
                            className="footer-link"
                            target="_blank" 
                            rel="noopener noreferrer"
                        >
                            <FaArrowRight /> Àngela Torró
                        </a>
                        <a 
                            className="footer-link"
                            target="_blank" 
                            rel="noopener noreferrer"
                        >
                            <FaArrowRight /> Álvaro Garrido
                        </a>
                        <a 
                            className="footer-link"
                            target="_blank" 
                            rel="noopener noreferrer"
                        >
                            <FaArrowRight /> Caín Martínez
                        </a>
                    </div>
                </div>
            </div>
            
            <div className="footer-bottom">
                <p className="footer-copyright">
                    &copy; {new Date().getFullYear()} QoRders. Todos los derechos reservados.
                </p>
                
                {/* <div className="footer-social">
                    <a href="https://github.com/CainMartinez" className="social-icon" aria-label="GitHub">
                        <FaGithub />
                    </a>
                </div> */}
            </div>
        </footer>
    );
};

export default Footer;