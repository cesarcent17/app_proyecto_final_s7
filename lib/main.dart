import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'auth/login_page.dart';
import 'pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Proyecto Final UISRAEL",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade200,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),

      // 🔥 Redirección automática de sesión
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Si está logueado → Home
          if (snapshot.hasData) {
            return HomePage();
          }

          // Si no → Login
          return LoginPage();
        },
      ),
    );
  }
}
