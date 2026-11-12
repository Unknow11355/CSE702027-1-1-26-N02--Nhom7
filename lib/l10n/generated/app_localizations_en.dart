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
  String get welcomeTitle => 'Welcome to the library';

  @override
  String get welcomeDescription =>
      'Browse books, reserve a copy, and track your loans.';

  @override
  String get welcomeHeadline => 'Your next book\nis waiting for you.';

  @override
  String get welcomeSubtitle =>
      'Search and reserve on the app.\nPick up and return books at the library.';

  @override
  String get changeLanguage => 'Change language';

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
  String get librarianAccountNotice =>
      'Librarian accounts are issued by the library.';

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

  @override
  String get navExplore => 'Explore';

  @override
  String get navMyLoans => 'My loans';

  @override
  String get navFavorites => 'Saved';

  @override
  String get navAccount => 'Account';

  @override
  String get navOverview => 'Overview';

  @override
  String get navBooks => 'Books';

  @override
  String get navLoans => 'Loans';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryLiterature => 'Literature';

  @override
  String get categoryScience => 'Science';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusReadyForPickup => 'Ready for pickup';

  @override
  String get statusBorrowed => 'Borrowed';

  @override
  String get statusReturned => 'Returned';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String readerGreeting(String name) {
    return 'Hi $name,\nwhat will you read today?';
  }

  @override
  String get searchBooksHint => 'Search book titles...';

  @override
  String get searchBooksTitle => 'Search books';

  @override
  String dueSoonBannerTitle(int count) {
    return '$count book is due soon';
  }

  @override
  String overdueBannerReaderTitle(int count) {
    return '$count book is overdue';
  }

  @override
  String dueSoonBannerSubtitle(String title, int days) {
    return '$title · $days days left';
  }

  @override
  String overdueBannerReaderSubtitle(String title, int days) {
    return '$title · $days days overdue';
  }

  @override
  String get exploreShelvesTitle => 'Explore the shelves';

  @override
  String get viewAllButton => 'View all';

  @override
  String get suggestedForYouTitle => 'You might also like';

  @override
  String copiesAvailableShort(int available) {
    return '$available copies available';
  }

  @override
  String copiesRatioLabel(int available, int total) {
    return '$available/$total copies available';
  }

  @override
  String get outOfCopiesLabel => 'No copies available';

  @override
  String bookCountLabel(int count) {
    return '$count book titles';
  }

  @override
  String get noBooksFoundTitle => 'No matching books found';

  @override
  String get noBooksFoundSubtitle =>
      'Try a shorter keyword or clear the category filter.';

  @override
  String get clearFiltersButton => 'Clear filters';

  @override
  String get bookDetailTitle => 'Book details';

  @override
  String bookIdPrefix(String id) {
    return 'Book ID $id';
  }

  @override
  String get aboutBookSection => 'About';

  @override
  String get detailInfoSection => 'Details';

  @override
  String get formatLabel => 'Format';

  @override
  String get formatPhysicalBook => 'Physical book';

  @override
  String get loanDurationLabel => 'Loan duration';

  @override
  String get loanDurationValue => '7 days from pickup';

  @override
  String get perLoanLabel => 'Per loan';

  @override
  String get perLoanValue => '1 copy';

  @override
  String get requestBorrowButton => 'Reserve copy';

  @override
  String get outOfStockButton => 'Out of stock';

  @override
  String get addToFavoritesButton => 'Add to saved';

  @override
  String get removeFromFavoritesButton => 'Remove from saved';

  @override
  String get outOfCopiesBannerTitle => 'No copies available right now';

  @override
  String get outOfCopiesBannerMessage =>
      'You can save this book and check back later.';

  @override
  String get duplicateActiveLoanBannerTitle =>
      'You already have an active loan for this book';

  @override
  String duplicateActiveLoanBannerMessage(String loanId, String status) {
    return 'Loan $loanId is $status. Cannot create another request for the same book.';
  }

  @override
  String viewLoanButton(String loanId) {
    return 'View loan $loanId';
  }

  @override
  String get alreadyHasActiveLoanButton => 'Active loan exists';

  @override
  String get favoriteAddedMessage => 'Added to saved books.';

  @override
  String get favoriteRemovedMessage => 'Removed from saved books.';

  @override
  String get borrowRequestTitle => 'Reserve copy';

  @override
  String get oneCopyCounterPickup => '1 copy · counter pickup';

  @override
  String get pickupDateLabel => 'Pickup date';

  @override
  String get pickupDateHelper => 'Choose from today up to 7 days ahead.';

  @override
  String get selectPickupDateTooltip => 'Select pickup date';

  @override
  String get datePickerHelpText => 'SELECT PICKUP DATE';

  @override
  String get datePickerCancelButton => 'Cancel';

  @override
  String get datePickerConfirmButton => 'Select date';

  @override
  String get activeLoansCountLabel => 'Active loans';

  @override
  String get activeLoansShortLabel => 'Active loans';

  @override
  String activeLoansRatioValue(int active, int max) {
    return '$active/$max loans';
  }

  @override
  String get loanDurationFromPickupValue => '7 days from pickup';

  @override
  String get holdDeadlineLabel => 'Hold expires';

  @override
  String get holdDeadlineValue => 'End of pickup date';

  @override
  String get holdNoticeBannerTitle => 'Copy held upon request';

  @override
  String get holdNoticeBannerMessage =>
      '1 copy will be held for you. You can cancel before the loan is marked as Borrowed.';

  @override
  String get submitBorrowRequestButton => 'Submit request';

  @override
  String get borrowRequestSuccessMessage =>
      'Request submitted. The library is holding 1 copy for you.';

  @override
  String get limitReachedBannerTitle => 'You already have 3 active loans';

  @override
  String get limitReachedBannerMessage =>
      'Return a book or cancel an uncollected request and try again.';

  @override
  String get limitReachedButton => '3-loan limit reached';

  @override
  String get viewMyLoansButton => 'View my loans';

  @override
  String get myLoansTitle => 'My loans';

  @override
  String get loanHistoryTitle => 'Loan history';

  @override
  String get filterActiveLoans => 'Active';

  @override
  String get filterLoanHistory => 'History';

  @override
  String activeLoansSummary(int active, int max) {
    return '$active/$max active loans';
  }

  @override
  String pickupDateInline(String date) {
    return 'Pickup: $date';
  }

  @override
  String dueDateInline(String date) {
    return 'Due: $date';
  }

  @override
  String get trackLoansBannerTitle => 'Track your loans here';

  @override
  String get trackLoansBannerMessage =>
      'Once approved, bring the loan ID to the counter to pick up your book.';

  @override
  String get emptyLoansTitle => 'No loans yet';

  @override
  String get emptyLoansSubtitle =>
      'Browse the shelves and reserve a book you like.';

  @override
  String get loanDetailTitle => 'Loan details';

  @override
  String get loanIdLabel => 'Loan ID';

  @override
  String get readerLabel => 'Reader';

  @override
  String get accountLabel => 'Account';

  @override
  String get createdAtLabel => 'Requested on';

  @override
  String get pickupDateShortLabel => 'Pickup date';

  @override
  String get borrowedAtLabel => 'Picked up on';

  @override
  String get dueAtLabel => 'Due date';

  @override
  String get newDueAtLabel => 'New due date';

  @override
  String get returnedAtLabel => 'Returned on';

  @override
  String get renewalLabel => 'Renewal';

  @override
  String renewalUsedValue(int count) {
    return 'Used $count/1 time';
  }

  @override
  String get reasonLabel => 'Reason';

  @override
  String get processedByLabel => 'Processed by';

  @override
  String get librarianRoleName => 'Librarian';

  @override
  String get readerRoleName => 'Reader';

  @override
  String get availableAfterProcessLabel => 'Available after processing';

  @override
  String copiesCountValue(int count) {
    return '$count copies';
  }

  @override
  String get pendingBannerTitle => '1 copy held';

  @override
  String get pendingBannerMessage =>
      'Your request is waiting for librarian approval.';

  @override
  String get readyBannerTitle => 'Book is ready for pickup';

  @override
  String readyBannerMessage(String date, String loanId) {
    return 'Pick up at the counter by $date. Bring loan ID $loanId.';
  }

  @override
  String borrowedBannerTitle(int days) {
    return '$days days left to return';
  }

  @override
  String get borrowedRenewableBannerMessage =>
      'Can be renewed for 7 more days, up to 1 time.';

  @override
  String get borrowedDueSoonBannerMessage =>
      'Please return the book to the counter before the due date.';

  @override
  String get renewedBannerTitle => 'Renewed successfully';

  @override
  String renewedBannerMessage(String date) {
    return 'New due date: $date.';
  }

  @override
  String overdueLoanBannerTitle(int days) {
    return 'Overdue by $days days';
  }

  @override
  String get overdueLoanBannerMessage =>
      'Please return the book to the counter. Overdue loans cannot be renewed.';

  @override
  String get returnedBannerTitle => 'Completed';

  @override
  String get returnedBannerMessage =>
      'The library has recorded the book return. Thank you!';

  @override
  String get rejectedReaderBannerTitle => 'Request not approved';

  @override
  String get rejectedLibrarianBannerTitle => 'Request rejected';

  @override
  String rejectedBannerMessage(String reason) {
    return 'Reason: $reason';
  }

  @override
  String get cancelledBannerTitle => 'Request cancelled';

  @override
  String get cancelledBannerMessage =>
      'The held copy has been returned to the library.';

  @override
  String get expiredPickupBannerTitle => 'Cancelled due to expired pickup';

  @override
  String get expiredPickupBannerMessage =>
      'You did not pick up the book before the pickup date ended. The copy was returned to stock.';

  @override
  String get cancelRequestButton => 'Cancel request';

  @override
  String get cancelDialogTitle => 'Cancel borrow request?';

  @override
  String cancelDialogMessage(String loanId) {
    return 'Loan $loanId will be cancelled. The held copy will be returned to the library.';
  }

  @override
  String get keepLoanButton => 'Keep loan';

  @override
  String get cancelSuccessMessage => 'Request cancelled.';

  @override
  String get renewLoanButton => 'Renew for 7 days';

  @override
  String get renewDialogTitle => 'Renew for 7 more days?';

  @override
  String get currentDueLabel => 'Current due date';

  @override
  String get newDueLabel => 'New due date';

  @override
  String get renewDialogMessage =>
      'Each loan can be renewed once. After confirmation, you cannot renew again.';

  @override
  String get confirmRenewButton => 'Confirm renewal';

  @override
  String get laterButton => 'Later';

  @override
  String renewSuccessMessage(String date) {
    return 'Renewed until $date.';
  }

  @override
  String get noRenewalsLeftButton => 'No renewals left';

  @override
  String get backToMyLoansButton => 'Back to my loans';

  @override
  String get searchToRebookButton => 'Search to reserve again';

  @override
  String get findOtherBooksButton => 'Find other books';

  @override
  String get exploreOtherBooksButton => 'Explore other books';

  @override
  String get scrollHintLargeText =>
      'Content can scroll when you increase device text size.';

  @override
  String get reasonExpiredPickup => 'Expired pickup';

  @override
  String get reasonReaderCancelled => 'Cancelled by reader';

  @override
  String get approveRequestButton => 'Approve request';

  @override
  String get approveSuccessMessage => 'Request approved.';

  @override
  String get rejectRequestButton => 'Reject request';

  @override
  String get rejectDialogTitle => 'Reject request';

  @override
  String get rejectDialogSubtitle =>
      'Let the reader know why the book cannot be borrowed.';

  @override
  String get rejectReasonLabel => 'Rejection reason *';

  @override
  String get rejectReasonHint => 'Book needs condition check.';

  @override
  String get confirmRejectButton => 'Confirm rejection';

  @override
  String get rejectSuccessMessage => 'Request rejected.';

  @override
  String get confirmHandoverButton => 'Confirm book handover';

  @override
  String get handoverDialogTitle => 'Handed over book to reader?';

  @override
  String handoverDialogSubtitle(String reader, String book) {
    return 'Confirm when $reader has picked up 1 copy of $book at the counter.';
  }

  @override
  String get pickupTimeLabel => 'Pickup time';

  @override
  String get expectedDueDateLabel => 'Expected due date';

  @override
  String get confirmHandedOverButton => 'Handed over';

  @override
  String get notHandedOverButton => 'Not yet';

  @override
  String get handoverSuccessMessage => 'Book handover confirmed.';

  @override
  String get confirmReturnButton => 'Confirm book return';

  @override
  String get returnDialogTitle => 'Received book back?';

  @override
  String returnDialogSubtitle(String book, String reader) {
    return 'Confirm when the library has received 1 copy of $book from $reader.';
  }

  @override
  String returnDialogMessage(String loanId) {
    return 'Loan $loanId will be marked as Returned and available copies will increase by 1.';
  }

  @override
  String get confirmReturnDialogButton => 'Confirm return';

  @override
  String get notReturnedYetButton => 'Not yet';

  @override
  String get returnSuccessMessage => 'Book return recorded.';

  @override
  String get backToLoanListButton => 'Back to loan list';

  @override
  String get favoritesTitle => 'Saved books';

  @override
  String savedBooksCountLabel(int count) {
    return '$count saved books';
  }

  @override
  String get favoritesTapHint =>
      'Tap a book to view details or remove from saved.';

  @override
  String get emptyFavoritesTitle => 'Your saved shelf is empty';

  @override
  String get emptyFavoritesSubtitle =>
      'Tap the heart icon in book details to save books you want to read.';

  @override
  String get exploreBooksButton => 'Explore books';

  @override
  String get accountTitle => 'Account';

  @override
  String activeLoansSubtitle(int count) {
    return '$count active loans';
  }

  @override
  String get languageTitle => 'Language';

  @override
  String get currentLanguageVietnamese => 'Tiếng Việt';

  @override
  String get currentLanguageEnglish => 'English';

  @override
  String get selectLanguageHeading => 'Select display language';

  @override
  String get selectLanguageSubtitle =>
      'Applies to the entire interface, notifications, and loan statuses.';

  @override
  String get inUseLabel => 'Currently in use';

  @override
  String get switchToVietnameseSubtitle => 'Chuyển giao diện sang Tiếng Việt';

  @override
  String get switchToEnglishSubtitle => 'Switch interface to English';

  @override
  String get bookContentPreservedBannerTitle => 'Book content unchanged';

  @override
  String get bookContentPreservedBannerMessage =>
      'Book titles, authors, and account details are not automatically translated.';

  @override
  String get teamInfoTitle => 'Team info';

  @override
  String get teamInfoSubtitleReader => 'Library book reservation app';

  @override
  String get teamInfoSubtitleLibrarian => 'Application development team';

  @override
  String get teamAppHeading => 'Library Book\nReservation App';

  @override
  String get teamCourseSubtitle =>
      'Course Project · Mobile Application Development';

  @override
  String get member1Name => 'Vũ Xuân Minh';

  @override
  String get member1Info =>
      'Student ID: 24100363\nDeveloped reader and librarian home screens, search, filtering, book details, and book catalog management.';

  @override
  String get member2Name => 'Lê Anh Quân';

  @override
  String get member2Info =>
      'Student ID: 23010580\nDeveloped registration, login, logout, personal profile, localization, models, and shared data store.';

  @override
  String get member3Name => 'Trần Hữu Kiên';

  @override
  String get member3Info =>
      'Student ID: 23010258\nDeveloped borrowing, tracking, cancellation, renewal, loan approval, book handover/return flows, and favorites management.';

  @override
  String get appVersionLabel => 'Version 1.0';

  @override
  String get librarianDeskTitle => 'Librarian desk';

  @override
  String get librarianGreetingTitle => 'Welcome back,';

  @override
  String get librarianGreetingSubtitle => 'What needs attention?';

  @override
  String get metricBookTitles => 'Book titles';

  @override
  String get metricBorrowedCopies => 'Borrowed copies';

  @override
  String get metricPendingRequests => 'Pending requests';

  @override
  String get metricOverdueLoans => 'Overdue loans';

  @override
  String get recentRequestsTitle => 'Recent requests';

  @override
  String overdueLibrarianBannerTitle(int count) {
    return '$count loan is overdue';
  }

  @override
  String get overdueLibrarianBannerMessage =>
      'Open the loan to view reader details.';

  @override
  String get bookManagementTitle => 'Book management';

  @override
  String get searchBookOrCodeHint => 'Book title or book ID';

  @override
  String get addBookButton => 'Add book title';

  @override
  String get filterActiveBooks => 'Active';

  @override
  String get filterInactiveBooks => 'Inactive';

  @override
  String bookSummaryLine(String id, int total, int available) {
    return '$id · Total $total · Available $available';
  }

  @override
  String bookInactiveSummaryLine(String id) {
    return '$id · Inactive';
  }

  @override
  String get historyPreservedBannerTitle => 'Loan history preserved';

  @override
  String get historyPreservedBannerMessage =>
      'Inactive book titles do not appear in the reader\'s reservation list.';

  @override
  String get bookInfoTitle => 'Book information';

  @override
  String get bookIdShortLabel => 'Book ID';

  @override
  String get totalCopiesLabel => 'Total copies';

  @override
  String get reservedCopiesLabel => 'Reserved';

  @override
  String get borrowedCopiesLabel => 'Borrowed';

  @override
  String get availableCopiesLabel => 'Available';

  @override
  String get editBookButton => 'Edit book title';

  @override
  String get deactivateBookButton => 'Deactivate';

  @override
  String get activateBookButton => 'Reactivate';

  @override
  String get deleteBookButton => 'Delete book title';

  @override
  String get activeLoansOnBookBannerTitle => 'Active loans exist';

  @override
  String get activeLoansOnBookBannerMessage =>
      'Can only deactivate or delete when there are no Pending, Ready, or Borrowed loans.';

  @override
  String get historyOnlyOnBookBannerTitle => 'Loan history exists';

  @override
  String get historyOnlyOnBookBannerMessage =>
      'You can deactivate this book to preserve loan history.';

  @override
  String get cannotDeactivateDialogTitle => 'Cannot deactivate yet';

  @override
  String cannotDeactivateDialogMessage(int count) {
    return 'This book currently has $count active loans. Please complete or cancel them first.';
  }

  @override
  String get viewRelatedLoansButton => 'View related loans';

  @override
  String get closeButton => 'Close';

  @override
  String get deactivateBookDialogTitle => 'Deactivate book title?';

  @override
  String get deactivateBookDialogMessage =>
      'This book has loan history and cannot be deleted. Once deactivated, readers cannot create new requests; history is preserved.';

  @override
  String get deactivateSuccessMessage => 'Book title deactivated.';

  @override
  String deleteBookDialogTitle(String bookId) {
    return 'Delete book title $bookId?';
  }

  @override
  String get deleteBookDialogMessage =>
      'This book has never been referenced in any loan. After deletion, it will be removed from the catalog.';

  @override
  String get keepBookButton => 'Keep';

  @override
  String get deleteBookSuccessMessage => 'Book title deleted.';

  @override
  String get addBookTitle => 'Add book title';

  @override
  String get editBookTitle => 'Edit book title';

  @override
  String get requiredFieldsNotice => 'Required fields are marked with *.';

  @override
  String get bookIdRequiredLabel => 'Book ID *';

  @override
  String get bookIdFixedLabel => 'Book ID (fixed)';

  @override
  String get bookTitleRequiredLabel => 'Book title *';

  @override
  String get bookTitleHint => 'Enter book title';

  @override
  String get authorRequiredLabel => 'Author *';

  @override
  String get authorHint => 'Enter author name';

  @override
  String get categoryRequiredLabel => 'Category *';

  @override
  String get categoryHint => 'Select category';

  @override
  String get totalCopiesRequiredLabel => 'Total copies *';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get descriptionHint => 'Enter short description';

  @override
  String get saveBookButton => 'Save book title';

  @override
  String get saveChangesButton => 'Save changes';

  @override
  String get saveBookSuccessMessage => 'Book information saved.';

  @override
  String get errorBookIdExists => 'Book ID already exists.';

  @override
  String get errorInvalidTotalCopies =>
      'Enter an integer greater than or equal to 0.';

  @override
  String errorTotalCopiesBelowActive(int min, int reserved, int borrowed) {
    return 'Minimum $min copies: $reserved reserved, $borrowed borrowed.';
  }

  @override
  String get cannotSaveBookBannerTitle => 'Unable to save changes';

  @override
  String get cannotSaveBookBannerMessage =>
      'Total copies cannot be less than reserved and borrowed copies.';

  @override
  String get loanManagementTitle => 'Loan management';

  @override
  String get searchLoansHint => 'Loan ID, reader, book title';

  @override
  String get allLoansButton => 'All loans';
}
