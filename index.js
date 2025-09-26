const express = require('express');
const cors = require('cors');
require('dotenv').config();
 
const app = express();
app.use(cors());
app.use(express.json());
 
app.get('/', (req, res) => {
  res.send('ChickenTruck Backend läuft!');
});
 
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});
 
// Routen einbinden
const authRoutes = require('./routes/auth');
app.use('/auth', authRoutes);
 
const protectedRoutes = require('./routes/protected');
app.use('/api', protectedRoutes);
 
const locationRoutes = require('./routes/locations');
app.use('/locations', locationRoutes);
 
const packageRoutes = require('./routes/packages');
app.use('/packages', packageRoutes);
 
const adRoutes = require('./routes/ads');
app.use('/ads', adRoutes);
 
const adminRoutes = require('./routes/admin');
app.use('/admin', adminRoutes);

// Globales Error-Logging
app.use((err, req, res, next) => {
  console.error('🌍 Globaler Fehler:', err);
  res.status(500).json({ error: 'Interner Serverfehler' });
});

// 👉 Wichtig: Kein app.listen hier!
module.exports = app;