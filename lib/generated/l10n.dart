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

  /// `Save`
  String get saveButton {
    return Intl.message('Save', name: 'saveButton', desc: '', args: []);
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
  String get sigUpGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'sigUpGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get donotHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'donotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get sigUp {
    return Intl.message('Sign up', name: 'sigUp', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `SIGN UP`
  String get SIGIUP {
    return Intl.message('SIGN UP', name: 'SIGIUP', desc: '', args: []);
  }

  /// `LOGIN`
  String get LOGIN {
    return Intl.message('LOGIN', name: 'LOGIN', desc: '', args: []);
  }

  /// `Either onLogin or onSignUp should be provided`
  String get eitherSigUPOrLogin {
    return Intl.message(
      'Either onLogin or onSignUp should be provided',
      name: 'eitherSigUPOrLogin',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get CancelButton {
    return Intl.message('Cancel', name: 'CancelButton', desc: '', args: []);
  }

  /// `Table Reservation`
  String get reserveationTable {
    return Intl.message(
      'Table Reservation',
      name: 'reserveationTable',
      desc: '',
      args: [],
    );
  }

  /// `Select a table`
  String get selectTable {
    return Intl.message(
      'Select a table',
      name: 'selectTable',
      desc: '',
      args: [],
    );
  }

  /// `Reserve Table`
  String get reserveTable {
    return Intl.message(
      'Reserve Table',
      name: 'reserveTable',
      desc: '',
      args: [],
    );
  }

  /// `Reserve a table at Paragon right now`
  String get reserNow {
    return Intl.message(
      'Reserve a table at Paragon right now',
      name: 'reserNow',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get successReser {
    return Intl.message('Success', name: 'successReser', desc: '', args: []);
  }

  /// `Your table is reserved`
  String get tableReserved {
    return Intl.message(
      'Your table is reserved',
      name: 'tableReserved',
      desc: '',
      args: [],
    );
  }

  /// `NOTE: Reservation is only for 1 hour`
  String get tableReservedMessage {
    return Intl.message(
      'NOTE: Reservation is only for 1 hour',
      name: 'tableReservedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please fill out all fields.`
  String get fillAllFields {
    return Intl.message(
      'Please fill out all fields.',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Reservation successful!`
  String get successMessage {
    return Intl.message(
      'Reservation successful!',
      name: 'successMessage',
      desc: '',
      args: [],
    );
  }

  /// `Reservation Form`
  String get revervationForm {
    return Intl.message(
      'Reservation Form',
      name: 'revervationForm',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get setectData {
    return Intl.message('Select Date', name: 'setectData', desc: '', args: []);
  }

  /// `Select Time`
  String get selectTime {
    return Intl.message('Select Time', name: 'selectTime', desc: '', args: []);
  }

  /// `Persons`
  String get selectNumberOfPeople {
    return Intl.message(
      'Persons',
      name: 'selectNumberOfPeople',
      desc: '',
      args: [],
    );
  }

  /// `Reserve`
  String get reserve {
    return Intl.message('Reserve', name: 'reserve', desc: '', args: []);
  }

  /// `Calicut`
  String get cityOne {
    return Intl.message('Calicut', name: 'cityOne', desc: '', args: []);
  }

  /// `Kochi`
  String get cityTwo {
    return Intl.message('Kochi', name: 'cityTwo', desc: '', args: []);
  }

  /// `Thiruvananthapuram`
  String get cityThree {
    return Intl.message(
      'Thiruvananthapuram',
      name: 'cityThree',
      desc: '',
      args: [],
    );
  }

  /// `Paragon Restaurant`
  String get cNameOne {
    return Intl.message(
      'Paragon Restaurant',
      name: 'cNameOne',
      desc: '',
      args: [],
    );
  }

  /// `M Grill - Paragon Group`
  String get cNameTwo {
    return Intl.message(
      'M Grill - Paragon Group',
      name: 'cNameTwo',
      desc: '',
      args: [],
    );
  }

  /// `Brown Town - Paragon Group`
  String get cNameThree {
    return Intl.message(
      'Brown Town - Paragon Group',
      name: 'cNameThree',
      desc: '',
      args: [],
    );
  }

  /// `Kannur road, Near CH over bridge`
  String get cAddressOne {
    return Intl.message(
      'Kannur road, Near CH over bridge',
      name: 'cAddressOne',
      desc: '',
      args: [],
    );
  }

  /// `M Grill - Paragon Group, Kochi`
  String get cAddressTwo {
    return Intl.message(
      'M Grill - Paragon Group, Kochi',
      name: 'cAddressTwo',
      desc: '',
      args: [],
    );
  }

  /// `Brown Town - Paragon Group, Thiruvananthapuram`
  String get cAddressThree {
    return Intl.message(
      'Brown Town - Paragon Group, Thiruvananthapuram',
      name: 'cAddressThree',
      desc: '',
      args: [],
    );
  }

  /// `Select your city`
  String get setectCity {
    return Intl.message(
      'Select your city',
      name: 'setectCity',
      desc: '',
      args: [],
    );
  }

  /// `Select the restaurant`
  String get setectRestaurant {
    return Intl.message(
      'Select the restaurant',
      name: 'setectRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get nextButton {
    return Intl.message('NEXT', name: 'nextButton', desc: '', args: []);
  }

  /// ` Select a Table`
  String get selectYourTable {
    return Intl.message(
      ' Select a Table',
      name: 'selectYourTable',
      desc: '',
      args: [],
    );
  }

  /// `seats`
  String get selectseats {
    return Intl.message('seats', name: 'selectseats', desc: '', args: []);
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
