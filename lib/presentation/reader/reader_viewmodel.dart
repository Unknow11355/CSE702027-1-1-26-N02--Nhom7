import 'package:flutter/foundation.dart';

import '../../data/repositories/user_repository.dart';
import '../../models/book.dart';
import '../../models/loan.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/book_service.dart';
import '../../services/loan_service.dart';

class ReaderViewModel extends ChangeNotifier {
  ReaderViewModel(
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
  bool _isSearchMode = false;
  String _searchQuery = '';
  String? _selectedCategory;
  bool _showLoanHistory = false;
  bool _isSubmitting = false;

  int get selectedTabIndex => _selectedTabIndex;

  bool get isSearchMode => _isSearchMode;

  String get searchQuery => _searchQuery;

  String? get selectedCategory => _selectedCategory;

  bool get showLoanHistory => _showLoanHistory;

  bool get isSubmitting => _isSubmitting;

  User? get currentUser => _authService.currentUser;

  String get readerShortName {
    final fullName = currentUser?.fullName.trim() ?? '';
    if (fullName.isEmpty) {
      return '';
    }
    final parts = fullName.split(RegExp(r'\s+'));
    return parts.last;
  }

  void onDataStoreUpdated() {
    notifyListeners();
  }

  Future<void> runStartupChecks() async {
    await _loanService.cancelExpiredPickupsAsync();
  }

  void setTabIndex(int index) {
    if (_selectedTabIndex == index && index == 0 && _isSearchMode) {
      _isSearchMode = false;
      _searchQuery = '';
      _selectedCategory = null;
      notifyListeners();
      return;
    }
    _selectedTabIndex = index;
    notifyListeners();
  }

  void openSearch({
    String? initialQuery,
    String? category,
  }) {
    _selectedTabIndex = 0;
    _isSearchMode = true;
    if (initialQuery != null) {
      _searchQuery = initialQuery;
    }
    if (category != null) {
      _selectedCategory = category;
    }
    notifyListeners();
  }

  void closeSearch() {
    _isSearchMode = false;
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    if (query.trim().isNotEmpty) {
      _isSearchMode = true;
    }
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    if (category != null) {
      _isSearchMode = true;
    }
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    notifyListeners();
  }

  void setShowLoanHistory(bool showHistory) {
    _showLoanHistory = showHistory;
    notifyListeners();
  }

  List<Book> get activeBooks {
    return _bookService.searchReaderBooks();
  }

  List<Book> get filteredBooks {
    return _bookService.searchReaderBooks(
      query: _searchQuery,
      category: _selectedCategory,
    );
  }

  List<Book> get shelfBooks {
    final books = activeBooks;
    if (books.length <= 2) {
      return books;
    }
    return books.sublist(0, 2);
  }

  List<Book> get suggestedBooks {
    final books = activeBooks;
    final scienceBooks = books
        .where((book) => book.category == 'Khoa học')
        .toList();
    if (scienceBooks.isNotEmpty) {
      return scienceBooks;
    }
    if (books.length > 2) {
      return books.sublist(2);
    }
    return books;
  }

  Book? findBookById(String bookId) {
    return _bookService.findById(bookId);
  }

  User? findUserById(String userId) {
    return _userRepository.findById(userId);
  }

  int availableCopies(String bookId) {
    return _bookService.availableCopies(bookId);
  }

  bool isFavorite(String bookId) {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    return _bookService.isFavorite(
      userId: user.id,
      bookId: bookId,
    );
  }

  List<Book> get favoriteBooks {
    final user = currentUser;
    if (user == null) {
      return const <Book>[];
    }
    return _bookService.getFavoriteBooks(user.id);
  }

  bool toggleFavorite(String bookId) {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final isNowFavorite = _bookService.toggleFavorite(
      userId: user.id,
      bookId: bookId,
    );
    notifyListeners();
    return isNowFavorite;
  }

  List<Loan> get activeLoans {
    final user = currentUser;
    if (user == null) {
      return const <Loan>[];
    }
    return _loanService.getUserActiveLoans(user.id);
  }

  List<Loan> get historyLoans {
    final user = currentUser;
    if (user == null) {
      return const <Loan>[];
    }
    return _loanService.getUserHistoryLoans(user.id);
  }

  int get activeLoanCount => activeLoans.length;

  List<Loan> get dueSoonOrOverdueLoans {
    final user = currentUser;
    if (user == null) {
      return const <Loan>[];
    }
    return _loanService.getUserDueSoonOrOverdueLoans(user.id);
  }

  Loan? findLoanById(String loanId) {
    return _loanService.findById(loanId);
  }

  Loan? activeLoanForBook(String bookId) {
    final user = currentUser;
    if (user == null) {
      return null;
    }
    return _loanService.findActiveLoanForUserAndBook(
      userId: user.id,
      bookId: bookId,
    );
  }

  bool isOverdue(Loan loan) => _loanService.isOverdue(loan);

  int daysUntilDue(Loan loan) => _loanService.daysUntilDue(loan);

  int overdueDays(Loan loan) => _loanService.overdueDays(loan);

  bool canCancel(Loan loan) {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    return _loanService.canCancel(
      loan: loan,
      user: user,
    );
  }

  bool canRenew(Loan loan) {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    return _loanService.canRenew(
      loan: loan,
      user: user,
    );
  }

  Future<Loan> createBorrowRequest({
    required String bookId,
    required DateTime pickupDate,
  }) async {
    final user = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final loan = await _loanService.createRequestAsync(
        actor: user,
        bookId: bookId,
        pickupDate: pickupDate,
      );
      _isSubmitting = false;
      notifyListeners();
      return loan;
    } catch (_) {
      _isSubmitting = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Loan> cancelLoan(String loanId) async {
    final user = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _loanService.cancelRequestAsync(
        actor: user,
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

  Future<Loan> renewLoan(String loanId) async {
    final user = currentUser!;
    _isSubmitting = true;
    notifyListeners();

    try {
      final updated = await _loanService.renewLoanAsync(
        actor: user,
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
