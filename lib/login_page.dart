import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'home_page.dart'; // Import the home page
import 'registration_page.dart'; // Import the registration page
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Display error message if it exists
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text;
                String password = passwordController.text;

                await loginUser (email, password);
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: Text('Don\'t have an account? Register here'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await signInWithGoogle();
              },
              child: Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser (String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setState(() {
        errorMessage = ''; // Clear any previous error message
      });

      print("User  logged in: ${userCredential.user?.uid}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        // Update the error message as per the exception
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = 'Invalid username or password. Please try again.';
        } else {
          errorMessage = 'Error: ${e.message}';
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred.';
      });
      print(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser  = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser ?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        errorMessage = ''; // Clear any previous error message
      });

      print("User  logged in with Google: ${userCredential.user?.uid}");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to sign in with Google.';
      });
      print(e);
    }
  }
}