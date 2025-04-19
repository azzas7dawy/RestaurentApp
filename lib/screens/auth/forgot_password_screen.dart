import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
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
               Text(
               S.of(context).resetEmail,
                style: TextStyle(
                    fontSize: 16, color: ColorsUtility.textFieldLabelColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 70),
              AppTextField(
                controller: _emailController,
                label: S.of(context).email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return emailValidator(value, context);
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
                    text: S.of(context).sendButton,
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

  String? emailValidator(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return S.of(context).validationErrorEmail;
    } else if (!value.contains('@')) {
      return '${S.of(context).validEmail}';
    }
    return null;
  }
}
