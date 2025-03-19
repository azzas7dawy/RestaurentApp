import 'package:flutter/material.dart';

import 'login_screen.dart';


class SignupSrceen extends StatelessWidget {
  static const String id = 'signup_screen';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
          hintStyle: const TextStyle(color: Colors.white54),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white54),
          ),
        ),
      ),
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Text(
                "Create a new account",

                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 5),
              const Text(
                "Please fill in the form to continue",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 30),
              _buildTextField("Full Name"),
              const SizedBox(height: 15),
              _buildTextField("Email"),
              const SizedBox(height: 15),
              _buildTextField("Phone number"),
              const SizedBox(height: 15),
              ValueListenableBuilder(
                valueListenable: _obscurePassword,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _passwordController,
                    obscureText: value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(value ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                        onPressed: () => _obscurePassword.value = !value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("SIGN IN", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold, color: Colors.white),),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("./assets/images/googlelogo.jpg", width: 30),
                  const SizedBox(width: 15),
                  const Text("Sign in with Google", style: TextStyle(fontSize: 16)),
                ],
              ),
              // SizedBox(height: 20),
              const Spacer(),
              GestureDetector(
                onTap: () {
                     Navigator.pushNamed(context, LoginScreen.id);
                },
                child: const Text(
                  "Have an account? Login",
                  style: TextStyle( fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextFormField(

      decoration: InputDecoration(

        hintText: hintText,
      ),
    );
  }
}
