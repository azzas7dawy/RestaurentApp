
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restrant_app/screens/register/signUp_srceen.dart';

class LoginScreen extends StatelessWidget {
 const LoginScreen({super.key});
  static const String id = 'Login_Screen';

  

  @override
  Widget build(BuildContext context) {
    return 
     Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 130),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please login to your account",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(hint: "Email/Ph number", obscureText: false),
              const SizedBox(height: 16),
              _buildTextField(hint: "Password", obscureText: true),
              // SizedBox(height: 24),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
      
                  Image.asset(
                    "./assets/images/googlelogo.jpg", // ضع مسار أيقونة جوجل هنا
                    height: 24,
                    width: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Login with Google",
                    style:TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupSrceen.id);                   },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    
  }
}

Widget _buildTextField({required String hint, required bool obscureText}) {
  return TextField(
    obscureText: obscureText,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey[900],
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white60),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      suffixIcon: obscureText
          ? const Icon(Icons.visibility, color: Colors.white60)
          : null,
    ),
  );
}

