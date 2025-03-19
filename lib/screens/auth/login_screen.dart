import 'package:flutter/material.dart';
import 'package:restrant_app/screens/foodHomeScreen/food_home_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_text_field.dart';
import 'package:restrant_app/widgets/auth_template_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'LogIn';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onLogin: () async{
        if (_formKey.currentState!.validate()) {
          Navigator.pushNamed(context, FoodHomeScreen.id);
        }
      },
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _emailController,
                  validator: _emailValidator,
                  label: 'Email/Ph number',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                AppTextField(
                  controller: _passwordController,
                  validator: _passwordValidator,
                  label: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      isVisible = !isVisible;
                      setState(() {});
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: ColorsUtility.onboardingDescriptionColor,
                    ),
                  ),
                  obscureText: isVisible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
