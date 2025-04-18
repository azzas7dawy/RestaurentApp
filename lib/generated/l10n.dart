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
