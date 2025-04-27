import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:restrant_app/screens/adminDashbord/admin/admin_dashboard.dart';
import 'package:restrant_app/screens/auth/complete_user_data.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/customScreen/custom_screen.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static const String _adminEmail = 'admin@gmail.com';
  static const String _adminPassword = 'aaaAAA111!!!';

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required BuildContext context,
  }) async {
    emit(SignupLoading());
    try {
      final phoneQuery = await _firestore
          .collection('users2')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'phone-already-in-use',
          message: 'Phone number already registered',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name);
        await _saveUserDataToFirestore(
          userId: userCredential.user!.uid,
          email: email,
          name: name,
          phone: phone,
          city: '',
          address: '',
          provider: 'email',
          isProfileComplete: false,
          imageUrl: '',
        );

        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
          city: '',
          address: '',
        );

        emit(SignupSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Registration successful! Please complete your profile',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompleteUserDataScreen(
                user: userCredential.user!,
                isGoogleSignIn: false,
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e);
      emit(SignupFailed(errorMessage));
      if (context.mounted) {
        appSnackbar(
          context,
          text: errorMessage,
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    } catch (e) {
      const errorMessage = 'An unexpected error occurred. Please try again.';
      emit(SignupFailed(errorMessage));
      if (context.mounted) {
        appSnackbar(
          context,
          text: errorMessage,
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Future<void> login({
    required String emailOrPhone,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    try {
      if (emailOrPhone == _adminEmail && password == _adminPassword) {
        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: 'admin',
          name: 'Admin',
          email: _adminEmail,
          phone: '',
          city: '',
          address: '',
        );

        emit(LoginSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Admin login successful!',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );
          Navigator.pushReplacementNamed(context, DashboardHomeScreen.id);
        }
        return;
      }
      final isEmail = emailOrPhone.contains('@');
      String emailToUse = emailOrPhone;

      if (!isEmail) {
        final userData = await _findUserByPhoneNumber(emailOrPhone);
        if (userData == null) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No account found with this phone number',
          );
        }
        emailToUse = userData['email'];
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailToUse,
        password: password,
      );

      if (userCredential.user != null) {
        final doc = await _firestore
            .collection('users2')
            .doc(userCredential.user!.uid)
            .get();
        String phone = '';
        String city = '';
        String address = '';
        String imageUrl = '';
        if (doc.exists) {
          phone = doc.data()?['phone'] ?? '';
          city = doc.data()?['city'] ?? '';
          address = doc.data()?['address'] ?? '';
          imageUrl = doc.data()?['imageUrl'] ?? '';
        }

        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
          phone: phone,
          city: city,
          address: address,
        );
        if (imageUrl.isNotEmpty) {
          await PrefService.saveUserImage(imageUrl);
        }

        emit(LoginSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Login successful!',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );
          Navigator.pushReplacementNamed(context, CustomScreen.id);
        }
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getLoginErrorMessage(e);
      emit(LoginFailed(errorMessage));
      if (context.mounted) {
        appSnackbar(
          context,
          text: errorMessage,
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    } catch (e) {
      const errorMessage = 'An unexpected error occurred. Please try again.';
      emit(LoginFailed(errorMessage));
      if (context.mounted) {
        appSnackbar(
          context,
          text: errorMessage,
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    emit(GoogleLoginLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(GoogleLoginFailed('Google sign in cancelled'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        String imageUrl = user.photoURL ?? '';
        String phone = '';
        String city = '';
        String address = '';

        final doc = await _firestore.collection('users2').doc(user.uid).get();
        bool isProfileComplete = false;

        if (doc.exists) {
          phone = doc.data()?['phone'] ?? '';
          city = doc.data()?['city'] ?? '';
          address = doc.data()?['address'] ?? '';
          isProfileComplete =
              (doc.data()?['isProfileComplete'] as bool?) ?? false;
        }

        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: phone,
          city: city,
          address: address,
        );

        if (imageUrl.isNotEmpty) {
          await PrefService.saveUserImage(imageUrl);
        }

        if (!isProfileComplete ||
            phone.isEmpty ||
            city.isEmpty ||
            address.isEmpty) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CompleteUserDataScreen(
                  user: user,
                  isGoogleSignIn: true,
                ),
              ),
            );
          }
          return;
        }

        await _saveUserDataToFirestore(
          userId: user.uid,
          name: user.displayName ?? 'No Name',
          email: user.email ?? 'No Email',
          phone: phone,
          city: city,
          address: address,
          provider: 'google',
          isProfileComplete: true,
          imageUrl: imageUrl,
        );

        emit(GoogleLoginSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Google sign in successful!',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );
          Navigator.pushReplacementNamed(context, CustomScreen.id);
        }
      } else {
        emit(GoogleLoginFailed('User is null after sign in'));
      }
    } catch (e) {
      if (!context.mounted) return;
      appSnackbar(
        context,
        text: 'Sign in failed',
        backgroundColor: ColorsUtility.errorSnackbarColor,
      );
      log('google sign in failed: $e');
      emit(GoogleLoginFailed(e.toString()));
    }
  }

  Future<void> completeUserProfile({
    required User user,
    required String name,
    required String phone,
    required String city,
    required String address,
    required bool isGoogleSignIn,
    required BuildContext context,
  }) async {
    emit(ProfileUpdateLoading());
    try {
      if (user.displayName == null || user.displayName!.isEmpty) {
        await user.updateDisplayName(name);
      }

      String imageUrl = isGoogleSignIn ? (user.photoURL ?? '') : '';

      await _saveUserDataToFirestore(
        userId: user.uid,
        name: name,
        email: user.email ?? 'No Email',
        phone: phone,
        city: city,
        address: address,
        provider: isGoogleSignIn ? 'google' : 'email',
        isProfileComplete: true,
        imageUrl: imageUrl,
      );

      await PrefService.saveUserData(
        userId: user.uid,
        name: name,
        email: user.email ?? 'No Email',
        phone: phone,
        city: city,
        address: address,
      );
      if (imageUrl.isNotEmpty) {
        await PrefService.saveUserImage(imageUrl);
      }

      emit(ProfileUpdateSuccess());
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Profile completed successfully!',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
        Navigator.pushReplacementNamed(context, CustomScreen.id);
      }
    } catch (e) {
      emit(ProfileUpdateFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Error: ${e.toString()}',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Future<void> updateUserProfile({
    required String name,
    required String phone,
    required String city,
    required String address,
    required File? imageFile,
    required Uint8List? webImageBytes,
    required BuildContext context,
  }) async {
    emit(ProfileUpdateLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      String imageUrl = PrefService.userData['userImage'] ?? '';

      if (imageFile != null || webImageBytes != null) {
        try {
          log('Starting image upload...');
          final storageRef =
              _storage.ref().child('user_images').child('${user.uid}.jpg');
          log('Storage reference created: ${storageRef.fullPath}');

          if (webImageBytes != null) {
            await storageRef.putData(webImageBytes);
            log('Web image bytes uploaded successfully');
          } else if (imageFile != null) {
            await storageRef.putFile(imageFile);
            log('Image file uploaded successfully');
          }

          imageUrl = await storageRef.getDownloadURL();
          log('Download URL obtained: $imageUrl');
        } catch (e) {
          log('Error uploading image: $e');
          throw Exception('Failed to upload profile image');
        }
      }

      await user.updateDisplayName(name);

      await _saveUserDataToFirestore(
        userId: user.uid,
        name: name,
        email: user.email ?? 'No Email',
        phone: phone,
        city: city,
        address: address,
        provider:
            user.providerData.any((info) => info.providerId == 'google.com')
                ? 'google'
                : 'email',
        isProfileComplete: true,
        imageUrl: imageUrl,
      );

      await PrefService.saveUserData(
        userId: user.uid,
        name: name,
        email: user.email ?? 'No Email',
        phone: phone,
        city: city,
        address: address,
      );

      if (imageUrl.isNotEmpty) {
        await PrefService.saveUserImage(imageUrl);
      }

      emit(ProfileUpdateSuccess());
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Profile updated successfully!',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
      }
    } catch (e) {
      log('Error in updateUserProfile: $e');
      emit(ProfileUpdateFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Error updating profile: ${e.toString()}',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Future<void> _saveUserDataToFirestore({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String city,
    required String address,
    required String provider,
    required bool isProfileComplete,
    required String imageUrl,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
      'city': city,
      'address': address,
      'provider': provider,
      'isProfileComplete': isProfileComplete,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (imageUrl.isNotEmpty) {
      data['imageUrl'] = imageUrl;
    }

    await _firestore.collection('users2').doc(userId).set(
          data,
          SetOptions(merge: true),
        );
  }

  Future<Map<String, dynamic>?> _findUserByPhoneNumber(
      String phoneNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('users2')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'phone-already-in-use':
        return 'Phone number already registered.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  String _getLoginErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with these credentials.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(LogoutLoading());
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await PrefService.clearUserData();
      emit(LogoutSuccess());
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Logout successful!',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      }
    } catch (e) {
      emit(LogoutFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Logout failed',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    emit(ResetPasswordLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(ResetPasswordSuccess());
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Password reset email sent. Check your inbox.',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getResetPasswordErrorMessage(e);
      emit(ResetPasswordFailed(errorMessage));
      if (context.mounted) {
        appSnackbar(
          context,
          text: errorMessage,
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    } catch (e) {
      const errorMessage = 'An unexpected error occurred. Please try again.';
      emit(ResetPasswordFailed(errorMessage));
      if (context.mounted) {
        appSnackbar(
          context,
          text: errorMessage,
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  String _getResetPasswordErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'Password reset failed. Please try again.';
    }
  }

  Future<void> reAuthenticateUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getReAuthErrorMessage(e);
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('An unexpected error occurred during re-authentication.');
    }
  }

  String _getReAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-mismatch':
        return 'The provided credentials do not match the current user.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return 'Re-authentication failed. Please try again.';
    }
  }

  Future<void> deleteAccount(
    BuildContext context, {
    String? email,
    String? password,
  }) async {
    emit(DeleteAccountLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      if (email != null && password != null) {
        await reAuthenticateUser(
          email: email,
          password: password,
          context: context,
        );
      } else {
        throw Exception('Re-authentication credentials are required');
      }

      await _firestore.collection('users2').doc(user.uid).delete();
      await user.delete();
      await PrefService.clearUserData();
      emit(DeleteAccountSuccess());
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Account deleted successfully!',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.id,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      emit(DeleteAccountFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Error deleting account: ${e.toString()}',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
      rethrow;
    }
  }

  Future<void> changeLanguage(Locale newLocale, BuildContext context) async {
    emit(LanguageChanged(newLocale));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', newLocale.languageCode);

      if (context.mounted) {
        appSnackbar(
          context,
          text: newLocale.languageCode == 'ar'
              ? 'تم تغيير اللغة إلى العربية'
              : 'Language changed to English',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
      }
    } catch (e) {
      emit(LanguageChangeFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Failed to change language',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    return Locale(languageCode);
  }
}
