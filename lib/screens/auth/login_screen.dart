import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/screens/auth/forgot_password_screen.dart';
import 'package:restrant_app/screens/auth/logic/cubit/auth_cubit.dart';
import 'package:restrant_app/screens/home_screen.dart';
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
  late TextEditingController _emailOrPhoneController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = true;

  @override
  void initState() {
    _emailOrPhoneController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorsUtility.errorSnackbarColor,
            ),
          );
        }
      },
      child: AuthTemplateWidget(
        isLoading: context.select<AuthCubit, bool>(
          (cubit) => cubit.state is LoginLoading,
        ),
        onLogin: () async {
          if (_formKey.currentState!.validate()) {
            await context.read<AuthCubit>().login(
                  emailOrPhone: _emailOrPhoneController.text.trim(),
                  password: _passwordController.text.trim(),
                  context: context,
                );
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, HomeScreen.id);
            }
          }
        },
        body: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _emailOrPhoneController,
                    validator: _emailOrPhoneValidator,
                    label: 'Email/Phone number',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _passwordController,
                    validator: _passwordValidator,
                    label: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
                        color: ColorsUtility.onboardingDescriptionColor,
                      ),
                    ),
                    obscureText: isVisible,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ForgotPasswordScreen.id,
                        );
                      },
                      child: const Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: ColorsUtility.takeAwayColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _emailOrPhoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email or phone number';
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
