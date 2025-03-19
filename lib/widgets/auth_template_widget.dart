import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/auth/sign_up_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/icons_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';

class AuthTemplateWidget extends StatefulWidget {
  AuthTemplateWidget({
    super.key,
    this.onLogin,
    this.onSignUp,
    required this.body,
  }) {
    assert(
      onLogin != null || onSignUp != null,
      'onLogin or onSignUp should not be null',
    );
  }
  final Future<void> Function()? onLogin;
  final Future<void> Function()? onSignUp;
  final Widget body;

  @override
  State<AuthTemplateWidget> createState() => _AuthTemplateWidgetState();
}

class _AuthTemplateWidgetState extends State<AuthTemplateWidget> {
  bool get isLogin => widget.onLogin != null;

  String get title => isLogin ? 'Welcome Back!' : 'Create a new account';
  String get subTitle => isLogin
      ? 'Please login to your account'
      : 'Please fill in the form to continue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: isLogin? 100 : 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    color: ColorsUtility.onboardingColor,
                  ),
                ),
              ),
              Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: ColorsUtility.textFieldLabelColor,
                ),
              ),
              SizedBox(
                height: isLogin? 100 : 50,
              ),
              widget.body,
              SizedBox(
                height: isLogin? 150 : 40,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: AppElevatedBtn(
                  text: isLogin ? 'LOGIN' : 'SIGN UP',
                  onPressed: () {
                    if (isLogin) {
                      widget.onLogin?.call();
                    } else {
                      widget.onSignUp?.call();
                    }
                  },
                ),
              ),
              SizedBox(
                height: isLogin? 30 : 20,
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconsUtility.googleIcon,
                      width: 30,
                      height: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      isLogin ? 'Login with Google' : 'Sign in with Google',
                      style: const TextStyle(
                        color: ColorsUtility.onboardingColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? 'Don\'t have an account? '
                        : 'Already have an account? ',
                    style: const TextStyle(
                      color: ColorsUtility.onboardingColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (isLogin) {
                        Navigator.pushReplacementNamed(context, SignUpScreen.id);
                      } else {
                        Navigator.pushReplacementNamed(context, LoginScreen.id);
                      }
                    },
                    child: Text(
                      isLogin ? 'Sign Up' : 'Login',
                      style: const TextStyle(
                        color: ColorsUtility.inkwellTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
