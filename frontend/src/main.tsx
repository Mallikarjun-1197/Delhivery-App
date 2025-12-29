import React from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import App from './App'
import CreateShipment from './pages/CreateShipment'
import Track from './pages/Track'
import './styles/index.css'

createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<App />}>
          <Route index element={<CreateShipment />} />
          <Route path="track" element={<Track />} />
        </Route>
      </Routes>
    </BrowserRouter>
  </React.StrictMode>
)
