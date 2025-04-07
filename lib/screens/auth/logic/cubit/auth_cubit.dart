import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:restrant_app/screens/auth/complete_user_data.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/home_screen.dart';
import 'package:restrant_app/services/pref_service.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // =================================================================================
  // sign up
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
          .collection('users')
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
          provider: 'email',
          isProfileComplete: true,
        );

        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: userCredential.user!.uid,
          name: name,
          email: email,
          phone: phone,
        );

        emit(SignupSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Registration successful!',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );
          Navigator.pushReplacementNamed(context, HomeScreen.id);
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

  // =================================================================================
  // login
  Future<void> login({
    required String emailOrPhone,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    try {
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
        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          email: userCredential.user!.email ?? '',
          phone: await _getUserPhone(userCredential.user!.uid),
        );
        emit(LoginSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Login successful!',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );
          Navigator.pushReplacementNamed(context, HomeScreen.id);
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

  // =================================================================================
  // google sign in
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
        await PrefService.setLoggedIn(true);
        await PrefService.saveUserData(
          userId: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: await _getUserPhone(user.uid),
        );
        final userDoc =
            await _firestore.collection('users2').doc(user.uid).get();
        final bool isProfileComplete = userDoc.exists
            ? (userDoc.data()?['isProfileComplete'] as bool?) ?? false
            : false;

        if (isProfileComplete == false) {
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
        } else {
          await _saveUserDataToFirestore(
            userId: user.uid,
            name: user.displayName ?? 'No Name',
            email: user.email ?? 'No Email',
            phone: '',
            provider: 'google',
            isProfileComplete: true,
          );

          emit(GoogleLoginSuccess());
          if (context.mounted) {
            appSnackbar(
              context,
              text: 'Google sign in successful!',
              backgroundColor: ColorsUtility.successSnackbarColor,
            );
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          }
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

  // =================================================================================
  // complete user prof
  Future<void> completeUserProfile({
    required User user,
    required String name,
    required String phone,
    required bool isGoogleSignIn,
    required BuildContext context,
  }) async {
    emit(ProfileUpdateLoading());
    try {
      if (user.displayName == null || user.displayName!.isEmpty) {
        await user.updateDisplayName(name);
      }

      await _saveUserDataToFirestore(
        userId: user.uid,
        name: name,
        email: user.email ?? 'No Email',
        phone: phone,
        provider: isGoogleSignIn ? 'google' : 'email',
        isProfileComplete: true,
      );

      emit(ProfileUpdateSuccess());
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Profile completed successfully!',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
        Navigator.pushReplacementNamed(context, HomeScreen.id);
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

  // =================================================================================
  // sve user data to firestore
  Future<void> _saveUserDataToFirestore({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String provider,
    required bool isProfileComplete,
  }) async {
    await _firestore.collection('users2').doc(userId).set({
      'name': name,
      'email': email,
      'phone': phone,
      'provider': provider,
      'isProfileComplete': isProfileComplete,
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // ========================================================================================
  // user phone
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

  // errors
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

  // =================================================================================
  // sign out
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

  // =================================================================================
  // reset password
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

  // =================================================================================
  // delete account
  Future<void> deleteAccount(BuildContext context) async {
    emit(DeleteAccountLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users2').doc(user.uid).delete();
        await user.delete();
        emit(DeleteAccountSuccess());
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Account deleted successfully!',
            backgroundColor: ColorsUtility.successSnackbarColor,
          );
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(DeleteAccountFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Error deleting account: ${e.message}',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    } catch (e) {
      emit(DeleteAccountFailed(e.toString()));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Error deleting account: $e',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  // ====================================================================================
  // fetch user phone for shared pref
  Future<String> _getUserPhone(String userId) async {
    try {
      final doc = await _firestore.collection('users2').doc(userId).get();
      return doc.data()?['phone'] ?? '';
    } catch (e) {
      log('Error getting user phone: $e');
      return '';
    }
  }
}
