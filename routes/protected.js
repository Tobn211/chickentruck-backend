//Geschützte Route erstellen
const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/auth');

router.get('/dashboard', authenticateToken, (req, res) => {
  res.json({ message: `Willkommen, Nutzer mit ID ${req.user.id}` });
});

module.exports = router;
