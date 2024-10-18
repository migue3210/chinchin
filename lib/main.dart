import 'package:chinchin/pages/home_page/home_page.dart';
import 'package:chinchin/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'Prueba Técnica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _getInitialPage(),
    );
  }

  Widget _getInitialPage() {
    // Check if a user is signed in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in, navigate to HomePage
      return HomePage();
    } else {
      // No user is signed in, navigate to LoginPage
      return LoginPage();
    }
  }
}
