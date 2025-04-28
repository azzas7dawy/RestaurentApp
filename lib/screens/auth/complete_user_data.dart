import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:restrant_app/widgets/app_text_field.dart';
import 'package:restrant_app/services/pref_service.dart';

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
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (widget.isGoogleSignIn && widget.user.displayName != null) {
      _nameController.text = widget.user.displayName!;
    } else if (!widget.isGoogleSignIn) {
      await PrefService.init();
      final userData = PrefService.userData;
      _nameController.text =
          userData['userName'] ?? widget.user.displayName ?? '';
      _phoneController.text = userData['userPhone'] ?? '';
      _cityController.text = userData['userCity'] ?? '';
      _addressController.text = userData['userAddress'] ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark;
    // final Color appBarTextColor = isDark
    //     ? ColorsUtility.takeAwayColor
    //     : ColorsUtility.progressIndictorColor;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ProfileUpdateFailed) {
          appSnackbar(
            context,
            text: state.error,
            backgroundColor: ColorsUtility.errorSnackbarColor,
          );
        } else if (state is ProfileUpdateSuccess) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, CustomScreen.id);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            S.of(context).completeProfile,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: theme.textTheme.titleLarge?.fontSize,
            ),
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          actions: [
            TextButton(
              onPressed: () {
                final name = widget.isGoogleSignIn
                    ? (widget.user.displayName ?? '')
                    : (widget.user.displayName ??
                        PrefService.userData['userName'] ??
                        '');

                final phone = widget.isGoogleSignIn
                    ? ''
                    : PrefService.userData['userPhone'] ?? '';

                context.read<AuthCubit>().completeUserProfile(
                      user: widget.user,
                      name: name,
                      phone: phone,
                      city: '',
                      address: '',
                      isGoogleSignIn: widget.isGoogleSignIn,
                      context: context,
                    );
              },
              child: Text(
                S.of(context).skipButton,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: theme.textTheme.titleSmall?.fontSize,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
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
                    Text(
                      S.of(context).completeDetails,
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
                            label: S.of(context).fullName,
                            keyboardType: TextInputType.name,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    if (widget.isGoogleSignIn)
                      Column(
                        children: [
                          AppTextField(
                            controller: _phoneController,
                            label: S.of(context).enterPhone,
                            keyboardType: TextInputType.phone,
                            validator: _validatePhone,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    AppTextField(
                      controller: _cityController,
                      label: S.of(context).city,
                      keyboardType: TextInputType.text,
                      validator: _validateCity,
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: _addressController,
                      label: S.of(context).address,
                      keyboardType: TextInputType.streetAddress,
                      validator: _validateAddress,
                    ),
                    const SizedBox(height: 40),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return AppElevatedBtn(
                          onPressed: state is ProfileUpdateLoading
                              ? null
                              : _updateUserData,
                          text: S.of(context).saveButton,
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

    final name = widget.isGoogleSignIn
        ? (_nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : widget.user.displayName ?? '')
        : (_nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : widget.user.displayName ?? '');

    final phone = widget.isGoogleSignIn
        ? _phoneController.text.trim()
        : (_phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : PrefService.userData['userPhone'] ?? '');

    final city = _cityController.text.trim();
    final address = _addressController.text.trim();

    context.read<AuthCubit>().completeUserProfile(
          user: widget.user,
          name: name,
          phone: phone,
          city: city,
          address: address,
          isGoogleSignIn: widget.isGoogleSignIn,
          context: context,
        );
  }

  String? _validateName(String? value) {
    if (widget.isGoogleSignIn && (value == null || value.isEmpty)) {
      return S.of(context).validationErrorFullName;
    }
    if (value != null && value.length < 3) {
      return S.of(context).threeLetterName;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (widget.isGoogleSignIn && (value == null || value.isEmpty)) {
      return S.of(context).enterPhone;
    }
    if (value != null && !RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return S.of(context).validPhone;
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your city';
    }
    if (value.length < 2) {
      return 'City name is too short';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    if (value.length < 10) {
      return 'Address is too short';
    }
    return null;
  }
}
