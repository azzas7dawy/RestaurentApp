import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
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
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _isGoogleUser =
            user.providerData.any((info) => info.providerId == 'google.com');

        if (_isGoogleUser) {
          String phone = '';
          String imageUrl = '';
          final DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('users2')
              .doc(user.uid)
              .get();

          if (doc.exists) {
            phone = doc.get('phone') ?? '';
            imageUrl = doc.get('imageUrl') ?? '';
          }

          if (imageUrl.isEmpty) {
            imageUrl = user.photoURL ?? '';
          }

          setState(() {
            _nameController.text = user.displayName ?? '';
            _emailController.text = user.email ?? '';
            _phoneController.text = phone;
            _imageUrl = imageUrl;
            _isLoading = false;
          });

          await PrefService.saveUserData(
            userId: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phone: phone,
          );

          if (_imageUrl.isNotEmpty) {
            await PrefService.saveUserImage(_imageUrl);
          }
        } else {
          final DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('users2')
              .doc(user.uid)
              .get();

          if (doc.exists) {
            final Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
            final Map<String, String> userData = {
              'userId': user.uid,
              'userName': data['name']?.toString() ?? '',
              'userEmail': data['email']?.toString() ?? '',
              'userPhone': data['phone']?.toString() ?? '',
              'userImage': data['imageUrl']?.toString() ?? '',
            };

            await PrefService.saveUserData(
              userId: userData['userId']!,
              name: userData['userName']!,
              email: userData['userEmail']!,
              phone: userData['userPhone']!,
            );

            if (userData['userImage']!.isNotEmpty) {
              await PrefService.saveUserImage(userData['userImage']!);
            }

            setState(() {
              _nameController.text = userData['userName']!;
              _emailController.text = userData['userEmail']!;
              _phoneController.text = userData['userPhone']!;
              _imageUrl = userData['userImage']!;
              _isLoading = false;
            });
          } else {
            final Map<String, String> userData = PrefService.userData;
            setState(() {
              _nameController.text = userData['userName'] ?? '';
              _emailController.text = userData['userEmail'] ?? '';
              _phoneController.text = userData['userPhone'] ?? '';
              _imageUrl = userData['userImage'] ?? '';
              _isLoading = false;
            });
          }
        }
      } else {
        final Map<String, String> userData = PrefService.userData;
        setState(() {
          _nameController.text = userData['userName'] ?? '';
          _emailController.text = userData['userEmail'] ?? '';
          _phoneController.text = userData['userPhone'] ?? '';
          _imageUrl = userData['userImage'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        appSnackbar(
          context,
          text: '${S.of(context).failed} ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      }

      final Map<String, String> userData = PrefService.userData;
      setState(() {
        _nameController.text = userData['userName'] ?? '';
        _emailController.text = userData['userEmail'] ?? '';
        _phoneController.text = userData['userPhone'] ?? '';
        _imageUrl = userData['userImage'] ?? '';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
                              child: AppElevatedBtn(
                                onPressed: () {
                                  if (_formKey.currentState != null &&
                                      _formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().updateUserProfile(
                                          name: _nameController.text.trim(),
                                          phone: _phoneController.text.trim(),
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
                                text: S.of(context).saveButton,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            await context.read<AuthCubit>().deleteAccount(
                                  context,
                                );
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
