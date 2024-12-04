import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Header from './components/Layout/Header/Header';
import Footer from './components/Layout/Footer/Footer';
import NgosPage from './pages/NgoPage/NgoPage';
import NgoDetailsPage from './pages/NgoDetailsPage/NgoDetailsPage';
import DonationsPage from './pages/DonationsPage/DonationsPage';

const App = () => {
    return (
        <Router>
            <Header />
            <Routes>
                <Route path="/" element={<NgosPage />} />
                <Route path="/ngos" element={<NgosPage />} />
                <Route path="/ngos/:slug" element={<NgoDetailsPage />} />
                <Route path="/donaciones" element={<DonationsPage />} />
            </Routes>
            <Footer />
        </Router>
    );
};

export default App;
