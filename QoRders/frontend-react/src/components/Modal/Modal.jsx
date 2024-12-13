import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Modal.css';

const Modal = ({ open, success, message, onClose }) => {
    const navigate = useNavigate();

    if (!open) return null;

    const handleClose = () => {
        onClose();
        navigate('/');
    };

    return (
        <div className="modal-overlay">
            <div className={`modal ${success ? 'modal-success' : 'modal-error'}`}>
                <p>{message}</p>
                <button onClick={handleClose}>Cerrar</button>
            </div>
        </div>
    );
};

export default Modal;