import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import NgoPage from './pages/NgoPage/NgoPage';

function App() {

    return (
        <Router>
            <Routes>
                <Route path="/" element={<NgoPage />} />
            </Routes>
        </Router>
    );
}

export default App
