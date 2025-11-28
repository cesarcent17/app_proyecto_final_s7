import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reporte.dart';

class ReporteService {
  final CollectionReference col =
      FirebaseFirestore.instance.collection("reportes");

  Future<void> crear(Reporte r) async {
    await col.add(r.toMap());
  }

  Future<void> eliminar(String id) async {
    await col.doc(id).delete();
  }

  Stream<List<Reporte>> obtenerPorUsuario(String uid) {
    return col
        .where("uid_usuario", isEqualTo: uid)
        .orderBy("fecha", descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Reporte.fromFirestore(d)).toList());
  }
}
