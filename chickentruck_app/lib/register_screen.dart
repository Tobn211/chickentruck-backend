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
 
  Future<void> register() async {
    final response = await supabase.auth.signUp(
      email: emailController.text,
      password: passwordController.text,
    );
 
    if (response.user != null) {
      setState(() {
        message = '✅ Registrierung erfolgreich!';
      });
      // Beispiel: Weiterleitung zur Startseite
      // Navigator.push(context, MaterialPageRoute(builder: (_) => const MyHomePage(title: 'Startseite')));
    } else {
      setState(() {
        message = '❌ Fehler: ${response.error?.message}';
      });
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
              decoration: const InputDecoration(labelText: 'E-Mail'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Registrieren'),
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}