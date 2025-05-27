import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'login_page.dart'; // Contiene LoginPage y HomePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estacionar Hoy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthGate(),
      routes: {
        '/register': (context) => const RegisterPage(),
        '/recover': (context) => const PasswordRecoveryPage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomePage(); // ← Aquí va la nueva HomePage real
        }
        return const LoginPage();
      },
    );
  }
}

// Placeholder para futuras pantallas
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: const Center(child: Text('Página de registro')),
    );
  }
}

class PasswordRecoveryPage extends StatelessWidget {
  const PasswordRecoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: const Center(child: Text('Página de recuperación de contraseña')),
    );
  }
}
