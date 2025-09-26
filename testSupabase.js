// testSupabase.js
import 'dotenv/config';
import { supabase } from './supabaseClient.js';
 
async function testConnection() {
  const { data, error } = await supabase
    .from('users') // oder eine andere Tabelle, die existiert
    .select('*')
    .limit(1);
 
  if (error) {
    console.error('❌ Verbindung fehlgeschlagen:', error.message);
  } else {
    console.log('✅ Verbindung erfolgreich. Beispiel-Daten:', data);
  }
}
 
testConnection();