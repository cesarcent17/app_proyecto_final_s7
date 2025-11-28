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
      "fecha": fecha,
      "uid_usuario": uidUsuario,
    };
  }

  static Reporte fromMap(String id, Map<String, dynamic> map) {
    return Reporte(
      id: id,
      titulo: map['titulo'],
      descripcion: map['descripcion'],
      fecha: (map['fecha'] as Timestamp).toDate(),
      uidUsuario: map['uid_usuario'],
    );
  }
}
