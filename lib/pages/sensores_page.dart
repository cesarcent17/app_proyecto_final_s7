import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';

class SensoresPage extends StatefulWidget {
  const SensoresPage({super.key});

  @override
  State<SensoresPage> createState() => _SensoresPageState();
}

class _SensoresPageState extends State<SensoresPage> {
  // Sensores
  double ax = 0, ay = 0, az = 0;
  double gx = 0, gy = 0, gz = 0;
  double direccion = 0.0;

  late StreamSubscription _accSub;
  late StreamSubscription _gyroSub;
  StreamSubscription? _compassSub;

  @override
  void initState() {
    super.initState();

    // 📌 Acelerómetro
    _accSub = accelerometerEvents.listen((event) {
      setState(() {
        ax = event.x;
        ay = event.y;
        az = event.z;
      });
    });

    // 📌 Giroscopio
    _gyroSub = gyroscopeEvents.listen((event) {
      setState(() {
        gx = event.x;
        gy = event.y;
        gz = event.z;
      });
    });

    // 📌 Brújula
    _compassSub = FlutterCompass.events!.listen((event) {
      setState(() {
        direccion = event.heading ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _accSub.cancel();
    _gyroSub.cancel();
    _compassSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sensores del Dispositivo")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 📌 Acelerómetro
          const Text("Acelerómetro (m/s²)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("X: ${ax.toStringAsFixed(2)}"),
          Text("Y: ${ay.toStringAsFixed(2)}"),
          Text("Z: ${az.toStringAsFixed(2)}"),
          const Divider(height: 30),

          // 🎯 Giroscopio
          const Text("Giroscopio (rad/s)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("X: ${gx.toStringAsFixed(2)}"),
          Text("Y: ${gy.toStringAsFixed(2)}"),
          Text("Z: ${gz.toStringAsFixed(2)}"),
          const Divider(height: 30),

          // 🧭 Brújula
          const Text("Brújula / Dirección",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Center(
            child: Text(
              "${direccion.toStringAsFixed(2)}°",
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
