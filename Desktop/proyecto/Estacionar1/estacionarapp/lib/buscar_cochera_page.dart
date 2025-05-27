import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuscarCocheraPage extends StatefulWidget {
  const BuscarCocheraPage({super.key});

  @override
  State<BuscarCocheraPage> createState() => _BuscarCocheraPageState();
}

class _BuscarCocheraPageState extends State<BuscarCocheraPage> {
  Future<void> reservarCochera(String cocheraId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes estar logueado para reservar.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reservas').add({
        'usuarioId': user.uid,
        'cocheraId': cocheraId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cochera reservada con éxito')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al reservar cochera: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Buscar Cocheras Disponibles')),
        body: const Center(
          child: Text('Debes iniciar sesión para buscar cocheras'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Cocheras Disponibles')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cocheras')
            .where('usuarioId', isNotEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar cocheras'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child: Text('No hay cocheras disponibles por ahora.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>? ?? {};

              final fecha = data['fecha'] ?? 'Fecha no disponible';
              final desde = data['desde'] ?? '';
              final hasta = data['hasta'] ?? '';
              final horario = desde.isNotEmpty && hasta.isNotEmpty
                  ? '$desde - $hasta'
                  : 'Horario no disponible';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['direccion'] ?? 'Sin dirección'),
                  subtitle: Text('Fecha: $fecha | $horario'),
                  trailing: ElevatedButton(
                    child: const Text('Reservar'),
                    onPressed: () => reservarCochera(doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
