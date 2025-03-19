import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restrant_app/screens/foodHomeScreen/food_home_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';
import 'package:restrant_app/widgets/app_snackbar.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.verificationId});
  final String? verificationId;
  static const String id = 'VerifyOtp';

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late List<TextEditingController> _otpControllers;
  String? verificationId;

  @override
  void initState() {
    _otpControllers = List.generate(6, (index) => TextEditingController());
    super.initState();
  }

  Future<void> verifyOtp() async {
    try {
      verificationId = widget.verificationId;
      if (verificationId == null) {
        if (mounted) {
          appSnackbar(
            context,
            text: 'Verification ID is missing',
            backgroundColor: ColorsUtility.errorSnackbarColor,
          );
        }
        return;
      }
      String otp = _otpControllers.map((controller) => controller.text).join();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, FoodHomeScreen.id);
        appSnackbar(
          context,
          text: 'Phone number verified successfully',
          backgroundColor: ColorsUtility.successSnackbarColor,
        );
      }
    } catch (e) {
      log('Verification failed: $e');
      if (mounted) {
        appSnackbar(
          context,
          text: 'Verification failed: Please check the OTP entered',
          backgroundColor: ColorsUtility.errorSnackbarColor,
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Verify OTP!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: ColorsUtility.onboardingColor,
                ),
              ),
              const Text(
                'Enter the OTP sent to your phone',
                style: TextStyle(
                  fontSize: 14,
                  color: ColorsUtility.textFieldLabelColor,
                ),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      style: const TextStyle(
                        color: ColorsUtility.textFieldLabelColor,
                      ),
                      controller: _otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () {
                    // TODO: logic
                  },
                  child: const Text(
                    "Resend OTP",
                    style: TextStyle(
                      color: ColorsUtility.onboardingColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              AppElevatedBtn(
                onPressed: verifyOtp,
                text: 'Verify OTP',
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}