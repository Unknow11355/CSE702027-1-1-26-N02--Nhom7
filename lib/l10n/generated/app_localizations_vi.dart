// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Thư viện';

  @override
  String get welcomeTitle => 'Chào mừng đến thư viện';

  @override
  String get welcomeDescription =>
      'Tra cứu, đặt mượn và theo dõi việc mượn trả sách.';

  @override
  String get changeLanguage => 'Chuyển ngôn ngữ';
}
