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
  String get appBrandUpper => 'THƯ VIỆN';

  @override
  String get welcomeTitle => 'Chào mừng đến thư viện';

  @override
  String get welcomeDescription =>
      'Tra cứu, đặt mượn và theo dõi việc mượn trả sách.';

  @override
  String get changeLanguage => 'Chuyển ngôn ngữ';

  @override
  String get welcomeHeadline => 'Cuốn sách tiếp theo\nđang chờ bạn.';

  @override
  String get welcomeSubtitle =>
      'Tra cứu và đặt mượn trên ứng dụng.\nNhận, trả sách trực tiếp tại thư viện.';

  @override
  String get backTooltip => 'Quay lại';

  @override
  String get togglePasswordTooltip => 'Hiện/ẩn mật khẩu';

  @override
  String get toggleConfirmPasswordTooltip => 'Hiện/ẩn mật khẩu nhập lại';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get createReaderAccountButton => 'Tạo tài khoản độc giả';

  @override
  String get welcomeBackTitle => 'Chào mừng trở lại';

  @override
  String get loginSubtitle => 'Đăng nhập để đặt mượn và theo dõi sách của bạn.';

  @override
  String get usernameLabel => 'Tên đăng nhập';

  @override
  String get usernameHint => 'Nhập tên đăng nhập';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get passwordHint => 'Nhập mật khẩu';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get noAccountRegisterPrompt => 'Chưa có tài khoản? Đăng ký';

  @override
  String get createAccountShortButton => 'Tạo tài khoản';

  @override
  String get loginErrorTitle => 'Chưa đăng nhập được';

  @override
  String get loginErrorMessage => 'Tên đăng nhập hoặc mật khẩu chưa đúng.';

  @override
  String get registerTitle => 'Tạo tài khoản';

  @override
  String get registerHeadline => 'Bắt đầu mượn sách';

  @override
  String get registerSubtitle => 'Tài khoản mới dành cho độc giả.';

  @override
  String get registerErrorBannerTitle => 'Kiểm tra lại thông tin';

  @override
  String get registerErrorBannerMessage =>
      'Sửa các trường được đánh dấu bên dưới.';

  @override
  String get fullNameLabel => 'Họ và tên';

  @override
  String get fullNameHint => 'Nhập họ và tên';

  @override
  String get confirmPasswordLabel => 'Nhập lại mật khẩu';

  @override
  String get confirmPasswordHint => 'Nhập lại mật khẩu';

  @override
  String get registerButton => 'Đăng ký';

  @override
  String get alreadyHaveAccountLoginPrompt => 'Đã có tài khoản? Đăng nhập';

  @override
  String get errorRequiredField => 'Vui lòng nhập thông tin này.';

  @override
  String get errorPasswordTooShort => 'Mật khẩu cần tối thiểu 6 ký tự.';

  @override
  String get errorUsernameExists => 'Tên đăng nhập đã tồn tại. Chọn tên khác.';

  @override
  String get errorPasswordMismatch => 'Mật khẩu nhập lại chưa khớp.';

  @override
  String get registerSuccessMessage =>
      'Đã tạo tài khoản độc giả. Vui lòng đăng nhập.';

  @override
  String get logoutButton => 'Đăng xuất';
}
