import React, { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { FaCheckCircle, FaExclamationTriangle, FaTimes } from 'react-icons/fa';
import './Modal.css';

const Modal = ({ open, success, message, onClose, redirectPath }) => {
    const navigate = useNavigate();

    // Prevenir scroll del body cuando el modal está abierto
    useEffect(() => {
        if (open) {
            document.body.style.overflow = 'hidden';
        } else {
            document.body.style.overflow = 'auto';
        }
        
        return () => {
            document.body.style.overflow = 'auto';
        };
    }, [open]);

    if (!open) return null;

    const handleClose = () => {
        onClose();
        // Si hay redirección y la operación fue exitosa, redirigir
        if (redirectPath && success) {
            navigate(redirectPath);
        }
    };

    // Determinar título según el tipo de modal
    const title = success ? '¡Donación Realizada con Éxito!' : 'Ha ocurrido un problema';
    
    // Determinar icono según el tipo de modal
    const icon = success ? <FaCheckCircle className="modal-icon" /> : <FaExclamationTriangle className="modal-icon" />;

    return (
        <div className="modal-overlay" onClick={handleClose}>
            <div 
                className={`modal ${success ? 'modal-success' : 'modal-error'}`}
                onClick={e => e.stopPropagation()} // Prevenir cierre al hacer clic en el modal
            >
                <div className="modal-header">
                    <div className="modal-icon-container">
                        {icon}
                    </div>
                    <h2 className="modal-title">{title}</h2>
                </div>
                
                <div className="modal-body">
                    <p>{message}</p>
                </div>
                
                <div className="modal-footer">
                    <button className="modal-close-btn" onClick={handleClose}>
                        {success ? 'Continuar' : 'Aceptar'}
                    </button>
                </div>
            </div>
        </div>
    );
};

export default Modal;