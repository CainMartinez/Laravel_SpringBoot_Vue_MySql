import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Layout/Header/Header';
import Footer from './components/Layout/Footer/Footer';
import NgosPage from './pages/NgoPage/NgoPage';
import NgoDetailsPage from './pages/NgoDetailsPage/NgoDetailsPage';
import DonationsPage from './pages/DonationsPage/DonationsPage';

const App = () => {
    return (
        <Router future={{ v7_startTransition: true, v7_relativeSplatPath: true }}>
            <Header />
            <Routes>
                <Route path="/" element={<NgosPage />} />
                <Route path="/home" element={<NgosPage />} />
                <Route path="/ngos" element={<NgosPage />} />
                <Route path="/ngos/:ngo_slug" element={<NgoDetailsPage />} />
                <Route path="/donations" element={<DonationsPage />} />
            </Routes>
            <Footer />
        </Router>
    );
};

export default App;
