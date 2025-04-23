import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
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
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
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
    // final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // if (state is SignupFailed) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(state.error),
        //       backgroundColor: ColorsUtility.errorSnackbarColor,
        //     ),
        //   );
        // }
      },
      child: AuthTemplateWidget(
        isLoading: context.select<AuthCubit, bool>(
          (cubit) => cubit.state is SignupLoading,
        ),
        onSignUp: _submitForm,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: S.of(context).fullName,
                  controller: _nameController,
                  validator: _nameValidator,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: S.of(context).email,
                  controller: _emailController,
                  validator: _emailValidator,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: S.of(context).phoneNumber,
                  controller: _phoneController,
                  validator: _phoneValidator,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: S.of(context).password,
                  controller: _passwordController,
                  validator: _passwordValidator,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: _suffixIconWidget(
                    isVisible: _isPasswordVisible,
                    toggleVisibility: () => setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    }),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: S.of(context).confirmPassword,
                  controller: _confirmPasswordController,
                  validator: _confirmPasswordValidator,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: _suffixIconWidget(
                    isVisible: _isConfirmPasswordVisible,
                    toggleVisibility: () => setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    }),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<AuthCubit>().signUp(
            context: context,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phone: _phoneController.text.trim(),
          );
    }
  }

  String? _nameValidator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return S.of(context).validationErrorFullName;
    }
    if (!RegExp(r'^[A-Za-z ]+$').hasMatch(trimmedValue)) {
      return S.of(context).validName;
    }
    if (trimmedValue.length < 2) {
      return S.of(context).nameLength;
    }
    if (trimmedValue.split(' ').length < 2) {
      return S.of(context).firstAndLastName;
    }
    return null;
  }

  String? _emailValidator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return S.of(context).validationErrorEmail;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(trimmedValue)) {
      return S.of(context).validEmail;
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return S.of(context).enterPhone;
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(trimmedValue)) {
      return S.of(context).validPhone;
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return S.of(context).validationErrorPassword;
    }
    if (trimmedValue.length < 8) {
      return S.of(context).validationErrorPasswordLength;
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(trimmedValue)) {
      return S.of(context).enetrLetterNumberPassword;
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return S.of(context).matchPassword;
    }
    return null;
  }

  Widget _suffixIconWidget({
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    // final theme = Theme.of(context);
    return IconButton(
      onPressed: toggleVisibility,
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        color: ColorsUtility.textFieldLabelColor,
      ),
    );
  }
}
