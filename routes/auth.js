//Nutzer registrieren
const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const supabase = require('../services/supabaseClient');

router.post('/register', async (req, res) => {
  const { email, password } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);

  const { data, error } = await supabase
    .from('users')
    .insert([{ email, password: hashedPassword }]);

  if (error) return res.status(400).json({ error: error.message });

  const token = jwt.sign({ id: data[0].id }, process.env.JWT_SECRET, { expiresIn: '1h' });

  res.json({ token });
});

router.post('/register', async (req, res) => {
  console.log('📥 Anfrage erhalten bei /auth/register');
  console.log('📦 Body:', req.body);
 
  const { email, password } = req.body;
 
  if (!email || !password) {
    console.warn('⚠️ Ungültige Anfrage: Email oder Passwort fehlt');
    return res.status(400).json({ error: 'Email und Passwort erforderlich' });
  }
 
  try {
    const hashedPassword = await bcrypt.hash(password, 10);
 
    const { data, error } = await supabase
      .from('users')
      .insert([{ email, password: hashedPassword }]);
 
    if (error) {
      console.error('❌ Supabase-Fehler:', error.message);
      return res.status(400).json({ error: error.message });
    }
 
    const token = jwt.sign({ id: data[0].id }, process.env.JWT_SECRET, { expiresIn: '1h' });
 
    console.log('✅ Registrierung erfolgreich:', data[0]);
    res.json({ token });
  } catch (err) {
    console.error('🔥 Interner Fehler:', err);
    res.status(500).json({ error: 'Registrierung fehlgeschlagen' });
  }
});

router.post('/debug', (req, res) => {
  console.log('🐞 Debug-Body:', req.body);
  res.json({ received: req.body });
});

//Nutzer einloggen
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  const { data, error } = await supabase
    .from('users')
    .select('*')
    .eq('email', email)
    .single();

  if (error || !data) return res.status(400).json({ error: 'Nutzer nicht gefunden' });

  const valid = await bcrypt.compare(password, data.password);
  if (!valid) return res.status(401).json({ error: 'Falsches Passwort' });

  const token = jwt.sign({ id: data.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

  res.json({ token });
});

module.exports = router;
