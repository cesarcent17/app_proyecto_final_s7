import 'package:cloud_firestore/cloud_firestore.dart';

class UbicacionesService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> registrarUbicacion(double lat, double lng, String uid) async {
    await db.collection("ubicaciones").add({
      "latitud": lat,
      "longitud": lng,
      "uid": uid,
      "fecha": DateTime.now(),
    });
  }
}
