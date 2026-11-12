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

  /// No description provided for @changeLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển ngôn ngữ'**
  String get changeLanguage;

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

  /// No description provided for @librarianAccountNotice.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản thủ thư do thư viện cấp.'**
  String get librarianAccountNotice;

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

  /// No description provided for @navExplore.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá'**
  String get navExplore;

  /// No description provided for @navMyLoans.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu mượn'**
  String get navMyLoans;

  /// No description provided for @navFavorites.
  ///
  /// In vi, this message translates to:
  /// **'Yêu thích'**
  String get navFavorites;

  /// No description provided for @navAccount.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get navAccount;

  /// No description provided for @navOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get navOverview;

  /// No description provided for @navBooks.
  ///
  /// In vi, this message translates to:
  /// **'Sách'**
  String get navBooks;

  /// No description provided for @navLoans.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu mượn'**
  String get navLoans;

  /// No description provided for @categoryAll.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả'**
  String get categoryAll;

  /// No description provided for @categoryLiterature.
  ///
  /// In vi, this message translates to:
  /// **'Văn học'**
  String get categoryLiterature;

  /// No description provided for @categoryScience.
  ///
  /// In vi, this message translates to:
  /// **'Khoa học'**
  String get categoryScience;

  /// No description provided for @statusPending.
  ///
  /// In vi, this message translates to:
  /// **'Chờ duyệt'**
  String get statusPending;

  /// No description provided for @statusReadyForPickup.
  ///
  /// In vi, this message translates to:
  /// **'Chờ nhận'**
  String get statusReadyForPickup;

  /// No description provided for @statusBorrowed.
  ///
  /// In vi, this message translates to:
  /// **'Đang mượn'**
  String get statusBorrowed;

  /// No description provided for @statusReturned.
  ///
  /// In vi, this message translates to:
  /// **'Đã trả'**
  String get statusReturned;

  /// No description provided for @statusRejected.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối'**
  String get statusRejected;

  /// No description provided for @statusCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy'**
  String get statusCancelled;

  /// No description provided for @statusOverdue.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn'**
  String get statusOverdue;

  /// No description provided for @readerGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào {name},\nhôm nay bạn muốn đọc gì?'**
  String readerGreeting(String name);

  /// No description provided for @searchBooksHint.
  ///
  /// In vi, this message translates to:
  /// **'Tìm tên sách...'**
  String get searchBooksHint;

  /// No description provided for @searchBooksTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tìm sách'**
  String get searchBooksTitle;

  /// No description provided for @dueSoonBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có {count} sách sắp đến hạn'**
  String dueSoonBannerTitle(int count);

  /// No description provided for @overdueBannerReaderTitle.
  ///
  /// In vi, this message translates to:
  /// **'Có {count} sách đã quá hạn trả'**
  String overdueBannerReaderTitle(int count);

  /// No description provided for @dueSoonBannerSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{title} · còn {days} ngày'**
  String dueSoonBannerSubtitle(String title, int days);

  /// No description provided for @overdueBannerReaderSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{title} · quá hạn {days} ngày'**
  String overdueBannerReaderSubtitle(String title, int days);

  /// No description provided for @exploreShelvesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá trên kệ'**
  String get exploreShelvesTitle;

  /// No description provided for @viewAllButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem tất cả'**
  String get viewAllButton;

  /// No description provided for @suggestedForYouTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn cũng có thể thích'**
  String get suggestedForYouTitle;

  /// No description provided for @copiesAvailableShort.
  ///
  /// In vi, this message translates to:
  /// **'Còn {available} bản'**
  String copiesAvailableShort(int available);

  /// No description provided for @copiesRatioLabel.
  ///
  /// In vi, this message translates to:
  /// **'Còn {available}/{total} bản'**
  String copiesRatioLabel(int available, int total);

  /// No description provided for @outOfCopiesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tạm hết bản khả dụng'**
  String get outOfCopiesLabel;

  /// No description provided for @bookCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} đầu sách'**
  String bookCountLabel(int count);

  /// No description provided for @noBooksFoundTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa tìm thấy sách phù hợp'**
  String get noBooksFoundTitle;

  /// No description provided for @noBooksFoundSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Thử từ khóa ngắn hơn hoặc bỏ bộ lọc thể loại.'**
  String get noBooksFoundSubtitle;

  /// No description provided for @clearFiltersButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa bộ lọc'**
  String get clearFiltersButton;

  /// No description provided for @bookDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết sách'**
  String get bookDetailTitle;

  /// No description provided for @bookIdPrefix.
  ///
  /// In vi, this message translates to:
  /// **'Mã sách {id}'**
  String bookIdPrefix(String id);

  /// No description provided for @aboutBookSection.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu'**
  String get aboutBookSection;

  /// No description provided for @detailInfoSection.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin chi tiết'**
  String get detailInfoSection;

  /// No description provided for @formatLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hình thức'**
  String get formatLabel;

  /// No description provided for @formatPhysicalBook.
  ///
  /// In vi, this message translates to:
  /// **'Sách giấy'**
  String get formatPhysicalBook;

  /// No description provided for @loanDurationLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thời hạn mượn'**
  String get loanDurationLabel;

  /// No description provided for @loanDurationValue.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày từ khi nhận'**
  String get loanDurationValue;

  /// No description provided for @perLoanLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi phiếu'**
  String get perLoanLabel;

  /// No description provided for @perLoanValue.
  ///
  /// In vi, this message translates to:
  /// **'1 bản sách'**
  String get perLoanValue;

  /// No description provided for @requestBorrowButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký mượn'**
  String get requestBorrowButton;

  /// No description provided for @outOfStockButton.
  ///
  /// In vi, this message translates to:
  /// **'Tạm hết sách'**
  String get outOfStockButton;

  /// No description provided for @addToFavoritesButton.
  ///
  /// In vi, this message translates to:
  /// **'Thêm vào yêu thích'**
  String get addToFavoritesButton;

  /// No description provided for @removeFromFavoritesButton.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ yêu thích'**
  String get removeFromFavoritesButton;

  /// No description provided for @outOfCopiesBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hiện chưa có bản để mượn'**
  String get outOfCopiesBannerTitle;

  /// No description provided for @outOfCopiesBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có thể lưu vào yêu thích và kiểm tra lại sau.'**
  String get outOfCopiesBannerMessage;

  /// No description provided for @duplicateActiveLoanBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã đặt mượn đầu sách này'**
  String get duplicateActiveLoanBannerTitle;

  /// No description provided for @duplicateActiveLoanBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu {loanId} đang {status}. Không thể tạo thêm phiếu cho cùng đầu sách.'**
  String duplicateActiveLoanBannerMessage(String loanId, String status);

  /// No description provided for @viewLoanButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem phiếu {loanId}'**
  String viewLoanButton(String loanId);

  /// No description provided for @alreadyHasActiveLoanButton.
  ///
  /// In vi, this message translates to:
  /// **'Đã có phiếu đang hoạt động'**
  String get alreadyHasActiveLoanButton;

  /// No description provided for @favoriteAddedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm vào sách yêu thích.'**
  String get favoriteAddedMessage;

  /// No description provided for @favoriteRemovedMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã bỏ khỏi sách yêu thích.'**
  String get favoriteRemovedMessage;

  /// No description provided for @borrowRequestTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký mượn'**
  String get borrowRequestTitle;

  /// No description provided for @oneCopyCounterPickup.
  ///
  /// In vi, this message translates to:
  /// **'1 bản · nhận tại quầy'**
  String get oneCopyCounterPickup;

  /// No description provided for @pickupDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày hẹn nhận'**
  String get pickupDateLabel;

  /// No description provided for @pickupDateHelper.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ hôm nay đến 7 ngày tới.'**
  String get pickupDateHelper;

  /// No description provided for @selectPickupDateTooltip.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày nhận'**
  String get selectPickupDateTooltip;

  /// No description provided for @datePickerHelpText.
  ///
  /// In vi, this message translates to:
  /// **'CHỌN NGÀY NHẬN'**
  String get datePickerHelpText;

  /// No description provided for @datePickerCancelButton.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get datePickerCancelButton;

  /// No description provided for @datePickerConfirmButton.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày'**
  String get datePickerConfirmButton;

  /// No description provided for @activeLoansCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu đang hoạt động'**
  String get activeLoansCountLabel;

  /// No description provided for @activeLoansShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu hoạt động'**
  String get activeLoansShortLabel;

  /// No description provided for @activeLoansRatioValue.
  ///
  /// In vi, this message translates to:
  /// **'{active}/{max} phiếu'**
  String activeLoansRatioValue(int active, int max);

  /// No description provided for @loanDurationFromPickupValue.
  ///
  /// In vi, this message translates to:
  /// **'7 ngày kể từ lúc nhận'**
  String get loanDurationFromPickupValue;

  /// No description provided for @holdDeadlineLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn giữ chỗ'**
  String get holdDeadlineLabel;

  /// No description provided for @holdDeadlineValue.
  ///
  /// In vi, this message translates to:
  /// **'Hết ngày hẹn nhận'**
  String get holdDeadlineValue;

  /// No description provided for @holdNoticeBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Giữ chỗ ngay khi gửi'**
  String get holdNoticeBannerTitle;

  /// No description provided for @holdNoticeBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'1 bản sẽ được giữ cho bạn. Bạn có thể hủy khi phiếu chưa chuyển sang Đang mượn.'**
  String get holdNoticeBannerMessage;

  /// No description provided for @submitBorrowRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Gửi yêu cầu mượn'**
  String get submitBorrowRequestButton;

  /// No description provided for @borrowRequestSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi yêu cầu. Thư viện đang giữ 1 bản cho bạn.'**
  String get borrowRequestSuccessMessage;

  /// No description provided for @limitReachedBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn đã có 3 phiếu đang hoạt động'**
  String get limitReachedBannerTitle;

  /// No description provided for @limitReachedBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hãy trả sách hoặc hủy một yêu cầu chưa nhận rồi thử lại.'**
  String get limitReachedBannerMessage;

  /// No description provided for @limitReachedButton.
  ///
  /// In vi, this message translates to:
  /// **'Đã đạt giới hạn 3 phiếu'**
  String get limitReachedButton;

  /// No description provided for @viewMyLoansButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem phiếu của tôi'**
  String get viewMyLoansButton;

  /// No description provided for @myLoansTitle.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu mượn của tôi'**
  String get myLoansTitle;

  /// No description provided for @loanHistoryTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử mượn'**
  String get loanHistoryTitle;

  /// No description provided for @filterActiveLoans.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get filterActiveLoans;

  /// No description provided for @filterLoanHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử'**
  String get filterLoanHistory;

  /// No description provided for @activeLoansSummary.
  ///
  /// In vi, this message translates to:
  /// **'{active}/{max} phiếu đang hoạt động'**
  String activeLoansSummary(int active, int max);

  /// No description provided for @pickupDateInline.
  ///
  /// In vi, this message translates to:
  /// **'Hẹn nhận: {date}'**
  String pickupDateInline(String date);

  /// No description provided for @dueDateInline.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả: {date}'**
  String dueDateInline(String date);

  /// No description provided for @trackLoansBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Theo dõi phiếu tại đây'**
  String get trackLoansBannerTitle;

  /// No description provided for @trackLoansBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Sau khi được duyệt, mang mã phiếu đến quầy để nhận sách.'**
  String get trackLoansBannerMessage;

  /// No description provided for @emptyLoansTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có phiếu mượn nào'**
  String get emptyLoansTitle;

  /// No description provided for @emptyLoansSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá kệ sách và đăng ký mượn cuốn sách bạn yêu thích.'**
  String get emptyLoansSubtitle;

  /// No description provided for @loanDetailTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết phiếu'**
  String get loanDetailTitle;

  /// No description provided for @loanIdLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã phiếu'**
  String get loanIdLabel;

  /// No description provided for @readerLabel.
  ///
  /// In vi, this message translates to:
  /// **'Độc giả'**
  String get readerLabel;

  /// No description provided for @accountLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get accountLabel;

  /// No description provided for @createdAtLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày đăng ký'**
  String get createdAtLabel;

  /// No description provided for @pickupDateShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hẹn nhận'**
  String get pickupDateShortLabel;

  /// No description provided for @borrowedAtLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận sách'**
  String get borrowedAtLabel;

  /// No description provided for @dueAtLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả'**
  String get dueAtLabel;

  /// No description provided for @newDueAtLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả mới'**
  String get newDueAtLabel;

  /// No description provided for @returnedAtLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đã trả'**
  String get returnedAtLabel;

  /// No description provided for @renewalLabel.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn'**
  String get renewalLabel;

  /// No description provided for @renewalUsedValue.
  ///
  /// In vi, this message translates to:
  /// **'Đã sử dụng {count}/1 lần'**
  String renewalUsedValue(int count);

  /// No description provided for @reasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lý do'**
  String get reasonLabel;

  /// No description provided for @processedByLabel.
  ///
  /// In vi, this message translates to:
  /// **'Xử lý bởi'**
  String get processedByLabel;

  /// No description provided for @librarianRoleName.
  ///
  /// In vi, this message translates to:
  /// **'Thủ thư'**
  String get librarianRoleName;

  /// No description provided for @readerRoleName.
  ///
  /// In vi, this message translates to:
  /// **'Độc giả'**
  String get readerRoleName;

  /// No description provided for @availableAfterProcessLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khả dụng sau xử lý'**
  String get availableAfterProcessLabel;

  /// No description provided for @copiesCountValue.
  ///
  /// In vi, this message translates to:
  /// **'{count} bản'**
  String copiesCountValue(int count);

  /// No description provided for @pendingBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã giữ chỗ 1 bản'**
  String get pendingBannerTitle;

  /// No description provided for @pendingBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu đang chờ thủ thư duyệt.'**
  String get pendingBannerMessage;

  /// No description provided for @readyBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sách đã sẵn sàng'**
  String get readyBannerTitle;

  /// No description provided for @readyBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đến quầy nhận sách trong ngày {date}. Mang theo mã phiếu {loanId}.'**
  String readyBannerMessage(String date, String loanId);

  /// No description provided for @borrowedBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Còn {days} ngày để trả sách'**
  String borrowedBannerTitle(int days);

  /// No description provided for @borrowedRenewableBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Có thể gia hạn thêm 7 ngày, tối đa 1 lần.'**
  String get borrowedRenewableBannerMessage;

  /// No description provided for @borrowedDueSoonBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mang sách đến quầy thư viện trước hạn.'**
  String get borrowedDueSoonBannerMessage;

  /// No description provided for @renewedBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã gia hạn thành công'**
  String get renewedBannerTitle;

  /// No description provided for @renewedBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả mới: {date}.'**
  String renewedBannerMessage(String date);

  /// No description provided for @overdueLoanBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã quá hạn trả {days} ngày'**
  String overdueLoanBannerTitle(int days);

  /// No description provided for @overdueLoanBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng mang sách đến quầy. Phiếu quá hạn không được gia hạn.'**
  String get overdueLoanBannerMessage;

  /// No description provided for @returnedBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã hoàn tất'**
  String get returnedBannerTitle;

  /// No description provided for @returnedBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Thư viện đã ghi nhận sách trả. Cảm ơn bạn!'**
  String get returnedBannerMessage;

  /// No description provided for @rejectedReaderBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu chưa được chấp nhận'**
  String get rejectedReaderBannerTitle;

  /// No description provided for @rejectedLibrarianBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối yêu cầu'**
  String get rejectedLibrarianBannerTitle;

  /// No description provided for @rejectedBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Lý do: {reason}'**
  String rejectedBannerMessage(String reason);

  /// No description provided for @cancelledBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy yêu cầu'**
  String get cancelledBannerTitle;

  /// No description provided for @cancelledBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bản sách đã được trả lại thư viện.'**
  String get cancelledBannerMessage;

  /// No description provided for @expiredPickupBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy do quá hạn nhận'**
  String get expiredPickupBannerTitle;

  /// No description provided for @expiredPickupBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Bạn chưa nhận sách trước khi hết ngày hẹn. Bản sách đã được trả lại kho.'**
  String get expiredPickupBannerMessage;

  /// No description provided for @cancelRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu'**
  String get cancelRequestButton;

  /// No description provided for @cancelDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Hủy yêu cầu mượn?'**
  String get cancelDialogTitle;

  /// No description provided for @cancelDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu {loanId} sẽ được hủy. Bản sách đã giữ chỗ sẽ được trả về thư viện.'**
  String cancelDialogMessage(String loanId);

  /// No description provided for @keepLoanButton.
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại phiếu'**
  String get keepLoanButton;

  /// No description provided for @cancelSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã hủy yêu cầu.'**
  String get cancelSuccessMessage;

  /// No description provided for @renewLoanButton.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn thêm 7 ngày'**
  String get renewLoanButton;

  /// No description provided for @renewDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn thêm 7 ngày?'**
  String get renewDialogTitle;

  /// No description provided for @currentDueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn hiện tại'**
  String get currentDueLabel;

  /// No description provided for @newDueLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn mới'**
  String get newDueLabel;

  /// No description provided for @renewDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mỗi phiếu được gia hạn 1 lần. Sau xác nhận, bạn không thể gia hạn lần nữa.'**
  String get renewDialogMessage;

  /// No description provided for @confirmRenewButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận gia hạn'**
  String get confirmRenewButton;

  /// No description provided for @laterButton.
  ///
  /// In vi, this message translates to:
  /// **'Để sau'**
  String get laterButton;

  /// No description provided for @renewSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã gia hạn đến {date}.'**
  String renewSuccessMessage(String date);

  /// No description provided for @noRenewalsLeftButton.
  ///
  /// In vi, this message translates to:
  /// **'Đã hết lượt gia hạn'**
  String get noRenewalsLeftButton;

  /// No description provided for @backToMyLoansButton.
  ///
  /// In vi, this message translates to:
  /// **'Về phiếu mượn'**
  String get backToMyLoansButton;

  /// No description provided for @searchToRebookButton.
  ///
  /// In vi, this message translates to:
  /// **'Tra cứu để đặt lại'**
  String get searchToRebookButton;

  /// No description provided for @findOtherBooksButton.
  ///
  /// In vi, this message translates to:
  /// **'Tìm sách khác'**
  String get findOtherBooksButton;

  /// No description provided for @exploreOtherBooksButton.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá sách khác'**
  String get exploreOtherBooksButton;

  /// No description provided for @scrollHintLargeText.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung có thể cuộn khi bạn tăng kích thước chữ trên thiết bị.'**
  String get scrollHintLargeText;

  /// No description provided for @reasonExpiredPickup.
  ///
  /// In vi, this message translates to:
  /// **'Quá hạn nhận'**
  String get reasonExpiredPickup;

  /// No description provided for @reasonReaderCancelled.
  ///
  /// In vi, this message translates to:
  /// **'Độc giả hủy yêu cầu'**
  String get reasonReaderCancelled;

  /// No description provided for @approveRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Duyệt yêu cầu'**
  String get approveRequestButton;

  /// No description provided for @approveSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã duyệt phiếu.'**
  String get approveSuccessMessage;

  /// No description provided for @rejectRequestButton.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối yêu cầu'**
  String get rejectRequestButton;

  /// No description provided for @rejectDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Từ chối yêu cầu'**
  String get rejectDialogTitle;

  /// No description provided for @rejectDialogSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Cho độc giả biết lý do chưa thể mượn sách.'**
  String get rejectDialogSubtitle;

  /// No description provided for @rejectReasonLabel.
  ///
  /// In vi, this message translates to:
  /// **'Lý do từ chối *'**
  String get rejectReasonLabel;

  /// No description provided for @rejectReasonHint.
  ///
  /// In vi, this message translates to:
  /// **'Sách cần kiểm tra tình trạng.'**
  String get rejectReasonHint;

  /// No description provided for @confirmRejectButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận từ chối'**
  String get confirmRejectButton;

  /// No description provided for @rejectSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã từ chối yêu cầu.'**
  String get rejectSuccessMessage;

  /// No description provided for @confirmHandoverButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đã giao sách'**
  String get confirmHandoverButton;

  /// No description provided for @handoverDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao sách cho độc giả?'**
  String get handoverDialogTitle;

  /// No description provided for @handoverDialogSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận khi {reader} đã nhận 1 bản {book} tại quầy.'**
  String handoverDialogSubtitle(String reader, String book);

  /// No description provided for @pickupTimeLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày nhận'**
  String get pickupTimeLabel;

  /// No description provided for @expectedDueDateLabel.
  ///
  /// In vi, this message translates to:
  /// **'Hạn trả dự kiến'**
  String get expectedDueDateLabel;

  /// No description provided for @confirmHandedOverButton.
  ///
  /// In vi, this message translates to:
  /// **'Đã giao sách'**
  String get confirmHandedOverButton;

  /// No description provided for @notHandedOverButton.
  ///
  /// In vi, this message translates to:
  /// **'Chưa giao'**
  String get notHandedOverButton;

  /// No description provided for @handoverSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xác nhận giao sách.'**
  String get handoverSuccessMessage;

  /// No description provided for @confirmReturnButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận đã trả sách'**
  String get confirmReturnButton;

  /// No description provided for @returnDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đã nhận lại sách?'**
  String get returnDialogTitle;

  /// No description provided for @returnDialogSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận khi thư viện đã nhận lại 1 bản {book} từ {reader}.'**
  String returnDialogSubtitle(String book, String reader);

  /// No description provided for @returnDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu {loanId} sẽ chuyển sang Đã trả và tăng số bản khả dụng thêm 1.'**
  String returnDialogMessage(String loanId);

  /// No description provided for @confirmReturnDialogButton.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận trả sách'**
  String get confirmReturnDialogButton;

  /// No description provided for @notReturnedYetButton.
  ///
  /// In vi, this message translates to:
  /// **'Chưa nhận lại'**
  String get notReturnedYetButton;

  /// No description provided for @returnSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã ghi nhận trả sách.'**
  String get returnSuccessMessage;

  /// No description provided for @backToLoanListButton.
  ///
  /// In vi, this message translates to:
  /// **'Về danh sách phiếu'**
  String get backToLoanListButton;

  /// No description provided for @favoritesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Sách yêu thích'**
  String get favoritesTitle;

  /// No description provided for @savedBooksCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} cuốn sách đã lưu'**
  String savedBooksCountLabel(int count);

  /// No description provided for @favoritesTapHint.
  ///
  /// In vi, this message translates to:
  /// **'Chạm vào sách để xem chi tiết hoặc bỏ yêu thích.'**
  String get favoritesTapHint;

  /// No description provided for @emptyFavoritesTitle.
  ///
  /// In vi, this message translates to:
  /// **'Kệ yêu thích còn trống'**
  String get emptyFavoritesTitle;

  /// No description provided for @emptyFavoritesSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chạm biểu tượng trái tim trong chi tiết sách để lưu những cuốn bạn muốn đọc.'**
  String get emptyFavoritesSubtitle;

  /// No description provided for @exploreBooksButton.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá sách'**
  String get exploreBooksButton;

  /// No description provided for @accountTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân'**
  String get accountTitle;

  /// No description provided for @activeLoansSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'{count} phiếu đang hoạt động'**
  String activeLoansSubtitle(int count);

  /// No description provided for @languageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get languageTitle;

  /// No description provided for @currentLanguageVietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get currentLanguageVietnamese;

  /// No description provided for @currentLanguageEnglish.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get currentLanguageEnglish;

  /// No description provided for @selectLanguageHeading.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngôn ngữ hiển thị'**
  String get selectLanguageHeading;

  /// No description provided for @selectLanguageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Áp dụng cho toàn bộ giao diện, thông báo và trạng thái phiếu.'**
  String get selectLanguageSubtitle;

  /// No description provided for @inUseLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đang sử dụng'**
  String get inUseLabel;

  /// No description provided for @switchToVietnameseSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Chuyển giao diện sang Tiếng Việt'**
  String get switchToVietnameseSubtitle;

  /// No description provided for @switchToEnglishSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Switch interface to English'**
  String get switchToEnglishSubtitle;

  /// No description provided for @bookContentPreservedBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Nội dung sách giữ nguyên'**
  String get bookContentPreservedBannerTitle;

  /// No description provided for @bookContentPreservedBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tên sách, tác giả và thông tin tài khoản không được dịch tự động.'**
  String get bookContentPreservedBannerMessage;

  /// No description provided for @teamInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin nhóm'**
  String get teamInfoTitle;

  /// No description provided for @teamInfoSubtitleReader.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng đặt mượn sách thư viện'**
  String get teamInfoSubtitleReader;

  /// No description provided for @teamInfoSubtitleLibrarian.
  ///
  /// In vi, this message translates to:
  /// **'Nhóm thực hiện ứng dụng'**
  String get teamInfoSubtitleLibrarian;

  /// No description provided for @teamAppHeading.
  ///
  /// In vi, this message translates to:
  /// **'Ứng dụng đặt mượn\nsách thư viện'**
  String get teamAppHeading;

  /// No description provided for @teamCourseSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập lớn · Lập trình thiết bị di động'**
  String get teamCourseSubtitle;

  /// No description provided for @member1Name.
  ///
  /// In vi, this message translates to:
  /// **'Vũ Xuân Minh'**
  String get member1Name;

  /// No description provided for @member1Info.
  ///
  /// In vi, this message translates to:
  /// **'MSSV: 24100363\nXây dựng trang chủ độc giả và thủ thư, tìm kiếm, lọc, xem chi tiết sách và quản lý danh mục sách.'**
  String get member1Info;

  /// No description provided for @member2Name.
  ///
  /// In vi, this message translates to:
  /// **'Lê Anh Quân'**
  String get member2Name;

  /// No description provided for @member2Info.
  ///
  /// In vi, this message translates to:
  /// **'MSSV: 23010580\nXây dựng đăng ký, đăng nhập, đăng xuất, thông tin cá nhân, đa ngôn ngữ và mô hình, kho dữ liệu dùng chung.'**
  String get member2Info;

  /// No description provided for @member3Name.
  ///
  /// In vi, this message translates to:
  /// **'Trần Hữu Kiên'**
  String get member3Name;

  /// No description provided for @member3Info.
  ///
  /// In vi, this message translates to:
  /// **'MSSV: 23010258\nXây dựng luồng đặt mượn, theo dõi, hủy, gia hạn, duyệt phiếu, giao–trả sách và quản lý sách yêu thích.'**
  String get member3Info;

  /// No description provided for @appVersionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản 1.0'**
  String get appVersionLabel;

  /// No description provided for @librarianDeskTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bàn thủ thư'**
  String get librarianDeskTitle;

  /// No description provided for @librarianGreetingTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chào thủ thư,'**
  String get librarianGreetingTitle;

  /// No description provided for @librarianGreetingSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay cần xử lý gì?'**
  String get librarianGreetingSubtitle;

  /// No description provided for @metricBookTitles.
  ///
  /// In vi, this message translates to:
  /// **'Đầu sách'**
  String get metricBookTitles;

  /// No description provided for @metricBorrowedCopies.
  ///
  /// In vi, this message translates to:
  /// **'Bản đang mượn'**
  String get metricBorrowedCopies;

  /// No description provided for @metricPendingRequests.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu chờ duyệt'**
  String get metricPendingRequests;

  /// No description provided for @metricOverdueLoans.
  ///
  /// In vi, this message translates to:
  /// **'Phiếu quá hạn'**
  String get metricOverdueLoans;

  /// No description provided for @recentRequestsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Yêu cầu gần đây'**
  String get recentRequestsTitle;

  /// No description provided for @overdueLibrarianBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'{count} sách đang quá hạn'**
  String overdueLibrarianBannerTitle(int count);

  /// No description provided for @overdueLibrarianBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Mở phiếu để kiểm tra thông tin độc giả.'**
  String get overdueLibrarianBannerMessage;

  /// No description provided for @bookManagementTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý sách'**
  String get bookManagementTitle;

  /// No description provided for @searchBookOrCodeHint.
  ///
  /// In vi, this message translates to:
  /// **'Tên sách hoặc mã sách'**
  String get searchBookOrCodeHint;

  /// No description provided for @addBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Thêm đầu sách'**
  String get addBookButton;

  /// No description provided for @filterActiveBooks.
  ///
  /// In vi, this message translates to:
  /// **'Đang phục vụ'**
  String get filterActiveBooks;

  /// No description provided for @filterInactiveBooks.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng phục vụ'**
  String get filterInactiveBooks;

  /// No description provided for @bookSummaryLine.
  ///
  /// In vi, this message translates to:
  /// **'{id} · Tổng {total} · Khả dụng {available}'**
  String bookSummaryLine(String id, int total, int available);

  /// No description provided for @bookInactiveSummaryLine.
  ///
  /// In vi, this message translates to:
  /// **'{id} · Ngừng phục vụ'**
  String bookInactiveSummaryLine(String id);

  /// No description provided for @historyPreservedBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử được giữ nguyên'**
  String get historyPreservedBannerTitle;

  /// No description provided for @historyPreservedBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đầu sách ngừng phục vụ không xuất hiện trong danh sách đặt mượn của độc giả.'**
  String get historyPreservedBannerMessage;

  /// No description provided for @bookInfoTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin đầu sách'**
  String get bookInfoTitle;

  /// No description provided for @bookIdShortLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã sách'**
  String get bookIdShortLabel;

  /// No description provided for @totalCopiesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số bản'**
  String get totalCopiesLabel;

  /// No description provided for @reservedCopiesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đang giữ chỗ'**
  String get reservedCopiesLabel;

  /// No description provided for @borrowedCopiesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Đang mượn'**
  String get borrowedCopiesLabel;

  /// No description provided for @availableCopiesLabel.
  ///
  /// In vi, this message translates to:
  /// **'Khả dụng'**
  String get availableCopiesLabel;

  /// No description provided for @editBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa đầu sách'**
  String get editBookButton;

  /// No description provided for @deactivateBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng phục vụ'**
  String get deactivateBookButton;

  /// No description provided for @activateBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Mở phục vụ lại'**
  String get activateBookButton;

  /// No description provided for @deleteBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Xóa đầu sách'**
  String get deleteBookButton;

  /// No description provided for @activeLoansOnBookBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đang có phiếu hoạt động'**
  String get activeLoansOnBookBannerTitle;

  /// No description provided for @activeLoansOnBookBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ ngừng phục vụ hoặc xóa khi không còn phiếu Chờ duyệt, Chờ nhận, Đang mượn.'**
  String get activeLoansOnBookBannerMessage;

  /// No description provided for @historyOnlyOnBookBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉ còn lịch sử mượn'**
  String get historyOnlyOnBookBannerTitle;

  /// No description provided for @historyOnlyOnBookBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Có thể ngừng phục vụ để giữ nguyên lịch sử mượn.'**
  String get historyOnlyOnBookBannerMessage;

  /// No description provided for @cannotDeactivateDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thể ngừng phục vụ'**
  String get cannotDeactivateDialogTitle;

  /// No description provided for @cannotDeactivateDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đầu sách này đang có {count} phiếu hoạt động. Hãy hoàn tất hoặc hủy các phiếu hợp lệ trước.'**
  String cannotDeactivateDialogMessage(int count);

  /// No description provided for @viewRelatedLoansButton.
  ///
  /// In vi, this message translates to:
  /// **'Xem phiếu liên quan'**
  String get viewRelatedLoansButton;

  /// No description provided for @closeButton.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get closeButton;

  /// No description provided for @deactivateBookDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Ngừng phục vụ đầu sách?'**
  String get deactivateBookDialogTitle;

  /// No description provided for @deactivateBookDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đầu sách đã có lịch sử mượn nên không thể xóa. Sau khi ngừng phục vụ, độc giả không thể đặt mượn mới; lịch sử vẫn được giữ.'**
  String get deactivateBookDialogMessage;

  /// No description provided for @deactivateSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã ngừng phục vụ đầu sách.'**
  String get deactivateSuccessMessage;

  /// No description provided for @deleteBookDialogTitle.
  ///
  /// In vi, this message translates to:
  /// **'Xóa đầu sách {bookId}?'**
  String deleteBookDialogTitle(String bookId);

  /// No description provided for @deleteBookDialogMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đầu sách chưa từng xuất hiện trong phiếu mượn. Sau khi xóa, sách sẽ không còn trong danh mục.'**
  String get deleteBookDialogMessage;

  /// No description provided for @keepBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Giữ lại'**
  String get keepBookButton;

  /// No description provided for @deleteBookSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã xóa đầu sách.'**
  String get deleteBookSuccessMessage;

  /// No description provided for @addBookTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thêm đầu sách'**
  String get addBookTitle;

  /// No description provided for @editBookTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa đầu sách'**
  String get editBookTitle;

  /// No description provided for @requiredFieldsNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin bắt buộc được đánh dấu *.'**
  String get requiredFieldsNotice;

  /// No description provided for @bookIdRequiredLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã đầu sách *'**
  String get bookIdRequiredLabel;

  /// No description provided for @bookIdFixedLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mã sách (cố định)'**
  String get bookIdFixedLabel;

  /// No description provided for @bookTitleRequiredLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tên sách *'**
  String get bookTitleRequiredLabel;

  /// No description provided for @bookTitleHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên sách'**
  String get bookTitleHint;

  /// No description provided for @authorRequiredLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tác giả *'**
  String get authorRequiredLabel;

  /// No description provided for @authorHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên tác giả'**
  String get authorHint;

  /// No description provided for @categoryRequiredLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thể loại *'**
  String get categoryRequiredLabel;

  /// No description provided for @categoryHint.
  ///
  /// In vi, this message translates to:
  /// **'Chọn thể loại'**
  String get categoryHint;

  /// No description provided for @totalCopiesRequiredLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số bản *'**
  String get totalCopiesRequiredLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mô tả'**
  String get descriptionLabel;

  /// No description provided for @descriptionHint.
  ///
  /// In vi, this message translates to:
  /// **'Nhập giới thiệu ngắn'**
  String get descriptionHint;

  /// No description provided for @saveBookButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu đầu sách'**
  String get saveBookButton;

  /// No description provided for @saveChangesButton.
  ///
  /// In vi, this message translates to:
  /// **'Lưu thay đổi'**
  String get saveChangesButton;

  /// No description provided for @saveBookSuccessMessage.
  ///
  /// In vi, this message translates to:
  /// **'Đã lưu thông tin đầu sách.'**
  String get saveBookSuccessMessage;

  /// No description provided for @errorBookIdExists.
  ///
  /// In vi, this message translates to:
  /// **'Mã đầu sách đã tồn tại.'**
  String get errorBookIdExists;

  /// No description provided for @errorInvalidTotalCopies.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số nguyên lớn hơn hoặc bằng 0.'**
  String get errorInvalidTotalCopies;

  /// No description provided for @errorTotalCopiesBelowActive.
  ///
  /// In vi, this message translates to:
  /// **'Tối thiểu {min} bản: đang giữ chỗ {reserved}, đang mượn {borrowed}.'**
  String errorTotalCopiesBelowActive(int min, int reserved, int borrowed);

  /// No description provided for @cannotSaveBookBannerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Chưa thể lưu thay đổi'**
  String get cannotSaveBookBannerTitle;

  /// No description provided for @cannotSaveBookBannerMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tổng số bản không được thấp hơn số bản đang giữ chỗ và đang mượn.'**
  String get cannotSaveBookBannerMessage;

  /// No description provided for @loanManagementTitle.
  ///
  /// In vi, this message translates to:
  /// **'Quản lý phiếu mượn'**
  String get loanManagementTitle;

  /// No description provided for @searchLoansHint.
  ///
  /// In vi, this message translates to:
  /// **'Mã phiếu, độc giả, tên sách'**
  String get searchLoansHint;

  /// No description provided for @allLoansButton.
  ///
  /// In vi, this message translates to:
  /// **'Tất cả phiếu'**
  String get allLoansButton;
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
