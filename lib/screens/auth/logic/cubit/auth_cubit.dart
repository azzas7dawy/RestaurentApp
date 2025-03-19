import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:restrant_app/screens/auth/verify_otp_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId; 

  String? get verificationId => _verificationId;

  Future<void> signUp({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController phoneController,
    required TextEditingController passwordController,
    required BuildContext context,
    required bool isPhone,
  }) async {
    emit(SignupLoading()); 

    try {
      
      if (isPhone && phoneController.text.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: '+1${phoneController.text}', 
          verificationCompleted: (PhoneAuthCredential credential) async {
            
            await _auth.signInWithCredential(credential);
            emit(SignupSuccess());
          },
          verificationFailed: (FirebaseAuthException e) {
            emit(SignupFailed('Verification failed: ${e.message}'));
            if (context.mounted) {
              appSnackbar(
                context,
                text: 'Verification failed: ${e.message}',
                backgroundColor: ColorsUtility.errorSnackbarColor,
              );
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            _verificationId = verificationId; 
            emit(SignupSuccess());
            if (context.mounted) {
              Navigator.pushNamed(
                context,
                VerifyOtpScreen.id,
                arguments: verificationId, 
              );
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      } else {
        emit(SignupFailed('Please enter a valid phone number'));
        if (context.mounted) {
          appSnackbar(
            context,
            text: 'Please enter a valid phone number',
            backgroundColor: ColorsUtility.errorSnackbarColor,
          );
        }
      }
    } catch (e) {
      emit(SignupFailed('Sign up exception: $e'));
      if (context.mounted) {
        appSnackbar(
          context,
          text: 'Sign up exception: $e',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }
}