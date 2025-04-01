import 'package:finix/login/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'home_page.dart';
import 'package:finix/login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FinixApp());
}

class FinixApp extends StatelessWidget {
  const FinixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finix.ai',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return LoginPage(); // User is not logged in
            } else {
              return HomePage(); // User is logged in
            }
          } else {
            return Center(child: CircularProgressIndicator()); // Loading state
          }
        },
      ),
      routes: {
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}