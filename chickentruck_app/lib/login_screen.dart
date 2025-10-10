import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
 
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = '';
  bool loading = false;
 
  Future<void> login() async {
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
      final res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
 
      if (res.session != null && res.user != null) {
        setState(() => message = '✅ Login erfolgreich!');
        // TODO: Navigator.push(...);
      } else {
        setState(() => message = '⚠️ Unerwarteter Zustand: Keine Session.');
      }
    } on AuthException catch (e) {
      setState(() => message = '❌ ${e.message}');
    } catch (e) {
      setState(() => message = '❌ Unerwarteter Fehler: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: Text(loading ? 'Bitte warten…' : 'Einloggen'),
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}