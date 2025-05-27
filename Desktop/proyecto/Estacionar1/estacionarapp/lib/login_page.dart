import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ofrecer_cochera_page.dart';
import 'buscar_cochera_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _errorMessage = '';
  bool _isLoading = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor ingresa un email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Email no válido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'user-disabled':
        return 'La cuenta ha sido deshabilitada.';
      case 'user-not-found':
        return 'No se encontró una cuenta con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'El correo ya está en uso.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'operation-not-allowed':
        return 'Operación no permitida. Contacta con soporte.';
      default:
        return 'Error: ${e.message}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: _validatePassword,
              ),
              const SizedBox(height: 20),
              if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: _login,
                          child: const Text('Iniciar sesión'),
                        ),
                        TextButton(
                          onPressed: _register,
                          child: const Text('Registrarse'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ✅ Reemplazo completo de HomePage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estacionar Hoy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              if (!context.mounted) return;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add_location),
              label: const Text('Ofrecer Cochera'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OfrecerCocheraPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Buscar Cochera'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BuscarCocheraPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
