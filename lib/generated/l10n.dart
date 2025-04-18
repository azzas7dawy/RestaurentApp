// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `PARAGON`
  String get splashTitle {
    return Intl.message('PARAGON', name: 'splashTitle', desc: '', args: []);
  }

  /// `Skip`
  String get skipButton {
    return Intl.message('Skip', name: 'skipButton', desc: '', args: []);
  }

  /// `Continue`
  String get continueButton {
    return Intl.message('Continue', name: 'continueButton', desc: '', args: []);
  }

  /// `Plan your weekly menu`
  String get onboardingTitleOne {
    return Intl.message(
      'Plan your weekly menu',
      name: 'onboardingTitleOne',
      desc: '',
      args: [],
    );
  }

  /// `You can order weekly meals, and we'll bring them straight to your door.`
  String get onboardingDescriptionOne {
    return Intl.message(
      'You can order weekly meals, and we\'ll bring them straight to your door.',
      name: 'onboardingDescriptionOne',
      desc: '',
      args: [],
    );
  }

  /// `Reserve a table`
  String get onboardingTitleTwo {
    return Intl.message(
      'Reserve a table',
      name: 'onboardingTitleTwo',
      desc: '',
      args: [],
    );
  }

  /// `Tired of having to wait? Make a table reservation right away.`
  String get onboardingDescriptionTwo {
    return Intl.message(
      'Tired of having to wait? Make a table reservation right away.',
      name: 'onboardingDescriptionTwo',
      desc: '',
      args: [],
    );
  }

  /// `Place catering Orders`
  String get onboardingTitleThree {
    return Intl.message(
      'Place catering Orders',
      name: 'onboardingTitleThree',
      desc: '',
      args: [],
    );
  }

  /// `Place catering orders with us.`
  String get onboardingDescriptionThree {
    return Intl.message(
      'Place catering orders with us.',
      name: 'onboardingDescriptionThree',
      desc: '',
      args: [],
    );
  }

  /// `Email/Phone number`
  String get emailOrPhone {
    return Intl.message(
      'Email/Phone number',
      name: 'emailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get loginButton {
    return Intl.message('Login', name: 'loginButton', desc: '', args: []);
  }

  /// `Sign up`
  String get signupButton {
    return Intl.message('Sign up', name: 'signupButton', desc: '', args: []);
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email or phone number`
  String get validationErrorEmail {
    return Intl.message(
      'Please enter your email or phone number',
      name: 'validationErrorEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid password`
  String get validationErrorPassword {
    return Intl.message(
      'Please enter a valid password',
      name: 'validationErrorPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get validationErrorPasswordLength {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'validationErrorPasswordLength',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message('Full name', name: 'fullName', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Please enter a valid email address`
  String get validEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get validationErrorFullName {
    return Intl.message(
      'Please enter your full name',
      name: 'validationErrorFullName',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 3 characters long`
  String get threeLetterName {
    return Intl.message(
      'Name must be at least 3 characters long',
      name: 'threeLetterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid name (letters and spaces only)`
  String get validName {
    return Intl.message(
      'Please enter a valid name (letters and spaces only)',
      name: 'validName',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters long`
  String get nameLength {
    return Intl.message(
      'Name must be at least 2 characters long',
      name: 'nameLength',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first and last name`
  String get firstAndLastName {
    return Intl.message(
      'Please enter your first and last name',
      name: 'firstAndLastName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get enterPhone {
    return Intl.message(
      'Please enter your phone number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number (10-15 digits)`
  String get validPhone {
    return Intl.message(
      'Please enter a valid phone number (10-15 digits)',
      name: 'validPhone',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get matchPassword {
    return Intl.message(
      'Passwords do not match',
      name: 'matchPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must include both letters and numbers`
  String get enetrLetterNumberPassword {
    return Intl.message(
      'Password must include both letters and numbers',
      name: 'enetrLetterNumberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get welcome {
    return Intl.message('Welcome Back!', name: 'welcome', desc: '', args: []);
  }

  /// `Create a new account`
  String get createAccount {
    return Intl.message(
      'Create a new account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please login to your account`
  String get pleaseLogin {
    return Intl.message(
      'Please login to your account',
      name: 'pleaseLogin',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in the form to continue`
  String get fillForm {
    return Intl.message(
      'Please fill in the form to continue',
      name: 'fillForm',
      desc: '',
      args: [],
    );
  }

  /// `Login with Google`
  String get loginGoogle {
    return Intl.message(
      'Login with Google',
      name: 'loginGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get SignIBnGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'SignIBnGoogle',
      desc: '',
      args: [],
    );
  }

  /// ` Enter your email address to receive a password reset link`
  String get resetEmail {
    return Intl.message(
      ' Enter your email address to receive a password reset link',
      name: 'resetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendButton {
    return Intl.message(
      'Send Reset Link',
      name: 'sendButton',
      desc: '',
      args: [],
    );
  }

  /// `Please provide the following details: `
  String get completeDetails {
    return Intl.message(
      'Please provide the following details: ',
      name: 'completeDetails',
      desc: '',
      args: [],
    );
  }

  /// `Your table is reserved`
  String get successMessage {
    return Intl.message(
      'Your table is reserved',
      name: 'successMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reservation is only for 1 hour`
  String get note {
    return Intl.message(
      'Reservation is only for 1 hour',
      name: 'note',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
