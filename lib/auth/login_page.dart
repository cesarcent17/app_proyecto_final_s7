import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/home_page.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            minimumSize: const Size(250, 45),
          ),
          icon: const Icon(Icons.login, color: Colors.white),
          label: const Text("Ingresar con Google",
              style: TextStyle(color: Colors.white)),
          onPressed: () async {
            final user = await authService.loginGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            }
          },
        ),
      ),
    );
  }
}
