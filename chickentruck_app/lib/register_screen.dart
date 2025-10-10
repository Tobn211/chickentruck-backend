import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
 
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
 
class _RegisterScreenState extends State<RegisterScreen> {
  final supabase = Supabase.instance.client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool loading = false;
 
  Future<void> register() async {
    setState(() {
      loading = true;
      message = '';
    });
 
    final email = emailController.text.trim();
    final password = passwordController.text;
 
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        loading = false;
        message = '❌ Bitte E‑Mail und Passwort eingeben.';
      });
      return;
    }
 
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        // Optional: Metadaten mitschicken
        // data: {'username': 'tobias_sauer'},
      );
 
      final user = res.user;
      final session = res.session;
 
      if (user != null && session == null) {
        // "Confirm email" ist aktiv -> Mail zur Bestätigung versendet
        setState(() {
          message = '✅ Registrierung erfolgreich! Bitte E‑Mail bestätigen.';
        });
        // Optional: zu einer "Check your e‑mail"-Seite navigieren
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ConfirmEmailScreen()));
      } else if (user != null && session != null) {
        // Direkt eingeloggt (Confirm email deaktiviert)
        setState(() {
          message = '✅ Registrierung & Login erfolgreich!';
        });
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Startseite')));
      } else {
        // Unerwarteter Zustand (defensiv)
        setState(() {
          message = '⚠️ Unerwarteter Zustand: Kein Benutzer/keine Session.';
        });
      }
    } on AuthException catch (e) {
      // Supabase-Auth-Fehler (z. B. "User already registered", 422, 429, …)
      setState(() {
        message = '❌ ${e.message}';
      });
    } catch (e) {
      // Andere Fehler (Netzwerk etc.)
      setState(() {
        message = '❌ Unerwarteter Fehler: $e';
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrierung')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E‑Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : register,
              child: Text(loading ? 'Bitte warten…' : 'Registrieren'),
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}