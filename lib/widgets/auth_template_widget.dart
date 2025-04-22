import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restrant_app/cubit/AuthLogic/cubit/auth_cubit.dart';
import 'package:restrant_app/generated/l10n.dart';
import 'package:restrant_app/screens/auth/login_screen.dart';
import 'package:restrant_app/screens/auth/sign_up_screen.dart';
import 'package:restrant_app/utils/colors_utility.dart';
import 'package:restrant_app/utils/icons_utility.dart';
import 'package:restrant_app/widgets/app_elevated_btn_widget.dart';

class AuthTemplateWidget extends StatefulWidget {
  const AuthTemplateWidget({
    super.key,
    this.onLogin,
    this.onSignUp,
    required this.body,
    this.isLoading = false,
  }) : assert(
          onLogin != null || onSignUp != null,
          'Either onLogin or onSignUp should be provided',
        );

  final Future<void> Function()? onLogin;
  final Future<void> Function()? onSignUp;
  final Widget body;
  final bool isLoading;

  @override
  State<AuthTemplateWidget> createState() => _AuthTemplateWidgetState();
}

class _AuthTemplateWidgetState extends State<AuthTemplateWidget> {
  bool get isLogin => widget.onLogin != null;

  String get title =>
      isLogin ? S.of(context).welcome : S.of(context).createAccount;

  String get subTitle =>
      isLogin ? S.of(context).pleaseLogin : S.of(context).fillForm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isLogin ? 100 : 50),
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
                  SizedBox(height: isLogin ? 100 : 50),
                  widget.body,
                  SizedBox(height: isLogin ? 150 : 40),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: AppElevatedBtn(
                      text:
                          isLogin ? S.of(context).LOGIN : S.of(context).SIGIUP,
                      onPressed: widget.isLoading
                          ? null
                          : () {
                              if (isLogin) {
                                widget.onLogin?.call();
                              } else {
                                widget.onSignUp?.call();
                              }
                            },
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorsUtility.progressIndictorColor),
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: isLogin ? 30 : 20),
                  TextButton(
                    onPressed: widget.isLoading
                        ? null
                        : () async {
                            await context
                                .read<AuthCubit>()
                                .signInWithGoogle(context);
                          },
                    child: BlocSelector<AuthCubit, AuthState, bool>(
                      selector: (state) => state is GoogleLoginLoading,
                      builder: (context, isLoading) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorsUtility.progressIndictorColor,
                                  ),
                                ),
                              )
                            else ...[
                              SvgPicture.asset(
                                IconsUtility.googleIcon,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isLogin
                                    ? S.of(context).loginGoogle
                                    : S.of(context).sigUpGoogle,
                                style: const TextStyle(
                                  color: ColorsUtility.onboardingColor,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? S.of(context).donotHaveAccount
                            : S.of(context).alreadyHaveAccount,
                        style: const TextStyle(
                          color: ColorsUtility.onboardingColor,
                        ),
                      ),
                      if (!widget.isLoading)
                        InkWell(
                          onTap: () {
                            if (isLogin) {
                              Navigator.pushReplacementNamed(
                                  context, SignUpScreen.id);
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.id);
                            }
                          },
                          child: Text(
                            isLogin ? S.of(context).sigUp : S.of(context).login,
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
        ],
      ),
    );
  }
}
