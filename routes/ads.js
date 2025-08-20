//API-Endpunkt /ads/show
const express = require('express');
const router = express.Router();
const supabase = require('../services/supabaseClient');

router.get('/show', async (req, res) => {
  const { data, error } = await supabase
    .from('ads')
    .select('*')
    .eq('active', true)
    .limit(1);

  if (error) return res.status(500).json({ error: error.message });

  res.json(data[0]);
});

module.exports = router;
