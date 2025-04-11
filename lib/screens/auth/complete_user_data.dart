import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_text_field.dart';

class CompleteUserDataScreen extends StatefulWidget {
  const CompleteUserDataScreen({
    super.key,
    required this.user,
    this.isGoogleSignIn = false,
  });

  final User user;
  final bool isGoogleSignIn;

  static const String id = 'CompleteUserData';

  @override
  State<CompleteUserDataScreen> createState() => _CompleteUserDataScreenState();
}

class _CompleteUserDataScreenState extends State<CompleteUserDataScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.isGoogleSignIn && widget.user.displayName != null) {
      _nameController.text = widget.user.displayName!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ProfileUpdateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorsUtility.errorSnackbarColor,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Please provide the following details:',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorsUtility.textFieldLabelColor),
                    ),
                    const SizedBox(height: 30),
                    if (widget.isGoogleSignIn &&
                        (widget.user.displayName == null ||
                            widget.user.displayName!.isEmpty))
                      Column(
                        children: [
                          AppTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            keyboardType: TextInputType.name,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    AppTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppElevatedBtn(
                          onPressed: state is ProfileUpdateLoading
                              ? null
                              : _updateUserData,
                          text: 'Save Profile',
                          isLoading: state is ProfileUpdateLoading,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    context.read<AuthCubit>().completeUserProfile(
          user: widget.user,
          name: name,
          phone: phone,
          isGoogleSignIn: widget.isGoogleSignIn,
          context: context,
        );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter phone number';
    }
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'Enter valid phone number (10-15 digits)';
    }
    return null;
  }
}
