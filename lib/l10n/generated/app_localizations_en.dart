// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Library';

  @override
  String get welcomeTitle => 'Welcome to the library';

  @override
  String get welcomeDescription =>
      'Browse books, reserve a copy, and track your loans.';

  @override
  String get changeLanguage => 'Change language';
}
