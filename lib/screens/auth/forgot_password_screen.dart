import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  static const String id = 'ForgotPasswordScreen';

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Enter your email address to receive a password reset link',
                style: TextStyle(
                    fontSize: 16, color: ColorsUtility.textFieldLabelColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 70),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return emailValidator(value);
                },
              ),
              const SizedBox(height: 70),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is ResetPasswordLoading) {
                    return const CircularProgressIndicator(
                      color: ColorsUtility.progressIndictorColor,
                    );
                  }
                  return AppElevatedBtn(
                    text: 'Send Reset Link',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().resetPassword(
                              email: _emailController.text.trim(),
                              context: context,
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
