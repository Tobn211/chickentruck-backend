//API-Endpunkt /packages
const express = require('express');
const router = express.Router();
const supabase = require('../services/supabaseClient');
const authenticateToken = require('../middleware/auth');

router.get('/', authenticateToken, async (req, res) => {
  const { data, error } = await supabase
    .from('packages')
    .select('*');

  if (error) return res.status(500).json({ error: error.message });

  res.json(data);
});

//API-Endpunkt /packages/purchase
router.post('/purchase', authenticateToken, async (req, res) => {
  const { package_id, amount } = req.body;
  const operator_id = req.user.id;

  const { data, error } = await supabase
    .from('payments')
    .insert([{
      operator_id,
      package_id,
      amount,
      recurring: true
    }]);

  if (error) return res.status(500).json({ error: error.message });

  res.json({ message: 'Paket erfolgreich gebucht', payment: data[0] });
});

module.exports = router;
