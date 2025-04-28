import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  File? _imageFile;
  Uint8List? _webImageBytes;
  String _imageUrl = '';
  bool _isLoading = true;
  bool _isGoogleUser = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _cityController = TextEditingController();
    _addressController = TextEditingController();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _isGoogleUser =
            user.providerData.any((info) => info.providerId == 'google.com');

        final DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users2')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          setState(() {
            _nameController.text = data['name']?.toString() ?? '';
            _emailController.text =
                user.email ?? data['email']?.toString() ?? '';
            _phoneController.text = data['phone']?.toString() ?? '';
            _cityController.text = data['city']?.toString() ?? '';
            _addressController.text = data['address']?.toString() ?? '';
            _imageUrl = data['imageUrl']?.toString() ?? '';
            _isLoading = false;
          });

          await PrefService.saveUserData(
            userId: user.uid,
            name: _nameController.text,
            email: _emailController.text,
            phone: _phoneController.text,
            city: _cityController.text,
            address: _addressController.text,
          );

          if (_imageUrl.isNotEmpty) {
            await PrefService.saveUserImage(_imageUrl);
          } else if (_isGoogleUser && user.photoURL != null) {
            _imageUrl = user.photoURL!;
            await PrefService.saveUserImage(_imageUrl);
          }
        } else {
          final Map<String, String> userData = PrefService.userData;
          setState(() {
            _nameController.text = userData['userName'] ?? '';
            _emailController.text = userData['userEmail'] ?? '';
            _phoneController.text = userData['userPhone'] ?? '';
            _cityController.text = userData['userCity'] ?? '';
            _addressController.text = userData['userAddress'] ?? '';
            _imageUrl = userData['userImage'] ?? '';
            _isLoading = false;
          });
        }
      } else {
        final Map<String, String> userData = PrefService.userData;
        setState(() {
          _nameController.text = userData['userName'] ?? '';
          _emailController.text = userData['userEmail'] ?? '';
          _phoneController.text = userData['userPhone'] ?? '';
          _cityController.text = userData['userCity'] ?? '';
          _addressController.text = userData['userAddress'] ?? '';
          _imageUrl = userData['userImage'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      final Map<String, String> userData = PrefService.userData;
      setState(() {
        _nameController.text = userData['userName'] ?? '';
        _emailController.text = userData['userEmail'] ?? '';
        _phoneController.text = userData['userPhone'] ?? '';
        _cityController.text = userData['userCity'] ?? '';
        _addressController.text = userData['userAddress'] ?? '';
        _imageUrl = userData['userImage'] ?? '';
        _isLoading = false;
      });

      if (mounted) {
        appSnackbar(
          context,
          text: '${S.of(context).failed} ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          final Uint8List bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImageBytes = bytes;
            _imageFile = null;
          });
        } else {
          setState(() {
            _imageFile = File(pickedFile.path);
            _webImageBytes = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        appSnackbar(
          context,
          text: 'Failed to pick image: ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  ImageProvider? _getBackgroundImage() {
    if (kIsWeb && _webImageBytes != null) {
      return MemoryImage(_webImageBytes!);
    } else if (!kIsWeb && _imageFile != null) {
      return FileImage(_imageFile!);
    } else if (_imageUrl.isNotEmpty) {
      return CachedNetworkImageProvider(
        _imageUrl,
        errorListener: (error) {
          if (mounted) {
            appSnackbar(
              context,
              text: 'Failed to load profile image',
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        },
      );
    } else if (_isGoogleUser &&
        FirebaseAuth.instance.currentUser?.photoURL != null) {
      return CachedNetworkImageProvider(
        FirebaseAuth.instance.currentUser!.photoURL!,
        errorListener: (error) {
          if (mounted) {
            appSnackbar(
              context,
              text: 'Failed to load Google profile image',
              backgroundColor: Theme.of(context).colorScheme.error,
            );
          }
        },
      );
    }
    return null;
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).confirmDeleteAccount),
          content: Text(S.of(context).areYouSureDeleteAccount),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                S.of(context).yes,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showReAuthenticationDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showReAuthenticationDialog(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      appSnackbar(
        context,
        text: 'No user is currently signed in.',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    final bool isGoogleUser =
        user.providerData.any((info) => info.providerId == 'google.com');

    if (isGoogleUser) {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          appSnackbar(
            context,
            text: 'Google sign-in cancelled.',
            backgroundColor: Theme.of(context).colorScheme.error,
          );
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);

        await context.read<AuthCubit>().deleteAccount(
              context,
              email: user.email ?? '',
              password: '',
            );
      } catch (e) {
        appSnackbar(
          context,
          text: 'Google re-authentication failed: ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }
    } else {
      final TextEditingController passwordController = TextEditingController();
      final GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(S.of(context).reAuthenticate),
            content: Form(
              key: reAuthFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(S.of(context).pleaseReAuthenticate),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).enterPassword;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text(S.of(context).confirm),
                onPressed: () async {
                  if (reAuthFormKey.currentState!.validate()) {
                    Navigator.of(dialogContext).pop();
                    try {
                      await context.read<AuthCubit>().reAuthenticateUser(
                            email: user.email!,
                            password: passwordController.text.trim(),
                            context: context,
                          );

                      await context.read<AuthCubit>().deleteAccount(
                            context,
                            email: user.email!,
                            password: passwordController.text.trim(),
                          );
                    } catch (e) {
                      if (mounted) {
                        appSnackbar(
                          context,
                          text: 'Error: ${e.toString()}',
                          backgroundColor: Theme.of(context).colorScheme.error,
                        );
                      }
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : BlocListener<AuthCubit, AuthState>(
              listener: (BuildContext context, AuthState state) {
                if (state is ProfileUpdateSuccess) {
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    FirebaseFirestore.instance
                        .collection('users2')
                        .doc(user.uid)
                        .get()
                        .then((doc) {
                      String updatedImageUrl =
                          doc.exists ? (doc.get('imageUrl') ?? '') : '';
                      if (mounted) {
                        setState(() {
                          _imageFile = null;
                          _webImageBytes = null;
                          _imageUrl = updatedImageUrl.isNotEmpty
                              ? updatedImageUrl
                              : PrefService.userData['userImage'] ?? '';
                          _isEditing = false;
                        });
                      }
                    });
                  }
                } else if (state is ProfileUpdateFailed) {
                  if (mounted) {
                    appSnackbar(
                      context,
                      text: state.error,
                      backgroundColor: colorScheme.error,
                    );
                  }
                } else if (state is DeleteAccountSuccess) {
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.id,
                      (Route<dynamic> route) => false,
                    );
                  }
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Card(
                        color: theme.cardColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isEditing ? Icons.close : Icons.edit,
                                      color: colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = !_isEditing;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: _isEditing ? _pickImage : null,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: _getBackgroundImage(),
                                      child: _getBackgroundImage() == null
                                          ? Icon(
                                              Icons.person,
                                              size: 50,
                                              color:
                                                  ColorsUtility.onboardingColor,
                                            )
                                          : null,
                                    ),
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                theme.scaffoldBackgroundColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  enabledBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  focusedBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorScheme.primary),
                                        )
                                      : InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: theme.iconTheme.color,
                                  ),
                                  suffixIcon: _isEditing
                                      ? Icon(
                                          Icons.edit,
                                          color: colorScheme.primary,
                                        )
                                      : null,
                                ),
                                readOnly: !_isEditing,
                                validator: (String? value) {
                                  if (_isEditing &&
                                      (value == null || value.isEmpty)) {
                                    return S
                                        .of(context)
                                        .validationErrorFullName;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: theme.iconTheme.color,
                                  ),
                                ),
                                readOnly: true,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  border: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  enabledBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  focusedBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorScheme.primary),
                                        )
                                      : InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: theme.iconTheme.color,
                                  ),
                                  suffixIcon: _isEditing
                                      ? Icon(
                                          Icons.edit,
                                          color: colorScheme.primary,
                                        )
                                      : null,
                                ),
                                readOnly: !_isEditing,
                                validator: (String? value) {
                                  if (_isEditing &&
                                      (value == null || value.isEmpty)) {
                                    return S.of(context).enterPhone;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                controller: _cityController,
                                decoration: InputDecoration(
                                  border: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  enabledBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  focusedBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorScheme.primary),
                                        )
                                      : InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.location_city,
                                    color: theme.iconTheme.color,
                                  ),
                                  suffixIcon: _isEditing
                                      ? Icon(
                                          Icons.edit,
                                          color: colorScheme.primary,
                                        )
                                      : null,
                                ),
                                readOnly: !_isEditing,
                                validator: (String? value) {
                                  if (_isEditing &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your city';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                                controller: _addressController,
                                decoration: InputDecoration(
                                  border: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  enabledBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        )
                                      : InputBorder.none,
                                  focusedBorder: _isEditing
                                      ? UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: colorScheme.primary),
                                        )
                                      : InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.home,
                                    color: theme.iconTheme.color,
                                  ),
                                  suffixIcon: _isEditing
                                      ? Icon(
                                          Icons.edit,
                                          color: colorScheme.primary,
                                        )
                                      : null,
                                ),
                                readOnly: !_isEditing,
                                validator: (String? value) {
                                  if (_isEditing &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your address';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_isEditing)
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().updateUserProfile(
                                          name: _nameController.text.trim(),
                                          phone: _phoneController.text.trim(),
                                          city: _cityController.text.trim(),
                                          address:
                                              _addressController.text.trim(),
                                          imageFile: _imageFile,
                                          webImageBytes: _webImageBytes,
                                          context: context,
                                        );
                                  } else {
                                    appSnackbar(
                                      context,
                                      text: S.of(context).fillAllFields,
                                      backgroundColor: colorScheme.error,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(S.of(context).saveButton),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: colorScheme.error,
                            ),
                          ),
                          child: Text(
                            S.of(context).deleteAccount,
                            style: TextStyle(
                              color: colorScheme.error,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
