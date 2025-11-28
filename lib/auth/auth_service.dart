import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UsuarioService usuarioService = UsuarioService();

  Stream<User?> get userState => _auth.authStateChanges();

  Future<User?> loginGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred =
          await _auth.signInWithCredential(credential);

      final user = userCred.user!;
      final uid = user.uid;

      // Verificar si el usuario ya existe
      final existe = await usuarioService.obtener(uid);

      if (existe == null) {
        await usuarioService.crearUsuario(
          Usuario(
            uid: uid,
            nombre: user.displayName ?? "Sin nombre",
            email: user.email ?? "",
            foto: user.photoURL ?? "",
          ),
        );
      }

      return user;

    } catch (e) {
      print("ERROR LOGIN GOOGLE => $e");
      return null;
    }
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }
}
