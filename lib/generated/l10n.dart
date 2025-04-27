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

  /// `TastyBites`
  String get splashTitle {
    return Intl.message('TastyBites', name: 'splashTitle', desc: '', args: []);
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

  /// `You can order weekly meals, and well bring them straight to your door.`
  String get onboardingDescriptionOne {
    return Intl.message(
      'You can order weekly meals, and well bring them straight to your door.',
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

  /// `More Options`
  String get moreOptions {
    return Intl.message(
      'More Options',
      name: 'moreOptions',
      desc: '',
      args: [],
    );
  }

  /// `Your Orders`
  String get yourOrders {
    return Intl.message('Your Orders', name: 'yourOrders', desc: '', args: []);
  }

  /// `Your Favorites`
  String get yourFavorites {
    return Intl.message(
      'Your Favorites',
      name: 'yourFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Track your orders`
  String get trackYourOrders {
    return Intl.message(
      'Track your orders',
      name: 'trackYourOrders',
      desc: '',
      args: [],
    );
  }

  /// `About / Help`
  String get aboutHelp {
    return Intl.message('About / Help', name: 'aboutHelp', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Menu`
  String get menu {
    return Intl.message('Menu', name: 'menu', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Delicious Desserts Just for You! Indulge in the Sweetest Treats.`
  String get sliderOne {
    return Intl.message(
      'Delicious Desserts Just for You! Indulge in the Sweetest Treats.',
      name: 'sliderOne',
      desc: '',
      args: [],
    );
  }

  /// `Freshly Baked Pizzas with Perfect Toppings! Taste the Flavor in Every Bite.`
  String get sliderTwo {
    return Intl.message(
      'Freshly Baked Pizzas with Perfect Toppings! Taste the Flavor in Every Bite.',
      name: 'sliderTwo',
      desc: '',
      args: [],
    );
  }

  /// `Juicy Burgers with a Perfect Blend of Flavors! Savor Every Bite.`
  String get sliderThree {
    return Intl.message(
      'Juicy Burgers with a Perfect Blend of Flavors! Savor Every Bite.',
      name: 'sliderThree',
      desc: '',
      args: [],
    );
  }

  /// `Spicy and Savory Mexican Delights! Taste the Fiesta in Every Bite.`
  String get sliderFour {
    return Intl.message(
      'Spicy and Savory Mexican Delights! Taste the Fiesta in Every Bite.',
      name: 'sliderFour',
      desc: '',
      args: [],
    );
  }

  /// `Book Your Table Now`
  String get reserveCardTitle {
    return Intl.message(
      'Book Your Table Now',
      name: 'reserveCardTitle',
      desc: '',
      args: [],
    );
  }

  /// `REnjoy your visit without waiting. Reserve from home!`
  String get reserveCardDescription {
    return Intl.message(
      'REnjoy your visit without waiting. Reserve from home!',
      name: 'reserveCardDescription',
      desc: '',
      args: [],
    );
  }

  /// `Special Plates`
  String get specialPlates {
    return Intl.message(
      'Special Plates',
      name: 'specialPlates',
      desc: '',
      args: [],
    );
  }

  /// `Hi`
  String get hi {
    return Intl.message('Hi', name: 'hi', desc: '', args: []);
  }

  /// `Ready to order?`
  String get readyToOrder {
    return Intl.message(
      'Ready to order?',
      name: 'readyToOrder',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `No special plates found`
  String get noSpecialPlates {
    return Intl.message(
      'No special plates found',
      name: 'noSpecialPlates',
      desc: '',
      args: [],
    );
  }

  /// `See More`
  String get seeMore {
    return Intl.message('See More', name: 'seeMore', desc: '', args: []);
  }

  /// `EGP`
  String get egp {
    return Intl.message('EGP', name: 'egp', desc: '', args: []);
  }

  /// `Added to favorites`
  String get addedToFavorites {
    return Intl.message(
      'Added to favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `removed from favorites`
  String get removedFromFavorites {
    return Intl.message(
      'removed from favorites',
      name: 'removedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `added to orders`
  String get addedToOrders {
    return Intl.message(
      'added to orders',
      name: 'addedToOrders',
      desc: '',
      args: [],
    );
  }

  /// `removed from orders`
  String get removedFromOrders {
    return Intl.message(
      'removed from orders',
      name: 'removedFromOrders',
      desc: '',
      args: [],
    );
  }

  /// `is not available for now`
  String get notAvailable {
    return Intl.message(
      'is not available for now',
      name: 'notAvailable',
      desc: '',
      args: [],
    );
  }

  /// `All Special Plates`
  String get allSpecialPlates {
    return Intl.message(
      'All Special Plates',
      name: 'allSpecialPlates',
      desc: '',
      args: [],
    );
  }

  /// `Rating: `
  String get rating {
    return Intl.message('Rating: ', name: 'rating', desc: '', args: []);
  }

  /// `You rated this meal`
  String get youRatedThisMeal {
    return Intl.message(
      'You rated this meal',
      name: 'youRatedThisMeal',
      desc: '',
      args: [],
    );
  }

  /// `You rated:`
  String get youRated {
    return Intl.message('You rated:', name: 'youRated', desc: '', args: []);
  }

  /// `Available`
  String get available {
    return Intl.message('Available', name: 'available', desc: '', args: []);
  }

  /// `Not Available`
  String get notAvailableTxt {
    return Intl.message(
      'Not Available',
      name: 'notAvailableTxt',
      desc: '',
      args: [],
    );
  }

  /// `Add to Orders`
  String get addToOrdersBtn {
    return Intl.message(
      'Add to Orders',
      name: 'addToOrdersBtn',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Order submitted successfully`
  String get orderSubmit {
    return Intl.message(
      'Order submitted successfully',
      name: 'orderSubmit',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet`
  String get noOrders {
    return Intl.message('No orders yet', name: 'noOrders', desc: '', args: []);
  }

  /// `No meals added here`
  String get noMealsAdded {
    return Intl.message(
      'No meals added here',
      name: 'noMealsAdded',
      desc: '',
      args: [],
    );
  }

  /// `Total Price:`
  String get totalPrice {
    return Intl.message('Total Price:', name: 'totalPrice', desc: '', args: []);
  }

  /// `Proceed to Payment`
  String get payBtn {
    return Intl.message(
      'Proceed to Payment',
      name: 'payBtn',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Removal`
  String get confirmRemoval {
    return Intl.message(
      'Confirm Removal',
      name: 'confirmRemoval',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this meal?`
  String get removeMeal {
    return Intl.message(
      'Are you sure you want to remove this meal?',
      name: 'removeMeal',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `No favorites yet`
  String get noFav {
    return Intl.message('No favorites yet', name: 'noFav', desc: '', args: []);
  }

  /// `Tap the heart icon to add favorites`
  String get favTxt {
    return Intl.message(
      'Tap the heart icon to add favorites',
      name: 'favTxt',
      desc: '',
      args: [],
    );
  }

  /// `Cash on Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash on Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `PayPal Checkout`
  String get paypal {
    return Intl.message('PayPal Checkout', name: 'paypal', desc: '', args: []);
  }

  /// `You will pay`
  String get txtp1 {
    return Intl.message('You will pay', name: 'txtp1', desc: '', args: []);
  }

  /// `when you receive your order`
  String get txtp2 {
    return Intl.message(
      'when you receive your order',
      name: 'txtp2',
      desc: '',
      args: [],
    );
  }

  /// `Our delivery agent will collect the payment when your order arrives`
  String get subTitle {
    return Intl.message(
      'Our delivery agent will collect the payment when your order arrives',
      name: 'subTitle',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneLabel {
    return Intl.message('Phone Number', name: 'phoneLabel', desc: '', args: []);
  }

  /// `Delivery Address`
  String get deliveryAddress {
    return Intl.message(
      'Delivery Address',
      name: 'deliveryAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your delivery address`
  String get enterAddress {
    return Intl.message(
      'Please enter your delivery address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address is too short`
  String get shortAddress {
    return Intl.message(
      'Address is too short',
      name: 'shortAddress',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Order`
  String get confirmOrder {
    return Intl.message(
      'Confirm Order',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount:`
  String get totalAmount {
    return Intl.message(
      'Total Amount:',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `You will be redirected to PayPal to complete your payment securely`
  String get paypalTitle {
    return Intl.message(
      'You will be redirected to PayPal to complete your payment securely',
      name: 'paypalTitle',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to PayPal`
  String get paypalBtn {
    return Intl.message(
      'Proceed to PayPal',
      name: 'paypalBtn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a coupon code`
  String get enterCoupon {
    return Intl.message(
      'Please enter a coupon code',
      name: 'enterCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Coupon applied successfully!`
  String get validCoupon {
    return Intl.message(
      'Coupon applied successfully!',
      name: 'validCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Invalid coupon code`
  String get invalidCoupon {
    return Intl.message(
      'Invalid coupon code',
      name: 'invalidCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Please choose a payment method`
  String get payMethod {
    return Intl.message(
      'Please choose a payment method',
      name: 'payMethod',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Select your preferred payment method`
  String get favPayMethod {
    return Intl.message(
      'Select your preferred payment method',
      name: 'favPayMethod',
      desc: '',
      args: [],
    );
  }

  /// `Pay when you receive your order`
  String get cashTxt {
    return Intl.message(
      'Pay when you receive your order',
      name: 'cashTxt',
      desc: '',
      args: [],
    );
  }

  /// `Paymob`
  String get paymobTxt {
    return Intl.message('Paymob', name: 'paymobTxt', desc: '', args: []);
  }

  /// `Pay securely with Paymob`
  String get paymobSubtitle {
    return Intl.message(
      'Pay securely with Paymob',
      name: 'paymobSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueBtn {
    return Intl.message('Continue', name: 'continueBtn', desc: '', args: []);
  }

  /// `Apply Coupon`
  String get applyCoupon {
    return Intl.message(
      'Apply Coupon',
      name: 'applyCoupon',
      desc: '',
      args: [],
    );
  }

  /// `Enter coupon code`
  String get enterCouponCode {
    return Intl.message(
      'Enter coupon code',
      name: 'enterCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Delivery Fee`
  String get fees {
    return Intl.message('Delivery Fee', name: 'fees', desc: '', args: []);
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Are you sure you want to log out?`
  String get confirmLogout {
    return Intl.message(
      'Are you sure you want to log out?',
      name: 'confirmLogout',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Complete your profile`
  String get completeProfile {
    return Intl.message(
      'Complete your profile',
      name: 'completeProfile',
      desc: '',
      args: [],
    );
  }

  /// `Pay with Card`
  String get payWithCard {
    return Intl.message(
      'Pay with Card',
      name: 'payWithCard',
      desc: '',
      args: [],
    );
  }

  /// `Payment failed`
  String get paymentFailed {
    return Intl.message(
      'Payment failed',
      name: 'paymentFailed',
      desc: '',
      args: [],
    );
  }

  /// `Proceed with Paymob`
  String get proceedWithPaymob {
    return Intl.message(
      'Proceed with Paymob',
      name: 'proceedWithPaymob',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet`
  String get noOrdersYet {
    return Intl.message(
      'No orders yet',
      name: 'noOrdersYet',
      desc: '',
      args: [],
    );
  }

  /// `Your orders will appear here`
  String get yourOrdersWillAppearHere {
    return Intl.message(
      'Your orders will appear here',
      name: 'yourOrdersWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message('Pending', name: 'pending', desc: '', args: []);
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Total: `
  String get total2 {
    return Intl.message('Total: ', name: 'total2', desc: '', args: []);
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this order?`
  String get cancelOrderMessage {
    return Intl.message(
      'Are you sure you want to cancel this order?',
      name: 'cancelOrderMessage',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Order has been cancelled and deleted`
  String get orderCancelled {
    return Intl.message(
      'Order has been cancelled and deleted',
      name: 'orderCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel order:`
  String get orderCancelFailed {
    return Intl.message(
      'Failed to cancel order:',
      name: 'orderCancelFailed',
      desc: '',
      args: [],
    );
  }

  /// `cancelled`
  String get cancelled {
    return Intl.message('cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `failed`
  String get failed {
    return Intl.message('failed', name: 'failed', desc: '', args: []);
  }

  /// `Processing`
  String get processing {
    return Intl.message('Processing', name: 'processing', desc: '', args: []);
  }

  /// `On the way`
  String get onTheWay {
    return Intl.message('On the way', name: 'onTheWay', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Status:`
  String get status {
    return Intl.message('Status:', name: 'status', desc: '', args: []);
  }

  /// `Order ID:`
  String get orderId {
    return Intl.message('Order ID:', name: 'orderId', desc: '', args: []);
  }

  /// `Ordered on`
  String get orderedOn {
    return Intl.message('Ordered on', name: 'orderedOn', desc: '', args: []);
  }

  /// `Customer:`
  String get customer {
    return Intl.message('Customer:', name: 'customer', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Items:`
  String get items {
    return Intl.message('Items:', name: 'items', desc: '', args: []);
  }

  /// `No title`
  String get noTitle {
    return Intl.message('No title', name: 'noTitle', desc: '', args: []);
  }

  /// `Delivery Information:`
  String get deliveryInfo {
    return Intl.message(
      'Delivery Information:',
      name: 'deliveryInfo',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `item`
  String get item {
    return Intl.message('item', name: 'item', desc: '', args: []);
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Status`
  String get trackStatus {
    return Intl.message(
      'Delivery Status',
      name: 'trackStatus',
      desc: '',
      args: [],
    );
  }

  /// `Order Placed`
  String get orderPlaced {
    return Intl.message(
      'Order Placed',
      name: 'orderPlaced',
      desc: '',
      args: [],
    );
  }

  /// `Out for Delivery`
  String get outForDelivery {
    return Intl.message(
      'Out for Delivery',
      name: 'outForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `delete account `
  String get deletAccount {
    return Intl.message(
      'delete account ',
      name: 'deletAccount',
      desc: '',
      args: [],
    );
  }

  /// `Our Menu`
  String get ourMenu {
    return Intl.message('Our Menu', name: 'ourMenu', desc: '', args: []);
  }

  /// `No categories available`
  String get noCatAvailable {
    return Intl.message(
      'No categories available',
      name: 'noCatAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No items available in this category`
  String get noItemInCat {
    return Intl.message(
      'No items available in this category',
      name: 'noItemInCat',
      desc: '',
      args: [],
    );
  }

  /// `SPECIAL`
  String get special {
    return Intl.message('SPECIAL', name: 'special', desc: '', args: []);
  }

  /// `Search for meals by name`
  String get searchMeals {
    return Intl.message(
      'Search for meals by name',
      name: 'searchMeals',
      desc: '',
      args: [],
    );
  }

  /// `No meals found`
  String get noMealsFound {
    return Intl.message(
      'No meals found',
      name: 'noMealsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try different meal names`
  String get tryDifferentMealsName {
    return Intl.message(
      'Try different meal names',
      name: 'tryDifferentMealsName',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get items2 {
    return Intl.message('items', name: 'items2', desc: '', args: []);
  }

  /// `Beef Sandwich`
  String get beef {
    return Intl.message('Beef Sandwich', name: 'beef', desc: '', args: []);
  }

  /// `Chicken Sandwich`
  String get chicken {
    return Intl.message(
      'Chicken Sandwich',
      name: 'chicken',
      desc: '',
      args: [],
    );
  }

  /// `Dessert`
  String get dessert {
    return Intl.message('Dessert', name: 'dessert', desc: '', args: []);
  }

  /// `Drinks`
  String get drinks {
    return Intl.message('Drinks', name: 'drinks', desc: '', args: []);
  }

  /// `Soft Drinks`
  String get softDrinks {
    return Intl.message('Soft Drinks', name: 'softDrinks', desc: '', args: []);
  }

  /// `Mexican`
  String get mexican {
    return Intl.message('Mexican', name: 'mexican', desc: '', args: []);
  }

  /// `Pizza`
  String get pizza {
    return Intl.message('Pizza', name: 'pizza', desc: '', args: []);
  }

  /// `Sandwiches`
  String get sandwiches {
    return Intl.message('Sandwiches', name: 'sandwiches', desc: '', args: []);
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Your Reservation`
  String get YourReservationScreen {
    return Intl.message(
      'Your Reservation',
      name: 'YourReservationScreen',
      desc: '',
      args: [],
    );
  }

  /// `Your Reservations`
  String get yourReservation {
    return Intl.message(
      'Your Reservations',
      name: 'yourReservation',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWrong',
      desc: '',
      args: [],
    );
  }

  /// `No Reservations Found`
  String get noReservation {
    return Intl.message(
      'No Reservations Found',
      name: 'noReservation',
      desc: '',
      args: [],
    );
  }

  /// `Person`
  String get person {
    return Intl.message('Person', name: 'person', desc: '', args: []);
  }

  /// `Reservation Name`
  String get reservationName {
    return Intl.message(
      'Reservation Name',
      name: 'reservationName',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Cancel order`
  String get deleteReservation {
    return Intl.message(
      'Cancel order',
      name: 'deleteReservation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this order?`
  String get confirmDeleteReservation {
    return Intl.message(
      'Are you sure you want to cancel this order?',
      name: 'confirmDeleteReservation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get delete {
    return Intl.message('Cancel', name: 'delete', desc: '', args: []);
  }

  /// `Table No.`
  String get tableNumber {
    return Intl.message('Table No.', name: 'tableNumber', desc: '', args: []);
  }

  /// `No more plates`
  String get noMoreData {
    return Intl.message(
      'No more plates',
      name: 'noMoreData',
      desc: '',
      args: [],
    );
  }

  /// `Load More`
  String get loadMore {
    return Intl.message('Load More', name: 'loadMore', desc: '', args: []);
  }

  /// `No more orders`
  String get noMoreOrders {
    return Intl.message(
      'No more orders',
      name: 'noMoreOrders',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get confirmDeleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'confirmDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this account?`
  String get areYouSureDeleteAccount {
    return Intl.message(
      'Are you sure you want to delete this account?',
      name: 'areYouSureDeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Re-authenticate`
  String get reAuthenticate {
    return Intl.message(
      'Re-authenticate',
      name: 'reAuthenticate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your credentials to confirm account deletion.`
  String get pleaseReAuthenticate {
    return Intl.message(
      'Please enter your credentials to confirm account deletion.',
      name: 'pleaseReAuthenticate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get enterEmail {
    return Intl.message(
      'Please enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get enterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `This table is not available at this time`
  String get tableNotAvailable {
    return Intl.message(
      'This table is not available at this time',
      name: 'tableNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Reservation`
  String get cancelReservation {
    return Intl.message(
      'Cancel Reservation',
      name: 'cancelReservation',
      desc: '',
      args: [],
    );
  }

  /// `Reservation cancelled successfully`
  String get reservationCancelled {
    return Intl.message(
      'Reservation cancelled successfully',
      name: 'reservationCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel reservation`
  String get cancelFailed {
    return Intl.message(
      'Failed to cancel reservation',
      name: 'cancelFailed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Are you sure you want to cancel your reservation?`
  String get confirmCancelReservationQuestion {
    return Intl.message(
      'Are you sure you want to cancel your reservation?',
      name: 'confirmCancelReservationQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Your reservations will appear here`
  String get yourReservationsWillAppearHere {
    return Intl.message(
      'Your reservations will appear here',
      name: 'yourReservationsWillAppearHere',
      desc: '',
      args: [],
    );
  }

  /// `About Restaurant`
  String get aboutRestaurant {
    return Intl.message(
      'About Restaurant',
      name: 'aboutRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Tasty Bites Restaurant offers you the most delicious and tasty food with high quality and excellent service. We care about your comfort and experience, and we serve every meal with love ❤️`
  String get aboutRestaurantDescription {
    return Intl.message(
      'Tasty Bites Restaurant offers you the most delicious and tasty food with high quality and excellent service. We care about your comfort and experience, and we serve every meal with love ❤️',
      name: 'aboutRestaurantDescription',
      desc: '',
      args: [],
    );
  }

  /// `Ask Admin`
  String get askAdmin {
    return Intl.message('Ask Admin', name: 'askAdmin', desc: '', args: []);
  }

  /// `And give your feedback\n(you can ask the admin)`
  String get askAdminDescription {
    return Intl.message(
      'And give your feedback\n(you can ask the admin)',
      name: 'askAdminDescription',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Our location in Minya, Egypt`
  String get restaurantLocation {
    return Intl.message(
      'Our location in Minya, Egypt',
      name: 'restaurantLocation',
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
