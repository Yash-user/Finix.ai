import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:finix/login/login_page.dart';
import 'package:finix/utils/countrylist.dart';

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
  final TextEditingController countryController = TextEditingController();
  String? selectedRiskAppetite;
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
          child: Wrap(
            //mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            spacing: 10.0, // Horizontal space between items
            runSpacing: 10.0, // Vertical space between lines
            alignment: WrapAlignment.center, // Center items horizontally
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
              SizedBox(height: 10),
              _buildTextField(countryController, 'Country'),
              SizedBox(height: 10),
              _buildRiskAppetiteDropdown(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String password = passwordController.text;
                  String country = countryController.text.toLowerCase();

                  // Check for empty fields
                  if (firstNameController.text.isEmpty ||
                      lastNameController.text.isEmpty ||
                      email.isEmpty ||
                      password.isEmpty ||
                      phoneController.text.isEmpty ||
                      country.isEmpty ||
                      selectedRiskAppetite == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields.')),
                    );
                    return;
                  }

                  // Validate country
                  if (!countries.contains(country)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid country.')),
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

                  // Call the registerUser function
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

  Widget _buildRiskAppetiteDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedRiskAppetite,
      hint: Text('Select Risk Appetite'),
      items: ['High', 'Medium', 'Low'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedRiskAppetite = newValue;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
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
      print("User registered: ${userCredential.user?.uid}");

      // Store additional user data in Firestore
      try {
        await FirebaseFirestore.instance.collection("finix").add({
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'country': countryController.text.trim(),
          'risk': selectedRiskAppetite,
        });
        print("User  data stored in Firestore successfully.");
      } catch (e) {
        print("Error storing user data in Firestore: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error storing user data in Firestore: $e')),
        );
      }

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