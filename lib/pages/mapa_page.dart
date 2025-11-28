import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/ubicaciones_service.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  GoogleMapController? mapaController;
  LatLng? posicionActual;

  final UbicacionesService ubicacionesService = UbicacionesService();

  @override
  void initState() {
    super.initState();
    obtenerPosicion();
  }

  Future<void> obtenerPosicion() async {
    LocationPermission permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition();

    setState(() {
      posicionActual = LatLng(pos.latitude, pos.longitude);
    });

    mapaController?.animateCamera(
      CameraUpdate.newLatLng(posicionActual!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (posicionActual == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mapa GPS")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;

          if (user == null) return;

          await ubicacionesService.registrarUbicacion(
            posicionActual!.latitude,
            posicionActual!.longitude,
            user.uid,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Ubicación guardada")),
          );
        },
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: posicionActual!,
          zoom: 16,
        ),
        myLocationEnabled: true,
        onMapCreated: (controller) {
          mapaController = controller;
        },
      ),
    );
  }
}
