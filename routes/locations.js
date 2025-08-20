//API-Endpunkt /locations/today
const express = require('express');
const router = express.Router();
const supabase = require('../services/supabaseClient');
const authenticateToken = require('../middleware/auth');

router.get('/today', authenticateToken, async (req, res) => {
  const today = new Date().toISOString().split('T')[0]; // Format: YYYY-MM-DD

  const { data, error } = await supabase
    .from('calendar_entries')
    .select('*, locations(*)')
    .eq('date', today);

  if (error) return res.status(500).json({ error: error.message });

  res.json(data);
});

module.exports = router;

//API-Endpunkt /locations/by-date/:date
router.get('/by-date/:date', authenticateToken, async (req, res) => {
  const { date } = req.params;

  const { data, error } = await supabase
    .from('calendar_entries')
    .select('*, locations(*)')
    .eq('date', date);

  if (error) return res.status(500).json({ error: error.message });

  res.json(data);
});
