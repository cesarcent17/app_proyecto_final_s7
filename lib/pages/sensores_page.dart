import 'package:flutter/material.dart';

class SensoresPage extends StatelessWidget {
  const SensoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensores del Dispositivo"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          "Pantalla de Sensores (por implementar)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
