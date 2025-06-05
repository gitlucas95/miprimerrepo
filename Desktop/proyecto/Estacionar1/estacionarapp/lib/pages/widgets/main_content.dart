import 'package:flutter/material.dart';
import 'feature_tile.dart';

class MainContent extends StatelessWidget {
  final Color green = const Color(0xFF1AA34A);

  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Encuentra estacionamiento de forma fácil y rápida',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isWide ? 28 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Visualiza espacios disponibles en tiempo real y comparte tu cochera con vecinos.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: isWide ? 16 : 14),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes agregar funcionalidad para buscar estacionamiento
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: green),
                  child: const Text('Buscar estacionamiento'),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/offer_space');
                  },
                  child: const Text('Ofrecer mi espacio'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              width: isWide ? 600 : 300,
              height: isWide ? 350 : 200,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey.shade200,
              child: Icon(
                Icons.location_on,
                size: isWide ? 70 : 50,
                color: green,
              ),
            ),
            TextButton(
              onPressed: () {
                // Acción para ver mapa completo
              },
              child: const Text('Ver mapa completo'),
            ),
            const SizedBox(height: 40),
            Text(
              'Características principales',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isWide ? 20 : 16,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: const [
                  FeatureTile(
                    icon: Icons.timer,
                    title: 'Disponibilidad en tiempo real',
                    description:
                        'Visualiza en el mapa los espacios disponibles.',
                  ),
                  FeatureTile(
                    icon: Icons.group,
                    title: 'Comunidad colaborativa',
                    description: 'Comparte tu cochera con vecinos.',
                  ),
                  FeatureTile(
                    icon: Icons.schedule,
                    title: 'Coordinación de horarios',
                    description:
                        'Notifica a otros cuando estés por dejar tu espacio.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              color: green,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    '¿Listo para empezar?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text('Registrate', style: TextStyle(color: green)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
