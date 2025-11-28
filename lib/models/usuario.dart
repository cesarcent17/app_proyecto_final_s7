class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String foto;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.foto,
  });

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "email": email,
      "foto": foto,
    };
  }

  factory Usuario.fromMap(String uid, Map<String, dynamic> data) {
    return Usuario(
      uid: uid,
      nombre: data["nombre"] ?? "",
      email: data["email"] ?? "",
      foto: data["foto"] ?? "",
    );
  }
}
