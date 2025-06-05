import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Crear usuario con email y contraseña
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Opcional: actualizar el displayName con el nombre
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        nameController.text.trim(),
      );

      if (mounted) {
        // Navegar a Home después del registro
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    child: Text('Registrarse'),
                  ),
          ],
        ),
      ),
    );
  }
}
