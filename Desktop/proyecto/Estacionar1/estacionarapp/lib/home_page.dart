import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ofrecer_cochera_page.dart';
import 'buscar_cochera_page.dart';
import 'login_page.dart';

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
                    builder: (context) => const OfrecerCocheraPage(),
                  ),
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
                    builder: (context) => const BuscarCocheraPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
