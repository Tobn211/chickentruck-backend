import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
import 'login_screen.dart';
import 'register_screen.dart';
 
void main() async {
  // Stellt sicher, dass Flutter vollständig initialisiert ist, bevor Supabase geladen wird
  WidgetsFlutterBinding.ensureInitialized();
 
  // Supabase initialisieren – hier deine echten Projektwerte eintragen
  await Supabase.initialize(
    url: 'https://dpkwakwpawjrpabrfeci.supabase.co', // ← Supabase-URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRwa3dha3dwYXdqcnBhYnJmZWNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxOTQ3MDMsImV4cCI6MjA3MDc3MDcwM30.kGiaYbao0fuA0SACYOsnPgXmXD2LlQUtx3xX1G1mwnA', // ← öffentlicher Supabase-Key
  );
 
  runApp(const MyApp());
}
 
/// Zentrale Routen-Konstanten
class Routes {
  static const home = '/';
  static const login = '/login';
  static const register = '/register';
}
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  // Root der Anwendung
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChickenTruck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
 
      // Startseite
      initialRoute: Routes.home,
 
      // Benannte Routen
      routes: {
        Routes.home: (_) => const MyHomePage(title: 'ChickenTruck – Start'),
        Routes.login: (_) => const LoginScreen(),
        Routes.register: (_) => const RegisterScreen(),
      },
 
      // Fallback, falls eine Route fehlt
      onUnknownRoute: (_) =>
          MaterialPageRoute(builder: (_) => const MyHomePage(title: 'ChickenTruck – Start')),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
 
  final String title;
 
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
 
class _MyHomePageState extends State<MyHomePage> {
  // Optional: Counter aus dem Template – kannst du auch entfernen
  int _counter = 0;
 
  void _incrementCounter() {
    setState(() => _counter++);
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Kleiner Infotext (optional)
              Text(
                'Willkommen bei ChickenTruck!',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
 
              // Navigation per benannter Route
              FilledButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Zum Login'),
                onPressed: () => Navigator.pushNamed(context, Routes.login),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Registrieren'),
                onPressed: () => Navigator.pushNamed(context, Routes.register),
              ),
 
              const SizedBox(height: 24),
              // Der frühere Counter bleibt funktionsfähig (kannst du jederzeit entfernen)
              const Text('Demo-Zähler:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}