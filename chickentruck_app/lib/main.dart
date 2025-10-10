import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 
import 'login_screen.dart';
import 'register_screen.dart';
 
Future<void> main() async {
  // Flutter-Engine bereit machen
  WidgetsFlutterBinding.ensureInitialized();
 
  // 1) .env laden (lokale Entwicklung)
  //    Für CI/Prod besser: --dart-define (siehe Kommentar weiter unten)
  await dotenv.load(fileName: ".env");
 
  // 2) Supabase initialisieren – Werte aus .env
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnon = dotenv.env['SUPABASE_KEY'];
 
  if (supabaseUrl == null || supabaseAnon == null) {
    // Fail fast mit klarer Meldung
    throw StateError(
      'SUPABASE_URL oder SUPABASE_ANON_KEY fehlen. '
      'Prüfe deine .env oder deine --dart-define Übergaben.',
    );
  }
 
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnon,
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
  // Demo-Zähler
  int _counter = 0;
 
  void _incrementCounter() => setState(() => _counter++);
 
  @override
  Widget build(BuildContext context) {
    final url = dotenv.env['SUPABASE_URL'] ?? 'n/a';
 
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
              Text(
                'Willkommen bei ChickenTruck!',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Supabase URL: $url',
                style: Theme.of(context).textTheme.bodySmall,
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
              const Text('Demo-Zähler:'),
              Text('$_counter', style: Theme.of(context).textTheme.headlineMedium),
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