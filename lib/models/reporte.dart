import 'package:cloud_firestore/cloud_firestore.dart';

class Reporte {
  String? id;
  String titulo;
  String descripcion;
  DateTime fecha;
  String uidUsuario;

  Reporte({
    this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.uidUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      "titulo": titulo,
      "descripcion": descripcion,
      "fecha": Timestamp.fromDate(fecha),
      "uid_usuario": uidUsuario,
    };
  }

  static Reporte fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Reporte(
      id: doc.id,
      titulo: data["titulo"],
      descripcion: data["descripcion"],
      fecha: (data["fecha"] as Timestamp).toDate(),
      uidUsuario: data["uid_usuario"],
    );
  }
}
