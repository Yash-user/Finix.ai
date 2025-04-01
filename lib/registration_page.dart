import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:finix/login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool _isPasswordVisible = false; // To toggle password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center( // Center the content
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              _buildTextField(firstNameController, 'First Name'),
              SizedBox(height: 10),
              _buildTextField(lastNameController, 'Last Name'),
              SizedBox(height: 10),
              _buildTextField(emailController, 'Email'),
              SizedBox(height: 10),
              _buildPasswordField(passwordController, 'Password'),
              SizedBox(height: 10),
              _buildTextField(phoneController, 'Phone Number'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String password = passwordController.text;

                  // Check for empty fields
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields.')),
                    );
                    return;
                  }

                  // Check if the email already exists
                  if (await emailExists(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('The account already exists for that email.')),
                    );
                    return;
                  }

                  // Check if the email is valid
                  if (!await isEmailValid(email)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('The email ID does not exist. Please use a valid email ID.')),
                    );
                    return;
                  }

                  // Call the registerUser  function
                  await registerUser (email, password, context);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible; // Toggle password visibility
            });
          },
        ),
      ),
      style: TextStyle(fontSize: 16.0),
    );
  }

  Future<bool> emailExists(String email) async {
    try {
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty; // If not empty, the email exists
    } catch (e) {
      print('Error checking email existence: $e');
      return false; // Assume the email does not exist if there's an error
    }
  }

  Future<bool> isEmailValid(String email) async {
    // Basic email validation
    return email.contains('@') && email.contains('.'); // Check for basic email format
  }

  Future<void> registerUser (String email, String password, BuildContext context) async {
    try {
      // Attempt to create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // User registered successfully
      print("User  registered: ${userCredential.user?.uid}");

      // Navigate to the login page after successful registration
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The password provided is too weak.')),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The account already exists for that email.')),
        );
      } else {
        print('Error: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }
}