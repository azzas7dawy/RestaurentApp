import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
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
          text: 'Failed to load user data: ${e.toString()}',
          backgroundColor: ColorsUtility.errorSnackbarColor,
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
          backgroundColor: ColorsUtility.errorSnackbarColor,
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
              backgroundColor: ColorsUtility.errorSnackbarColor,
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
              backgroundColor: ColorsUtility.errorSnackbarColor,
            );
          }
        },
      );
    }
    return null;
  }

  // void _showDeleteAccountDialog(BuildContext parentContext) {
  //   showDialog(
  //     context: parentContext,
  //     builder: (BuildContext dialogContext) {
  //       return AppConfirmationDialog(
  //         title: 'Delete Account',
  //         message:
  //             'Are you sure you want to delete your account? This action cannot be undone.',
  //         confirmText: 'Delete',
  //         onConfirm: () async {
  //           Navigator.of(dialogContext).pop();
  //           await parentContext.read<AuthCubit>().deleteAccount(parentContext);
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsUtility.progressIndictorColor,
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
                      backgroundColor: ColorsUtility.errorSnackbarColor,
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
                      const SizedBox(
                        height: 50,
                      ),
                      Card(
                        color: ColorsUtility.elevatedBtnColor,
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
                                      color:
                                          ColorsUtility.progressIndictorColor,
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
                                          ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: ColorsUtility
                                                  .mainBackgroundColor,
                                            )
                                          : null,
                                    ),
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: ColorsUtility
                                                .mainBackgroundColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: ColorsUtility
                                                .progressIndictorColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                style: const TextStyle(
                                  color: ColorsUtility.progressIndictorColor,
                                ),
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: _isEditing
                                      ? const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsUtility
                                                  .elevatedBtnColor),
                                        )
                                      : InputBorder.none,
                                  enabledBorder: _isEditing
                                      ? const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsUtility
                                                  .mainBackgroundColor),
                                        )
                                      : InputBorder.none,
                                  focusedBorder: _isEditing
                                      ? const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsUtility
                                                  .mainBackgroundColor),
                                        )
                                      : InputBorder.none,
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: ColorsUtility.progressIndictorColor,
                                  ),
                                  suffixIcon: _isEditing
                                      ? const Icon(
                                          Icons.edit,
                                          color: ColorsUtility
                                              .progressIndictorColor,
                                        )
                                      : null,
                                ),
                                readOnly: !_isEditing,
                                validator: (String? value) {
                                  if (_isEditing &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: const TextStyle(
                                  color: ColorsUtility.progressIndictorColor,
                                ),
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: ColorsUtility.progressIndictorColor,
                                  ),
                                ),
                                readOnly: true,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                style: const TextStyle(
                                  color: ColorsUtility.progressIndictorColor,
                                ),
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  border: _isEditing
                                      ? const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsUtility
                                                  .elevatedBtnColor),
                                        )
                                      : InputBorder.none,
                                  enabledBorder: _isEditing
                                      ? const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsUtility
                                                  .mainBackgroundColor),
                                        )
                                      : InputBorder.none,
                                  focusedBorder: _isEditing
                                      ? const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsUtility
                                                  .mainBackgroundColor),
                                        )
                                      : InputBorder.none,
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: ColorsUtility.progressIndictorColor,
                                  ),
                                  suffixIcon: _isEditing
                                      ? const Icon(
                                          Icons.edit,
                                          color: ColorsUtility
                                              .progressIndictorColor,
                                        )
                                      : null,
                                ),
                                readOnly: !_isEditing,
                                validator: (String? value) {
                                  if (_isEditing &&
                                      (value == null || value.isEmpty)) {
                                    return 'Please enter your phone number';
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
                                      text: 'Please fill all required fields',
                                      backgroundColor:
                                          ColorsUtility.errorSnackbarColor,
                                    );
                                  }
                                },
                                text: 'Save Changes',
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            // _showDeleteAccountDialog(context);
                            await context.read<AuthCubit>().deleteAccount(
                                  context,
                                );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: ColorsUtility.errorSnackbarColor,
                            ),
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              color: ColorsUtility.errorSnackbarColor,
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
