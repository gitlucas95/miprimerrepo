import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: avoid_print

class OfferSpacePage extends StatefulWidget {
  const OfferSpacePage({super.key});

  @override
  State<OfferSpacePage> createState() => _OfferSpacePageState();
}

class _OfferSpacePageState extends State<OfferSpacePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController horarioController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  bool isLoading = false;

  Future<void> submitSpace() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      print('Usuario actual: $user');
      if (user == null) throw Exception("Usuario no autenticado");
      print('Guardando espacio en Firestore...');
      await FirebaseFirestore.instance.collection('espacios').add({
        'userId': user.uid,
        'direccion': direccionController.text.trim(),
        'horario': horarioController.text.trim(),
        'precio': double.parse(precioController.text.trim()),
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Espacio guardado con éxito.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Espacio ofrecido correctamente!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error guardando espacio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
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
    direccionController.dispose();
    horarioController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ofrecer mi espacio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingresa una dirección'
                    : null,
              ),
              TextFormField(
                controller: horarioController,
                decoration:
                    InputDecoration(labelText: 'Horario (ej: 9am - 6pm)'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Ingresa un horario'
                    : null,
              ),
              TextFormField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio por hora'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa un precio';
                  }
                  final num? parsed = num.tryParse(value);
                  if (parsed == null) return 'Ingresa un número válido';
                  if (parsed <= 0) return 'El precio debe ser mayor a cero';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: submitSpace,
                      child: Text('Ofrecer espacio'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
