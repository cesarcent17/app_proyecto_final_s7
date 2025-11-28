import 'package:flutter/material.dart';

class MapaPage extends StatelessWidget {
  const MapaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa")),
      body: const Center(
        child: Text("Aquí va el mapa"),
      ),
    );
  }
}
