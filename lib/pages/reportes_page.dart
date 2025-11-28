import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportesPage extends StatefulWidget {
  const ReportesPage({super.key});

  @override
  State<ReportesPage> createState() => _ReportesPageState();
}

class _ReportesPageState extends State<ReportesPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Controllers del modal
  final TextEditingController tituloCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  // Crear reporte
  Future<void> crearReporte() async {
    if (tituloCtrl.text.isEmpty || descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    try {
      await db.collection("reportes").add({
        "titulo": tituloCtrl.text,
        "descripcion": descCtrl.text,
        "fecha": Timestamp.now(),
        "uid_usuario": user?.uid,
      });

      tituloCtrl.clear();
      descCtrl.clear();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reporte creado correctamente")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Eliminar reporte
  Future<void> eliminarReporte(String id) async {
    try {
      await db.collection("reportes").doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reporte eliminado")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar: $e")),
      );
    }
  }

  // Modal para agregar reporte
  void mostrarModalNuevo() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuevo Reporte"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloCtrl,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Descripción"),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            onPressed: crearReporte,
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportes"),
        actions: [
          IconButton(
            onPressed: mostrarModalNuevo,
            icon: const Icon(Icons.add),
          )
        ],
      ),

      // Stream en tiempo real
      body: StreamBuilder(
        stream: db
            .collection("reportes")
            .where("uid_usuario", isEqualTo: user?.uid)
            .orderBy("fecha", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Error Firestore
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "⚠ Error al cargar los reportes.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Sin datos
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No hay reportes aún.\nPresiona + para crear uno nuevo.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // Lista de reportes
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final fecha = (d["fecha"] as Timestamp).toDate();

              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    d["titulo"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${d["descripcion"]}\n📅 ${fecha.day}/${fecha.month}/${fecha.year}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eliminarReporte(d.id),
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
