import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class UsuarioService {
  final db = FirebaseFirestore.instance;

  // Obtener usuario por UID
  Future<Usuario?> obtener(String uid) async {
    final doc = await db.collection("usuarios").doc(uid).get();

    if (!doc.exists) return null;

    return Usuario.fromMap(uid, doc.data()!);
  }

  // Crear usuario nuevo
  Future<void> crearUsuario(Usuario usuario) async {
    await db.collection("usuarios").doc(usuario.uid).set(usuario.toMap());
  }

  // Actualizar solo el nombre
  Future<void> actualizarNombre(String uid, String nuevoNombre) async {
    await db.collection("usuarios").doc(uid).update({
      "nombre": nuevoNombre,
    });
  }
}
