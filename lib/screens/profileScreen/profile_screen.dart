// import 'dart:io' as io;
// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
// import 'package:restrant_app/services/pref_service.dart';
// import 'package:restrant_app/utils/colors_utility.dart';
// import 'package:restrant_app/widgets/app_snackbar.dart';

// class ProfileScreen extends StatefulWidget {
//   static const String id = 'ProfileScreen';

//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   io.File? _imageFile;
//   Uint8List? _webImage;
//   bool _isLoading = false;
//   String? _imageUrl;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     final userData = await PrefService.getUserData();
//     if (userData['imageUrl'] != null) {
//       setState(() {
//         _imageUrl = userData['imageUrl'];
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final pickedFile = await picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 85,
//       );

//       if (pickedFile != null) {
//         if (kIsWeb) {
//           final bytes = await pickedFile.readAsBytes();
//           setState(() {
//             _webImage = bytes;
//           });
//           await _uploadImageWeb(bytes);
//         } else {
//           setState(() {
//             _imageFile = io.File(pickedFile.path);
//           });
//           await _uploadImageMobile();
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         appSnackbar(
//           context,
//           text: 'Failed to pick image: ${e.toString()}',
//           backgroundColor: ColorsUtility.errorSnackbarColor,
//         );
//       }
//     }
//   }

//   Future<void> _uploadImageWeb(Uint8List imageBytes) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('profile_images')
//           .child('${user.uid}.jpg');

//       final metadata = SettableMetadata(contentType: 'image/jpeg');

//       await storageRef.putData(imageBytes, metadata);
//       final downloadUrl = await storageRef.getDownloadURL();

//       await FirebaseFirestore.instance
//           .collection('users2')
//           .doc(user.uid)
//           .update({'imageUrl': downloadUrl});

//       await PrefService.saveUserImage(downloadUrl);

//       setState(() {
//         _imageUrl = downloadUrl;
//         _isLoading = false;
//       });

//       if (mounted) {
//         appSnackbar(
//           context,
//           text: 'Profile picture updated successfully!',
//           backgroundColor: ColorsUtility.successSnackbarColor,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       if (mounted) {
//         appSnackbar(
//           context,
//           text: 'Failed to upload image: ${e.toString()}',
//           backgroundColor: ColorsUtility.errorSnackbarColor,
//         );
//       }
//     }
//   }

//   Future<void> _uploadImageMobile() async {
//     if (_imageFile == null) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) return;

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('profile_images')
//           .child('${user.uid}.jpg');

//       final metadata = SettableMetadata(contentType: 'image/jpeg');

//       await storageRef.putFile(_imageFile!, metadata);
//       final downloadUrl = await storageRef.getDownloadURL();

//       await FirebaseFirestore.instance
//           .collection('users2')
//           .doc(user.uid)
//           .update({'imageUrl': downloadUrl});

//       await PrefService.saveUserImage(downloadUrl);

//       setState(() {
//         _imageUrl = downloadUrl;
//         _isLoading = false;
//       });

//       if (mounted) {
//         appSnackbar(
//           context,
//           text: 'Profile picture updated successfully!',
//           backgroundColor: ColorsUtility.successSnackbarColor,
//         );
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       if (mounted) {
//         appSnackbar(
//           context,
//           text: 'Failed to upload image: ${e.toString()}',
//           backgroundColor: ColorsUtility.errorSnackbarColor,
//         );
//       }
//     }
//   }

//   void _showEditNameDialog(String currentName) {
//     final TextEditingController nameController =
//         TextEditingController(text: currentName);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Name'),
//           content: TextField(
//             controller: nameController,
//             decoration: const InputDecoration(
//               labelText: 'New Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 final newName = nameController.text.trim();
//                 if (newName.isNotEmpty) {
//                   final userData = await PrefService.getUserData();
//                   if (context.mounted) {
//                     await context.read<AuthCubit>().updateUserProfile(
//                           name: newName,
//                           phone: userData['phone'] ?? '',
//                           context: context,
//                         );
//                   }
//                   if (context.mounted) Navigator.of(context).pop();
//                 } else {
//                   appSnackbar(
//                     context,
//                     text: 'Name cannot be empty',
//                     backgroundColor: ColorsUtility.errorSnackbarColor,
//                   );
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<AuthCubit, AuthState>(
//         builder: (context, state) {
//           return FutureBuilder<Map<String, dynamic>?>(
//             future: PrefService.getUserData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final userData = snapshot.data;
//               if (userData == null) {
//                 return const Center(child: Text('No user data found'));
//               }

//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Stack(
//                         children: [
//                           _isLoading
//                               ? const CircularProgressIndicator()
//                               : CircleAvatar(
//                                   radius: 60,
//                                   backgroundColor:
//                                       ColorsUtility.progressIndictorColor,
//                                   backgroundImage: _imageUrl != null
//                                       ? CachedNetworkImageProvider(_imageUrl!)
//                                       : kIsWeb && _webImage != null
//                                           ? MemoryImage(_webImage!)
//                                           : _imageFile != null
//                                               ? FileImage(_imageFile!)
//                                               : null,
//                                   child: (_imageUrl == null &&
//                                           _imageFile == null &&
//                                           _webImage == null)
//                                       ? const Icon(Icons.person,
//                                           size: 60,
//                                           color: ColorsUtility.onboardingColor)
//                                       : null,
//                                 ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                 color: ColorsUtility.takeAwayColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: IconButton(
//                                 icon: const Icon(Icons.camera_alt,
//                                     color: ColorsUtility.onboardingColor),
//                                 onPressed: _pickImage,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     _buildProfileItem(
//                       value: userData['name'] ?? 'Not provided',
//                       showEditButton: true,
//                       onEdit: () => _showEditNameDialog(userData['name'] ?? ''),
//                     ),
//                     _buildProfileItem(
//                       value: userData['email'] ?? 'Not provided',
//                     ),
//                     _buildProfileItem(
//                       value: userData['phone'] ?? 'Not provided',
//                     ),
//                     const SizedBox(height: 30),
//                     Align(
//                       alignment: AlignmentDirectional.bottomEnd,
//                       child: TextButton(
//                         onPressed: () {
//                           context.read<AuthCubit>().deleteAccount(context);
//                         },
//                         child: const Text(
//                           'Delete Account',
//                           style: TextStyle(
//                             color: ColorsUtility.errorSnackbarColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildProfileItem({
//     required String value,
//     bool showEditButton = false,
//     VoidCallback? onEdit,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: ColorsUtility.progressIndictorColor,
//                 ),
//               ),
//               if (showEditButton)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.edit,
//                     color: ColorsUtility.takeAwayColor,
//                   ),
//                   onPressed: onEdit,
//                 ),
//             ],
//           ),
//           const Divider(
//             color: ColorsUtility.progressIndictorColor,
//             thickness: 1,
//           ),
//         ],
//       ),
//     );
//   }
// }
