import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reporte.dart';

class ReporteService {
  final col = FirebaseFirestore.instance.collection('reportes');

  Future<void> crearReporte(Reporte r) async {
    await col.add(r.toMap());
  }

  Future<List<Reporte>> obtenerPorUsuario(String uid) async {
    final snap = await col.where('uid_usuario', isEqualTo: uid).get();
    return snap.docs
        .map((d) => Reporte.fromMap(d.id, d.data() as Map<String, dynamic>))
        .toList();
  }
}
