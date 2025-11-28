import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../pages/mapa_page.dart';
import '../pages/reportes_page.dart';
import '../pages/sensores_page.dart';
import '../pages/perfil_page.dart';

import 'package:app_proyecto_final_s7/pages/mapa_page.dart';
import 'package:app_proyecto_final_s7/pages/reportes_page.dart';
import 'package:app_proyecto_final_s7/pages/sensores_page.dart';
import 'package:app_proyecto_final_s7/pages/perfil_page.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildCard(
              icon: Icons.map,
              title: "Mapa (GPS)",
              subtitle: "Obtiene la ubicación y la guarda en Firestore",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MapaPage()),
              ),
            ),
            _buildCard(
              icon: Icons.report,
              title: "Reportes",
              subtitle: "Crear y ver reportes almacenados",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReportesPage()),
              ),
            ),
            _buildCard(
              icon: Icons.sensors,
              title: "Sensores del dispositivo",
              subtitle: "Acelerómetro • Giroscopio",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SensoresPage()),
              ),
            ),
            _buildCard(
              icon: Icons.person,
              title: "Perfil",
              subtitle: "Datos del usuario autenticado",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PerfilPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Widget reutilizable para los accesos del menú
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, size: 28, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
