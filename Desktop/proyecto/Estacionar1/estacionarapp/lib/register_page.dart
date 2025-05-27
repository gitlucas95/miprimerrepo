import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmController.text.trim();

    if (password != confirmPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada con éxito')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirmar Contraseña'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
