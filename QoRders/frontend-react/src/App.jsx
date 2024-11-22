import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import NgoList from './pages/NgoList';


function App() {

  return (
    <Router>
        <Routes>
            <Route path="/" element={<NgoList />} />
        </Routes>
    </Router>
);
}

export default App
