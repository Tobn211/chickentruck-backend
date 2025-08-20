//Express-Server starten
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('ChickenTruck Backend läuft!');
});

app.listen(3000, () => {
  console.log('Server läuft auf Port 3000');
});

//Routen einbinden
const authRoutes = require('./routes/auth');
app.use('/auth', authRoutes);

//Geschützte Route erstellen
const protectedRoutes = require('./routes/protected');
app.use('/api', protectedRoutes);

//API-Endpunkt /locations/today
const locationRoutes = require('./routes/locations');
app.use('/locations', locationRoutes);

//API-Endpunkt /packages
const packageRoutes = require('./routes/packages');
app.use('/packages', packageRoutes);

//API-Endpunkt /ads/show
const adRoutes = require('./routes/ads');
app.use('/ads', adRoutes);

//Admin-Endpunkt /admin/operators/approve
const adminRoutes = require('./routes/admin');
app.use('/admin', adminRoutes);
