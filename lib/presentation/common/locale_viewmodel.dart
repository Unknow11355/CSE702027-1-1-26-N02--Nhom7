import 'package:flutter/widgets.dart';

class LocaleViewModel extends ChangeNotifier {
  Locale _locale = const Locale('vi');

  Locale get locale => _locale;

  void toggleLanguage() {
    _locale = Locale(
      _locale.languageCode == 'vi' ? 'en' : 'vi',
    );

    notifyListeners();
  }
}
