//API-Endpunkt /admin/operators/pending
const express = require('express');
const router = express.Router();
const supabase = require('../services/supabaseClient');
const authenticateToken = require('../middleware/auth');

// Nur Admins dürfen diese Route nutzen – hier noch ohne Rollenprüfung
router.get('/operators/pending', authenticateToken, async (req, res) => {
  const { data, error } = await supabase
    .from('operators')
    .select('*')
    .eq('verified', false);

  if (error) return res.status(500).json({ error: error.message });

  res.json(data);
});

//Admin-Endpunkt /admin/operators/approve
router.post('/operators/approve', authenticateToken, async (req, res) => {
  const { operator_id } = req.body;

  const { data, error } = await supabase
    .from('operators')
    .update({ verified: true })
    .eq('id', operator_id);

  if (error) return res.status(500).json({ error: error.message });

  res.json({ message: 'Betreiber verifiziert', operator: data[0] });
});

module.exports = router;
