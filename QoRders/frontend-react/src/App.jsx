import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import DonationsPage from './pages/DonationsPage/DonationsPage';

function App() {

    return (
        <Router>
            <Routes>
                <Route path="/" element={<DonationsPage />} />
            </Routes>
        </Router>
    );
}

export default App
