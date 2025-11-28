import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ubicacion.dart';

class UbicacionesService {
  final CollectionReference col =
      FirebaseFirestore.instance.collection('ubicaciones');

  Future<void> registrarUbicacion(Ubicacion u) async {
    await col.add(u.toMap());
  }

  Future<List<Ubicacion>> obtenerPorUsuario(String uid) async {
    final snap = await col.where('uid_usuario', isEqualTo: uid).get();
    return snap.docs
        .map((d) => Ubicacion.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }
}
