import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) {
        return; // Evita usar context si el widget ya no está en pantalla
      }
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person,
                size: 80, color: Color.fromRGBO(29, 33, 119, 10)),
            Text(
              user?.displayName ?? 'Nombre del Usuario',
              style: const TextStyle(fontSize: 18),
            ),
            Text(user?.email ?? 'correo@ejemplo.com'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
