import 'package:flutter/foundation.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/book.dart';
import '../../models/loan.dart';
import '../../models/loan_status.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/book_service.dart';
import '../../services/loan_service.dart';

class LibrarianViewModel extends ChangeNotifier {
  LibrarianViewModel(
    this._bookService,
    this._loanService,
    this._authService,
    this._userRepository,
  );

  final BookService _bookService;
  final LoanService _loanService;
  final AuthService _authService;
  final UserRepository _userRepository;

  int _selectedTabIndex = 0;
  String _bookSearchQuery = '';
  bool _showInactiveBooks = false;
  String _loanSearchQuery = '';
  LoanStatus? _loanStatusFilter;
  bool _onlyOverdueFilter = false;
  bool _isSubmitting = false;

  int get selectedTabIndex => _selectedTabIndex;

  String get bookSearchQuery => _bookSearchQuery;

  bool get showInactiveBooks => _showInactiveBooks;

  String get loanSearchQuery => _loanSearchQuery;

  LoanStatus? get loanStatusFilter => _loanStatusFilter;

  bool get onlyOverdueFilter => _onlyOverdueFilter;

  bool get isSubmitting => _isSubmitting;

  User? get currentUser => _authService.currentUser;

  void onDataStoreUpdated() {
    notifyListeners();
  }

  Future<void> runStartupChecks() async {
    await _loanService.cancelExpiredPickupsAsync();
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void openBooksTab({bool showInactive = false}) {
    _selectedTabIndex = 1;
    _showInactiveBooks = showInactive;
    notifyListeners();
  }

  void openLoansTab({
    LoanStatus? statusFilter,
    bool onlyOverdue = false,
    String? searchQuery,
  }) {
    _selectedTabIndex = 2;
    _loanStatusFilter = statusFilter;
    _onlyOverdueFilter = onlyOverdue;
    if (searchQuery != null) {
      _loanSearchQuery = searchQuery;
    }
    notifyListeners();
  }

  void setBookSearchQuery(String query) {
    _bookSearchQuery = query;
    notifyListeners();
  }

  void setShowInactiveBooks(bool showInactive) {
    _showInactiveBooks = showInactive;
    notifyListeners();
  }

  void setLoanSearchQuery(String query) {
    _loanSearchQuery = query;
    notifyListeners();
  }

  void setLoanStatusFilter(LoanStatus? status) {
    _loanStatusFilter = status;
    _onlyOverdueFilter = false;
    notifyListeners();
  }

  void setOnlyOverdueFilter(bool onlyOverdue) {
    _onlyOverdueFilter = onlyOverdue;
    if (onlyOverdue) {
      _loanStatusFilter = null;
    }
    notifyListeners();
  }

  void showAllLoans() {
    _loanStatusFilter = null;
    _onlyOverdueFilter = false;
    notifyListeners();
  }

  int get totalBookTitles => _bookService.getAllBooks().length;

  int get borrowedCopiesCount {
    return _loanService
        .getAllLoans()
        .where((loan) => loan.status == LoanStatus.borrowed)
        .length;
  }

  int get pendingRequestsCount {
    return _loanService
        .getAllLoans()
        .where((loan) => loan.status == LoanStatus.pending)
        .length;
  }

  List<Loan> get overdueLoans => _loanService.getOverdueLoans();

  int get overdueLoansCount => overdueLoans.length;

  List<Loan> get recentRequests {
    final all = _loanService.getAllLoans();
    final pending = all
        .where((loan) => loan.status == LoanStatus.pending)
        .toList();
    if (pending.isNotEmpty) {
      return pending.take(1).toList();
    }
    return all.take(1).toList();
  }

  List<Book> get filteredBooks {
    return _bookService.searchLibrarianBooks(
      query: _bookSearchQuery,
      isActive: !_showInactiveBooks,
    );
  }

  List<Loan> get filteredLoans {
    return _loanService.searchLibrarianLoans(
      query: _loanSearchQuery,
      statusFilter: _loanStatusFilter,
      onlyOverdue: _onlyOverdueFilter,
    );
  }

  Book? findBookById(String bookId) => _bookService.findById(bookId);

  Loan? findLoanById(String loanId) => _loanService.findById(loanId);

  User? findUserById(String userId) =>
      _userRepository.findById(userId);

  int reservedCopies(String bookId) =>
      _bookService.reservedCount(bookId);

  int borrowedCopies(String bookId) =>
      _bookService.borrowedCount(bookId);

  int activeLoanCountForBook(String bookId) =>
      _bookService.activeLoanCount(bookId);

  int availableCopies(String bookId) =>
      _bookService.availableCopies(bookId);

  bool hasLoanHistory(String bookId) =>
      _bookService.hasLoanHistory(bookId);

  String generateNextBookId() => _bookService.generateNextBookId();

  List<String> get categories {
    final existing = _bookService.getCategories();
    if (existing.isEmpty) {
      return const <String>['Văn học', 'Khoa học'];
    }
    return existing;
  }

  bool isOverdue(Loan loan) => _loanService.isOverdue(loan);

  int daysUntilDue(Loan loan) => _loanService.daysUntilDue(loan);

  int overdueDays(Loan loan) => _loanService.overdueDays(loan);

  Future<Book> createBook({
    required String id,
    required String title,
    required String author,
    required String category,
    required int totalCopies,
    String description = '',
    String? coverAsset,
  }) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final created = await _bookService.createBookAsync(
        actor: actor,
        id: id,
        title: title,
        author: author,
        category: category,
        totalCopies: totalCopies,
        description: description,
        coverAsset: coverAsset,
      );
      _isSubmitting = false;
      notifyListeners();
      return created;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Book> updateBook({
    required String id,
    required String title,
    required String author,
    required String category,
    required int totalCopies,
    String description = '',
    String? coverAsset,
    bool? isActive,
  }) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _bookService.updateBookAsync(
        actor: actor,
        id: id,
        title: title,
        author: author,
        category: category,
        totalCopies: totalCopies,
        description: description,
        coverAsset: coverAsset,
        isActive: isActive,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Book> deactivateBook(String bookId) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _bookService.deactivateBookAsync(
        actor: actor,
        bookId: bookId,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Book> activateBook(String bookId) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _bookService.activateBookAsync(
        actor: actor,
        bookId: bookId,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBook(String bookId) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      await _bookService.deleteBookAsync(
        actor: actor,
        bookId: bookId,
      );
      _isSubmitting = false;
      notifyListeners();
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Loan> approveLoan(String loanId) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _loanService.approveRequestAsync(
        actor: actor,
        loanId: loanId,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Loan> rejectLoan({
    required String loanId,
    required String reason,
  }) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _loanService.rejectRequestAsync(
        actor: actor,
        loanId: loanId,
        reason: reason,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Loan> confirmHandover(String loanId) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _loanService.confirmHandoverAsync(
        actor: actor,
        loanId: loanId,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Loan> confirmReturn(String loanId) async {
    final actor = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _loanService.confirmReturnAsync(
        actor: actor,
        loanId: loanId,
      );
      _isSubmitting = false;
      notifyListeners();
      return updated;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }
}
