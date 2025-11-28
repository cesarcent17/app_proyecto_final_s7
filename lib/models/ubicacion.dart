class Ubicacion {
  String? id;
  double latitud;
  double longitud;
  DateTime fecha;
  String uidUsuario;

  Ubicacion({
    this.id,
    required this.latitud,
    required this.longitud,
    required this.fecha,
    required this.uidUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      "latitud": latitud,
      "longitud": longitud,
      "fecha": fecha,
      "uid_usuario": uidUsuario,
    };
  }

  static Ubicacion fromMap(String id, Map<String, dynamic> map) {
    return Ubicacion(
      id: id,
      latitud: map['latitud'],
      longitud: map['longitud'],
      fecha: (map['fecha'] as Timestamp).toDate(),
      uidUsuario: map['uid_usuario'],
    );
  }
}
