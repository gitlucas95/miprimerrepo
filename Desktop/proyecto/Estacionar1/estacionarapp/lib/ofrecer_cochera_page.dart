import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OfrecerCocheraPage extends StatefulWidget {
  const OfrecerCocheraPage({super.key});

  @override
  State<OfrecerCocheraPage> createState() => _OfrecerCocheraPageState();
}

class _OfrecerCocheraPageState extends State<OfrecerCocheraPage> {
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController desdeController = TextEditingController();
  final TextEditingController hastaController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();

  bool isSaving = false;

  // Para formatear la hora en formato 24h "HH:mm"
  String _formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future<void> _selectFecha() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      fechaController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _selectHora(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text = _formatTimeOfDay(picked);
    }
  }

  Future<void> guardarCochera() async {
    if (direccionController.text.trim().isEmpty ||
        fechaController.text.trim().isEmpty ||
        desdeController.text.trim().isEmpty ||
        hastaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() => isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Usuario no autenticado.");

      await FirebaseFirestore.instance.collection('cocheras').add({
        'usuarioId': user.uid,
        'direccion': direccionController.text.trim(),
        'desde': desdeController.text.trim(),
        'hasta': hastaController.text.trim(),
        'fecha': fechaController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cochera guardada correctamente')),
      );

      direccionController.clear();
      desdeController.clear();
      hastaController.clear();
      fechaController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> eliminarCochera(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('cocheras')
          .doc(docId)
          .delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cochera eliminada')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Debes iniciar sesión para ofrecer cocheras')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ofrecer Cochera')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // FORMULARIO
            TextField(
              controller: direccionController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            GestureDetector(
              onTap: _selectFecha,
              child: AbsorbPointer(
                child: TextField(
                  controller: fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    hintText: 'Selecciona la fecha',
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectHora(desdeController),
              child: AbsorbPointer(
                child: TextField(
                  controller: desdeController,
                  decoration: const InputDecoration(
                    labelText: 'Desde',
                    hintText: 'Selecciona hora inicio',
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _selectHora(hastaController),
              child: AbsorbPointer(
                child: TextField(
                  controller: hastaController,
                  decoration: const InputDecoration(
                    labelText: 'Hasta',
                    hintText: 'Selecciona hora fin',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSaving ? null : guardarCochera,
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Guardar Cochera'),
            ),
            const SizedBox(height: 30),

            // LISTADO DE COCHERAS
            const Text(
              'Tus cocheras ofrecidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cocheras')
                    .where('usuarioId', isEqualTo: user.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error al cargar cocheras');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Text('Todavía no ofreciste ninguna cochera.');
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text(data['direccion'] ?? 'Sin dirección'),
                          subtitle: Text(
                            'Fecha: ${data['fecha']} | ${data['desde']} - ${data['hasta']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirmar eliminación'),
                                  content: const Text(
                                      '¿Estás seguro de eliminar esta cochera?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        eliminarCochera(doc.id);
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
