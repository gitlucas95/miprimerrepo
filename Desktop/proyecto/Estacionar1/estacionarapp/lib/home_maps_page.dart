/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  HomeMapPageState createState() => HomeMapPageState();
}

class HomeMapPageState extends State<HomeMapPage> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = const LatLng(
    -34.6037,
    -58.3816,
  ); // Buenos Aires

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId("1"),
      position: LatLng(-34.6037, -58.3816),
      infoWindow: InfoWindow(
        title: "Espacio disponible",
        snippet: "Av. Corrientes 1234",
      ),
    ),
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(-34.6010, -58.3820),
      infoWindow: InfoWindow(title: "Cochera libre", snippet: "Libertad 456"),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onPublishSpacePressed() {
    // En el futuro podrías abrir una pantalla o modal con un formulario
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad "Publicar espacio" próximamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Estacionamientos")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 15.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onPublishSpacePressed,
        label: const Text("Publicar espacio"),
        icon: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
*/
