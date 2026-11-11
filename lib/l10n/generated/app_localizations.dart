import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện'**
  String get appTitle;

  /// No description provided for @appBrandUpper.
  ///
  /// In vi, this message translates to:
  /// **'THƯ VIỆN'**
  String get appBrandUpper;

  /// No description provided for @welcomeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng đến thư viện'**
  String get welcomeTitle;

  /// No description provided for @welcomeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tra cứu, đặt mượn và theo dõi việc mượn trả sách.'**
  String get welcomeDescription;

  /// No description provided for @changeLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển ngôn ngữ'**
  String get changeLanguage;

  /// No description provided for @welcomeHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Cuốn sách tiếp theo\nđang chờ bạn.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tra cứu và đặt mượn trên ứng dụng.\nNhận, trả sách trực tiếp tại thư viện.'**
  String get welcomeSubtitle;

  /// No description provided for @backTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get backTooltip;

  /// No description provided for @togglePasswordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hiện/ẩn mật khẩu'**
  String get togglePasswordTooltip;

  /// No description provided for @toggleConfirmPasswordTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Hiện/ẩn mật khẩu nhập lại'**
  String get toggleConfirmPasswordTooltip;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginTitle;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginButton;

  /// No description provided for @createReaderAccountButton.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản độc giả'**
  String get createReaderAccountButton;

  /// No description provided for @welcomeBackTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get welcomeBackTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để đặt mượn và theo dõi sách của bạn.'**
  String get loginSubtitle;

  /// No description provided for @usernameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên đăng nhập'**
  String get usernameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get passwordHint;

  /// No description provided for @retryButton.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retryButton;

  /// No description provided for @noAccountRegisterPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? Đăng ký'**
  String get noAccountRegisterPrompt;

  /// No description provided for @createAccountShortButton.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get createAccountShortButton;

  /// No description provided for @loginErrorTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa đăng nhập được'**
  String get loginErrorTitle;

  /// No description provided for @loginErrorMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập hoặc mật khẩu chưa đúng.'**
  String get loginErrorMessage;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get registerTitle;

  /// No description provided for @registerHeadline.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu mượn sách'**
  String get registerHeadline;

  /// No description provided for @registerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản mới dành cho độc giả.'**
  String get registerSubtitle;

  /// No description provided for @registerErrorBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra lại thông tin'**
  String get registerErrorBannerTitle;

  /// No description provided for @registerErrorBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Sửa các trường được đánh dấu bên dưới.'**
  String get registerErrorBannerMessage;

  /// No description provided for @fullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập họ và tên'**
  String get fullNameHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập lại mật khẩu'**
  String get confirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccountLoginPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? Đăng nhập'**
  String get alreadyHaveAccountLoginPrompt;

  /// No description provided for @errorRequiredField.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập thông tin này.'**
  String get errorRequiredField;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu cần tối thiểu 6 ký tự.'**
  String get errorPasswordTooShort;

  /// No description provided for @errorUsernameExists.
  ///
  /// In vi, this message translates to:
  /// **'Tên đăng nhập đã tồn tại. Chọn tên khác.'**
  String get errorUsernameExists;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu nhập lại chưa khớp.'**
  String get errorPasswordMismatch;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo tài khoản độc giả. Vui lòng đăng nhập.'**
  String get registerSuccessMessage;

  /// No description provided for @logoutButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logoutButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
