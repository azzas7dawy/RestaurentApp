import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/screens/auth/logic/cubit/auth_cubit.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_text_field.dart';
import 'package:restrant_app/widgets/auth_template_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String id = 'SignUp';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplateWidget(
      onSignUp: () async {
        if (_formKey.currentState!.validate()) {
          await context.read<AuthCubit>().signUp(
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                passwordController: _passwordController,
                context: context,
                isPhone: true, 
              );
        }
      },
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  AppTextField(
                    label: 'Full Name',
                    controller: _nameController,
                    validator: _nameValidator,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Email',
                    controller: _emailController,
                    validator: _emailValidator,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    validator: _phoneValidator,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    validator: _passwordValidator,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: _suffixonIconWidget(
                      isVisible: _isPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    obscureText: _isPasswordVisible,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    final nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter a valid name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Please enter your first and last name';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegExp = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Please enter a valid phone number (10-15 digits)';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
    if (!regex.hasMatch(value)) {
      return 'Password must include both letters and numbers';
    }
    return null;
  }

  Widget? _suffixonIconWidget({
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return IconButton(
      onPressed: toggleVisibility,
      icon: Icon(
        isVisible ? Icons.visibility_off : Icons.visibility,
        color: ColorsUtility.onboardingDescriptionColor,
      ),
    );
  }
}