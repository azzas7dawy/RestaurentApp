import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/auth/forgot_password_screen.dart';
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
      listener: (context, state) {},
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
                    label: S.of(context).emailOrPhone,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _passwordController,
                    validator: _passwordValidator,
                    label: S.of(context).password,
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
                      child:  Text(
                        S.of(context).forgotPassword,
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
      return S.of(context).validationErrorEmail;
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.of(context).validationErrorPassword;
    } else if (value.length < 6) {
      return S.of(context).validationErrorPasswordLength;
    }
    return null;
  }
}
