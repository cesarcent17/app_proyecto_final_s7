import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../auth/login_page.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final UsuarioService usuarioService = UsuarioService();

  Usuario? usuario;
  final TextEditingController nombreCtrl = TextEditingController();

  bool cargando = true;
  String? errorMensaje;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    print("📌 Cargar datos del perfil…");

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        cargando = false;
        errorMensaje = "No hay usuario autenticado.";
      });
      return;
    }

    print("🔎 UID del usuario logueado: ${user.uid}");

    final datos = await usuarioService.obtener(user.uid);

    if (datos == null) {
      print("❌ Firestore NO devolvió datos para ese UID");

      setState(() {
        cargando = false;
        errorMensaje = "Tu perfil no está registrado en Firestore.";
      });
      return;
    }

    print("✅ Perfil encontrado en Firestore");

    setState(() {
      usuario = datos;
      nombreCtrl.text = datos.nombre;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMensaje != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Mi Perfil")),
        body: Center(
          child: Text(
            errorMensaje!,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(usuario!.foto),
            ),

            const SizedBox(height: 20),

            Text(
              usuario!.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                print("📝 Actualizando nombre: ${nombreCtrl.text}");

                await usuarioService.actualizarNombre(
                  user.uid,
                  nombreCtrl.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Datos actualizados")),
                );

                cargarDatos();
              },
              child: const Text("Guardar cambios"),
            ),

            const Spacer(),

            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar sesión"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                      (_) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
