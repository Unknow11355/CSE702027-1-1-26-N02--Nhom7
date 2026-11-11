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
  String get appBrandUpper => 'LIBRARY';

  @override
  String get welcomeHeadline => 'Your next book\nis waiting for you.';

  @override
  String get welcomeSubtitle =>
      'Search and reserve on the app.\nPick up and return books at the library.';

  @override
  String get backTooltip => 'Back';

  @override
  String get togglePasswordTooltip => 'Show/hide password';

  @override
  String get toggleConfirmPasswordTooltip => 'Show/hide confirm password';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginButton => 'Sign in';

  @override
  String get createReaderAccountButton => 'Create reader account';

  @override
  String get welcomeBackTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to reserve and track your books.';

  @override
  String get usernameLabel => 'Username';

  @override
  String get usernameHint => 'Enter username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get retryButton => 'Try again';

  @override
  String get noAccountRegisterPrompt => 'Don\'t have an account? Register';

  @override
  String get createAccountShortButton => 'Create account';

  @override
  String get loginErrorTitle => 'Unable to sign in';

  @override
  String get loginErrorMessage => 'Incorrect username or password.';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerHeadline => 'Start borrowing books';

  @override
  String get registerSubtitle => 'New accounts are for readers.';

  @override
  String get registerErrorBannerTitle => 'Check your information';

  @override
  String get registerErrorBannerMessage => 'Fix the highlighted fields below.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Enter full name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Confirm password';

  @override
  String get registerButton => 'Register';

  @override
  String get alreadyHaveAccountLoginPrompt =>
      'Already have an account? Sign in';

  @override
  String get errorRequiredField => 'Please enter this field.';

  @override
  String get errorPasswordTooShort => 'Password must be at least 6 characters.';

  @override
  String get errorUsernameExists =>
      'Username already exists. Choose another one.';

  @override
  String get errorPasswordMismatch => 'Passwords do not match.';

  @override
  String get registerSuccessMessage =>
      'Reader account created. Please sign in.';

  @override
  String get logoutButton => 'Sign out';
}
