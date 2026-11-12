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
  String get welcomeHeadline => 'Cuốn sách tiếp theo\nđang chờ bạn.';

  @override
  String get welcomeSubtitle =>
      'Tra cứu và đặt mượn trên ứng dụng.\nNhận, trả sách trực tiếp tại thư viện.';

  @override
  String get changeLanguage => 'Chuyển ngôn ngữ';

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
  String get librarianAccountNotice => 'Tài khoản thủ thư do thư viện cấp.';

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

  @override
  String get navExplore => 'Khám phá';

  @override
  String get navMyLoans => 'Phiếu mượn';

  @override
  String get navFavorites => 'Yêu thích';

  @override
  String get navAccount => 'Cá nhân';

  @override
  String get navOverview => 'Tổng quan';

  @override
  String get navBooks => 'Sách';

  @override
  String get navLoans => 'Phiếu mượn';

  @override
  String get categoryAll => 'Tất cả';

  @override
  String get categoryLiterature => 'Văn học';

  @override
  String get categoryScience => 'Khoa học';

  @override
  String get statusPending => 'Chờ duyệt';

  @override
  String get statusReadyForPickup => 'Chờ nhận';

  @override
  String get statusBorrowed => 'Đang mượn';

  @override
  String get statusReturned => 'Đã trả';

  @override
  String get statusRejected => 'Từ chối';

  @override
  String get statusCancelled => 'Đã hủy';

  @override
  String get statusOverdue => 'Quá hạn';

  @override
  String readerGreeting(String name) {
    return 'Chào $name,\nhôm nay bạn muốn đọc gì?';
  }

  @override
  String get searchBooksHint => 'Tìm tên sách...';

  @override
  String get searchBooksTitle => 'Tìm sách';

  @override
  String dueSoonBannerTitle(int count) {
    return 'Có $count sách sắp đến hạn';
  }

  @override
  String overdueBannerReaderTitle(int count) {
    return 'Có $count sách đã quá hạn trả';
  }

  @override
  String dueSoonBannerSubtitle(String title, int days) {
    return '$title · còn $days ngày';
  }

  @override
  String overdueBannerReaderSubtitle(String title, int days) {
    return '$title · quá hạn $days ngày';
  }

  @override
  String get exploreShelvesTitle => 'Khám phá trên kệ';

  @override
  String get viewAllButton => 'Xem tất cả';

  @override
  String get suggestedForYouTitle => 'Bạn cũng có thể thích';

  @override
  String copiesAvailableShort(int available) {
    return 'Còn $available bản';
  }

  @override
  String copiesRatioLabel(int available, int total) {
    return 'Còn $available/$total bản';
  }

  @override
  String get outOfCopiesLabel => 'Tạm hết bản khả dụng';

  @override
  String bookCountLabel(int count) {
    return '$count đầu sách';
  }

  @override
  String get noBooksFoundTitle => 'Chưa tìm thấy sách phù hợp';

  @override
  String get noBooksFoundSubtitle =>
      'Thử từ khóa ngắn hơn hoặc bỏ bộ lọc thể loại.';

  @override
  String get clearFiltersButton => 'Xóa bộ lọc';

  @override
  String get bookDetailTitle => 'Chi tiết sách';

  @override
  String bookIdPrefix(String id) {
    return 'Mã sách $id';
  }

  @override
  String get aboutBookSection => 'Giới thiệu';

  @override
  String get detailInfoSection => 'Thông tin chi tiết';

  @override
  String get formatLabel => 'Hình thức';

  @override
  String get formatPhysicalBook => 'Sách giấy';

  @override
  String get loanDurationLabel => 'Thời hạn mượn';

  @override
  String get loanDurationValue => '7 ngày từ khi nhận';

  @override
  String get perLoanLabel => 'Mỗi phiếu';

  @override
  String get perLoanValue => '1 bản sách';

  @override
  String get requestBorrowButton => 'Đăng ký mượn';

  @override
  String get outOfStockButton => 'Tạm hết sách';

  @override
  String get addToFavoritesButton => 'Thêm vào yêu thích';

  @override
  String get removeFromFavoritesButton => 'Bỏ yêu thích';

  @override
  String get outOfCopiesBannerTitle => 'Hiện chưa có bản để mượn';

  @override
  String get outOfCopiesBannerMessage =>
      'Bạn có thể lưu vào yêu thích và kiểm tra lại sau.';

  @override
  String get duplicateActiveLoanBannerTitle => 'Bạn đã đặt mượn đầu sách này';

  @override
  String duplicateActiveLoanBannerMessage(String loanId, String status) {
    return 'Phiếu $loanId đang $status. Không thể tạo thêm phiếu cho cùng đầu sách.';
  }

  @override
  String viewLoanButton(String loanId) {
    return 'Xem phiếu $loanId';
  }

  @override
  String get alreadyHasActiveLoanButton => 'Đã có phiếu đang hoạt động';

  @override
  String get favoriteAddedMessage => 'Đã thêm vào sách yêu thích.';

  @override
  String get favoriteRemovedMessage => 'Đã bỏ khỏi sách yêu thích.';

  @override
  String get borrowRequestTitle => 'Đăng ký mượn';

  @override
  String get oneCopyCounterPickup => '1 bản · nhận tại quầy';

  @override
  String get pickupDateLabel => 'Ngày hẹn nhận';

  @override
  String get pickupDateHelper => 'Chọn từ hôm nay đến 7 ngày tới.';

  @override
  String get selectPickupDateTooltip => 'Chọn ngày nhận';

  @override
  String get datePickerHelpText => 'CHỌN NGÀY NHẬN';

  @override
  String get datePickerCancelButton => 'Hủy';

  @override
  String get datePickerConfirmButton => 'Chọn ngày';

  @override
  String get activeLoansCountLabel => 'Phiếu đang hoạt động';

  @override
  String get activeLoansShortLabel => 'Phiếu hoạt động';

  @override
  String activeLoansRatioValue(int active, int max) {
    return '$active/$max phiếu';
  }

  @override
  String get loanDurationFromPickupValue => '7 ngày kể từ lúc nhận';

  @override
  String get holdDeadlineLabel => 'Hạn giữ chỗ';

  @override
  String get holdDeadlineValue => 'Hết ngày hẹn nhận';

  @override
  String get holdNoticeBannerTitle => 'Giữ chỗ ngay khi gửi';

  @override
  String get holdNoticeBannerMessage =>
      '1 bản sẽ được giữ cho bạn. Bạn có thể hủy khi phiếu chưa chuyển sang Đang mượn.';

  @override
  String get submitBorrowRequestButton => 'Gửi yêu cầu mượn';

  @override
  String get borrowRequestSuccessMessage =>
      'Đã gửi yêu cầu. Thư viện đang giữ 1 bản cho bạn.';

  @override
  String get limitReachedBannerTitle => 'Bạn đã có 3 phiếu đang hoạt động';

  @override
  String get limitReachedBannerMessage =>
      'Hãy trả sách hoặc hủy một yêu cầu chưa nhận rồi thử lại.';

  @override
  String get limitReachedButton => 'Đã đạt giới hạn 3 phiếu';

  @override
  String get viewMyLoansButton => 'Xem phiếu của tôi';

  @override
  String get myLoansTitle => 'Phiếu mượn của tôi';

  @override
  String get loanHistoryTitle => 'Lịch sử mượn';

  @override
  String get filterActiveLoans => 'Đang hoạt động';

  @override
  String get filterLoanHistory => 'Lịch sử';

  @override
  String activeLoansSummary(int active, int max) {
    return '$active/$max phiếu đang hoạt động';
  }

  @override
  String pickupDateInline(String date) {
    return 'Hẹn nhận: $date';
  }

  @override
  String dueDateInline(String date) {
    return 'Hạn trả: $date';
  }

  @override
  String get trackLoansBannerTitle => 'Theo dõi phiếu tại đây';

  @override
  String get trackLoansBannerMessage =>
      'Sau khi được duyệt, mang mã phiếu đến quầy để nhận sách.';

  @override
  String get emptyLoansTitle => 'Chưa có phiếu mượn nào';

  @override
  String get emptyLoansSubtitle =>
      'Khám phá kệ sách và đăng ký mượn cuốn sách bạn yêu thích.';

  @override
  String get loanDetailTitle => 'Chi tiết phiếu';

  @override
  String get loanIdLabel => 'Mã phiếu';

  @override
  String get readerLabel => 'Độc giả';

  @override
  String get accountLabel => 'Tài khoản';

  @override
  String get createdAtLabel => 'Ngày đăng ký';

  @override
  String get pickupDateShortLabel => 'Hẹn nhận';

  @override
  String get borrowedAtLabel => 'Đã nhận sách';

  @override
  String get dueAtLabel => 'Hạn trả';

  @override
  String get newDueAtLabel => 'Hạn trả mới';

  @override
  String get returnedAtLabel => 'Đã trả';

  @override
  String get renewalLabel => 'Gia hạn';

  @override
  String renewalUsedValue(int count) {
    return 'Đã sử dụng $count/1 lần';
  }

  @override
  String get reasonLabel => 'Lý do';

  @override
  String get processedByLabel => 'Xử lý bởi';

  @override
  String get librarianRoleName => 'Thủ thư';

  @override
  String get readerRoleName => 'Độc giả';

  @override
  String get availableAfterProcessLabel => 'Khả dụng sau xử lý';

  @override
  String copiesCountValue(int count) {
    return '$count bản';
  }

  @override
  String get pendingBannerTitle => 'Đã giữ chỗ 1 bản';

  @override
  String get pendingBannerMessage => 'Yêu cầu đang chờ thủ thư duyệt.';

  @override
  String get readyBannerTitle => 'Sách đã sẵn sàng';

  @override
  String readyBannerMessage(String date, String loanId) {
    return 'Đến quầy nhận sách trong ngày $date. Mang theo mã phiếu $loanId.';
  }

  @override
  String borrowedBannerTitle(int days) {
    return 'Còn $days ngày để trả sách';
  }

  @override
  String get borrowedRenewableBannerMessage =>
      'Có thể gia hạn thêm 7 ngày, tối đa 1 lần.';

  @override
  String get borrowedDueSoonBannerMessage =>
      'Mang sách đến quầy thư viện trước hạn.';

  @override
  String get renewedBannerTitle => 'Đã gia hạn thành công';

  @override
  String renewedBannerMessage(String date) {
    return 'Hạn trả mới: $date.';
  }

  @override
  String overdueLoanBannerTitle(int days) {
    return 'Đã quá hạn trả $days ngày';
  }

  @override
  String get overdueLoanBannerMessage =>
      'Vui lòng mang sách đến quầy. Phiếu quá hạn không được gia hạn.';

  @override
  String get returnedBannerTitle => 'Đã hoàn tất';

  @override
  String get returnedBannerMessage =>
      'Thư viện đã ghi nhận sách trả. Cảm ơn bạn!';

  @override
  String get rejectedReaderBannerTitle => 'Yêu cầu chưa được chấp nhận';

  @override
  String get rejectedLibrarianBannerTitle => 'Đã từ chối yêu cầu';

  @override
  String rejectedBannerMessage(String reason) {
    return 'Lý do: $reason';
  }

  @override
  String get cancelledBannerTitle => 'Đã hủy yêu cầu';

  @override
  String get cancelledBannerMessage => 'Bản sách đã được trả lại thư viện.';

  @override
  String get expiredPickupBannerTitle => 'Đã hủy do quá hạn nhận';

  @override
  String get expiredPickupBannerMessage =>
      'Bạn chưa nhận sách trước khi hết ngày hẹn. Bản sách đã được trả lại kho.';

  @override
  String get cancelRequestButton => 'Hủy yêu cầu';

  @override
  String get cancelDialogTitle => 'Hủy yêu cầu mượn?';

  @override
  String cancelDialogMessage(String loanId) {
    return 'Phiếu $loanId sẽ được hủy. Bản sách đã giữ chỗ sẽ được trả về thư viện.';
  }

  @override
  String get keepLoanButton => 'Giữ lại phiếu';

  @override
  String get cancelSuccessMessage => 'Đã hủy yêu cầu.';

  @override
  String get renewLoanButton => 'Gia hạn thêm 7 ngày';

  @override
  String get renewDialogTitle => 'Gia hạn thêm 7 ngày?';

  @override
  String get currentDueLabel => 'Hạn hiện tại';

  @override
  String get newDueLabel => 'Hạn mới';

  @override
  String get renewDialogMessage =>
      'Mỗi phiếu được gia hạn 1 lần. Sau xác nhận, bạn không thể gia hạn lần nữa.';

  @override
  String get confirmRenewButton => 'Xác nhận gia hạn';

  @override
  String get laterButton => 'Để sau';

  @override
  String renewSuccessMessage(String date) {
    return 'Đã gia hạn đến $date.';
  }

  @override
  String get noRenewalsLeftButton => 'Đã hết lượt gia hạn';

  @override
  String get backToMyLoansButton => 'Về phiếu mượn';

  @override
  String get searchToRebookButton => 'Tra cứu để đặt lại';

  @override
  String get findOtherBooksButton => 'Tìm sách khác';

  @override
  String get exploreOtherBooksButton => 'Khám phá sách khác';

  @override
  String get scrollHintLargeText =>
      'Nội dung có thể cuộn khi bạn tăng kích thước chữ trên thiết bị.';

  @override
  String get reasonExpiredPickup => 'Quá hạn nhận';

  @override
  String get reasonReaderCancelled => 'Độc giả hủy yêu cầu';

  @override
  String get approveRequestButton => 'Duyệt yêu cầu';

  @override
  String get approveSuccessMessage => 'Đã duyệt phiếu.';

  @override
  String get rejectRequestButton => 'Từ chối yêu cầu';

  @override
  String get rejectDialogTitle => 'Từ chối yêu cầu';

  @override
  String get rejectDialogSubtitle =>
      'Cho độc giả biết lý do chưa thể mượn sách.';

  @override
  String get rejectReasonLabel => 'Lý do từ chối *';

  @override
  String get rejectReasonHint => 'Sách cần kiểm tra tình trạng.';

  @override
  String get confirmRejectButton => 'Xác nhận từ chối';

  @override
  String get rejectSuccessMessage => 'Đã từ chối yêu cầu.';

  @override
  String get confirmHandoverButton => 'Xác nhận đã giao sách';

  @override
  String get handoverDialogTitle => 'Đã giao sách cho độc giả?';

  @override
  String handoverDialogSubtitle(String reader, String book) {
    return 'Xác nhận khi $reader đã nhận 1 bản $book tại quầy.';
  }

  @override
  String get pickupTimeLabel => 'Ngày nhận';

  @override
  String get expectedDueDateLabel => 'Hạn trả dự kiến';

  @override
  String get confirmHandedOverButton => 'Đã giao sách';

  @override
  String get notHandedOverButton => 'Chưa giao';

  @override
  String get handoverSuccessMessage => 'Đã xác nhận giao sách.';

  @override
  String get confirmReturnButton => 'Xác nhận đã trả sách';

  @override
  String get returnDialogTitle => 'Đã nhận lại sách?';

  @override
  String returnDialogSubtitle(String book, String reader) {
    return 'Xác nhận khi thư viện đã nhận lại 1 bản $book từ $reader.';
  }

  @override
  String returnDialogMessage(String loanId) {
    return 'Phiếu $loanId sẽ chuyển sang Đã trả và tăng số bản khả dụng thêm 1.';
  }

  @override
  String get confirmReturnDialogButton => 'Xác nhận trả sách';

  @override
  String get notReturnedYetButton => 'Chưa nhận lại';

  @override
  String get returnSuccessMessage => 'Đã ghi nhận trả sách.';

  @override
  String get backToLoanListButton => 'Về danh sách phiếu';

  @override
  String get favoritesTitle => 'Sách yêu thích';

  @override
  String savedBooksCountLabel(int count) {
    return '$count cuốn sách đã lưu';
  }

  @override
  String get favoritesTapHint =>
      'Chạm vào sách để xem chi tiết hoặc bỏ yêu thích.';

  @override
  String get emptyFavoritesTitle => 'Kệ yêu thích còn trống';

  @override
  String get emptyFavoritesSubtitle =>
      'Chạm biểu tượng trái tim trong chi tiết sách để lưu những cuốn bạn muốn đọc.';

  @override
  String get exploreBooksButton => 'Khám phá sách';

  @override
  String get accountTitle => 'Cá nhân';

  @override
  String activeLoansSubtitle(int count) {
    return '$count phiếu đang hoạt động';
  }

  @override
  String get languageTitle => 'Ngôn ngữ';

  @override
  String get currentLanguageVietnamese => 'Tiếng Việt';

  @override
  String get currentLanguageEnglish => 'English';

  @override
  String get selectLanguageHeading => 'Chọn ngôn ngữ hiển thị';

  @override
  String get selectLanguageSubtitle =>
      'Áp dụng cho toàn bộ giao diện, thông báo và trạng thái phiếu.';

  @override
  String get inUseLabel => 'Đang sử dụng';

  @override
  String get switchToVietnameseSubtitle => 'Chuyển giao diện sang Tiếng Việt';

  @override
  String get switchToEnglishSubtitle => 'Switch interface to English';

  @override
  String get bookContentPreservedBannerTitle => 'Nội dung sách giữ nguyên';

  @override
  String get bookContentPreservedBannerMessage =>
      'Tên sách, tác giả và thông tin tài khoản không được dịch tự động.';

  @override
  String get teamInfoTitle => 'Thông tin nhóm';

  @override
  String get teamInfoSubtitleReader => 'Ứng dụng đặt mượn sách thư viện';

  @override
  String get teamInfoSubtitleLibrarian => 'Nhóm thực hiện ứng dụng';

  @override
  String get teamAppHeading => 'Ứng dụng đặt mượn\nsách thư viện';

  @override
  String get teamCourseSubtitle => 'Bài tập lớn · Lập trình thiết bị di động';

  @override
  String get member1Name => 'Vũ Xuân Minh';

  @override
  String get member1Info =>
      'MSSV: 24100363\nXây dựng trang chủ độc giả và thủ thư, tìm kiếm, lọc, xem chi tiết sách và quản lý danh mục sách.';

  @override
  String get member2Name => 'Lê Anh Quân';

  @override
  String get member2Info =>
      'MSSV: 23010580\nXây dựng đăng ký, đăng nhập, đăng xuất, thông tin cá nhân, đa ngôn ngữ và mô hình, kho dữ liệu dùng chung.';

  @override
  String get member3Name => 'Trần Hữu Kiên';

  @override
  String get member3Info =>
      'MSSV: 23010258\nXây dựng luồng đặt mượn, theo dõi, hủy, gia hạn, duyệt phiếu, giao–trả sách và quản lý sách yêu thích.';

  @override
  String get appVersionLabel => 'Phiên bản 1.0';

  @override
  String get librarianDeskTitle => 'Bàn thủ thư';

  @override
  String get librarianGreetingTitle => 'Chào thủ thư,';

  @override
  String get librarianGreetingSubtitle => 'Hôm nay cần xử lý gì?';

  @override
  String get metricBookTitles => 'Đầu sách';

  @override
  String get metricBorrowedCopies => 'Bản đang mượn';

  @override
  String get metricPendingRequests => 'Phiếu chờ duyệt';

  @override
  String get metricOverdueLoans => 'Phiếu quá hạn';

  @override
  String get recentRequestsTitle => 'Yêu cầu gần đây';

  @override
  String overdueLibrarianBannerTitle(int count) {
    return '$count sách đang quá hạn';
  }

  @override
  String get overdueLibrarianBannerMessage =>
      'Mở phiếu để kiểm tra thông tin độc giả.';

  @override
  String get bookManagementTitle => 'Quản lý sách';

  @override
  String get searchBookOrCodeHint => 'Tên sách hoặc mã sách';

  @override
  String get addBookButton => 'Thêm đầu sách';

  @override
  String get filterActiveBooks => 'Đang phục vụ';

  @override
  String get filterInactiveBooks => 'Ngừng phục vụ';

  @override
  String bookSummaryLine(String id, int total, int available) {
    return '$id · Tổng $total · Khả dụng $available';
  }

  @override
  String bookInactiveSummaryLine(String id) {
    return '$id · Ngừng phục vụ';
  }

  @override
  String get historyPreservedBannerTitle => 'Lịch sử được giữ nguyên';

  @override
  String get historyPreservedBannerMessage =>
      'Đầu sách ngừng phục vụ không xuất hiện trong danh sách đặt mượn của độc giả.';

  @override
  String get bookInfoTitle => 'Thông tin đầu sách';

  @override
  String get bookIdShortLabel => 'Mã sách';

  @override
  String get totalCopiesLabel => 'Tổng số bản';

  @override
  String get reservedCopiesLabel => 'Đang giữ chỗ';

  @override
  String get borrowedCopiesLabel => 'Đang mượn';

  @override
  String get availableCopiesLabel => 'Khả dụng';

  @override
  String get editBookButton => 'Chỉnh sửa đầu sách';

  @override
  String get deactivateBookButton => 'Ngừng phục vụ';

  @override
  String get activateBookButton => 'Mở phục vụ lại';

  @override
  String get deleteBookButton => 'Xóa đầu sách';

  @override
  String get activeLoansOnBookBannerTitle => 'Đang có phiếu hoạt động';

  @override
  String get activeLoansOnBookBannerMessage =>
      'Chỉ ngừng phục vụ hoặc xóa khi không còn phiếu Chờ duyệt, Chờ nhận, Đang mượn.';

  @override
  String get historyOnlyOnBookBannerTitle => 'Chỉ còn lịch sử mượn';

  @override
  String get historyOnlyOnBookBannerMessage =>
      'Có thể ngừng phục vụ để giữ nguyên lịch sử mượn.';

  @override
  String get cannotDeactivateDialogTitle => 'Chưa thể ngừng phục vụ';

  @override
  String cannotDeactivateDialogMessage(int count) {
    return 'Đầu sách này đang có $count phiếu hoạt động. Hãy hoàn tất hoặc hủy các phiếu hợp lệ trước.';
  }

  @override
  String get viewRelatedLoansButton => 'Xem phiếu liên quan';

  @override
  String get closeButton => 'Đóng';

  @override
  String get deactivateBookDialogTitle => 'Ngừng phục vụ đầu sách?';

  @override
  String get deactivateBookDialogMessage =>
      'Đầu sách đã có lịch sử mượn nên không thể xóa. Sau khi ngừng phục vụ, độc giả không thể đặt mượn mới; lịch sử vẫn được giữ.';

  @override
  String get deactivateSuccessMessage => 'Đã ngừng phục vụ đầu sách.';

  @override
  String deleteBookDialogTitle(String bookId) {
    return 'Xóa đầu sách $bookId?';
  }

  @override
  String get deleteBookDialogMessage =>
      'Đầu sách chưa từng xuất hiện trong phiếu mượn. Sau khi xóa, sách sẽ không còn trong danh mục.';

  @override
  String get keepBookButton => 'Giữ lại';

  @override
  String get deleteBookSuccessMessage => 'Đã xóa đầu sách.';

  @override
  String get addBookTitle => 'Thêm đầu sách';

  @override
  String get editBookTitle => 'Chỉnh sửa đầu sách';

  @override
  String get requiredFieldsNotice => 'Thông tin bắt buộc được đánh dấu *.';

  @override
  String get bookIdRequiredLabel => 'Mã đầu sách *';

  @override
  String get bookIdFixedLabel => 'Mã sách (cố định)';

  @override
  String get bookTitleRequiredLabel => 'Tên sách *';

  @override
  String get bookTitleHint => 'Nhập tên sách';

  @override
  String get authorRequiredLabel => 'Tác giả *';

  @override
  String get authorHint => 'Nhập tên tác giả';

  @override
  String get categoryRequiredLabel => 'Thể loại *';

  @override
  String get categoryHint => 'Chọn thể loại';

  @override
  String get totalCopiesRequiredLabel => 'Tổng số bản *';

  @override
  String get descriptionLabel => 'Mô tả';

  @override
  String get descriptionHint => 'Nhập giới thiệu ngắn';

  @override
  String get saveBookButton => 'Lưu đầu sách';

  @override
  String get saveChangesButton => 'Lưu thay đổi';

  @override
  String get saveBookSuccessMessage => 'Đã lưu thông tin đầu sách.';

  @override
  String get errorBookIdExists => 'Mã đầu sách đã tồn tại.';

  @override
  String get errorInvalidTotalCopies => 'Nhập số nguyên lớn hơn hoặc bằng 0.';

  @override
  String errorTotalCopiesBelowActive(int min, int reserved, int borrowed) {
    return 'Tối thiểu $min bản: đang giữ chỗ $reserved, đang mượn $borrowed.';
  }

  @override
  String get cannotSaveBookBannerTitle => 'Chưa thể lưu thay đổi';

  @override
  String get cannotSaveBookBannerMessage =>
      'Tổng số bản không được thấp hơn số bản đang giữ chỗ và đang mượn.';

  @override
  String get loanManagementTitle => 'Quản lý phiếu mượn';

  @override
  String get searchLoansHint => 'Mã phiếu, độc giả, tên sách';

  @override
  String get allLoansButton => 'Tất cả phiếu';
}
