import React, { useState } from 'react';
import useFetchNgos from '../../hooks/useFetchNgos';
import useDonation from '../../hooks/useDonation';
import DonationsForm from '../../components/DonationsForm/DonationsForm';
import Modal from '../../components/Modal/Modal';
import './DonationsPage.css';

const DonationsPage = () => {
    const { ngos, loading: loadingNgos, error: errorNgos } = useFetchNgos();
    const { handleDonation, loading: loadingDonation, error: errorDonation } = useDonation();
    const [modalState, setModalState] = useState({ open: false, success: false, message: '' });

    const handleFormSubmit = async (formData) => {
        try {
            const donationData = {
                ngo_slug: formData.ngo_slug,
                customer_username: formData.donorName,
                quantity: formData.amount,
            };

            await handleDonation(donationData);
            setModalState({ open: true, success: true, message: '¡Donación realizada con éxito!' });
        } catch (error) {
            const errorMessage = typeof error === 'object' && error.message ? error.message : 'Error al realizar la donación';
            setModalState({ open: true, success: false, message: errorMessage });
        }
    };

    if (loadingNgos) return <p>Cargando ONG...</p>;
    if (errorNgos) return <p>Error al cargar las ONG: {errorNgos}</p>;

    return (
        <div className="donations-page">
            <h1>Realiza una donación</h1>
            <DonationsForm ngos={ngos} onSubmit={handleFormSubmit} loading={loadingDonation} />
            <Modal
                open={modalState.open}
                success={modalState.success}
                message={modalState.message}
                onClose={() => setModalState({ open: false })}
            />
        </div>
    );
};

export default DonationsPage;