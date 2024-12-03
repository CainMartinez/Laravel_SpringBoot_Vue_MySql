import React from 'react';
import NgoList from '../../components/NgoList/NgoList';
import useFetchNgos from '../../hooks/useFetchNgos';
import './NgoPage.css';

const NgosPage = () => {
    const { ngos, loading, error } = useFetchNgos();

    if (loading) return <p>Loading NGOs...</p>;
    if (error) return <p>Error: {error}</p>;

    return (
        <div className="ngos-page">
            <h1>Organizaciones a las que apoyamos</h1>
            <NgoList ngos={ngos} />
        </div>
    );
};

export default NgosPage;
