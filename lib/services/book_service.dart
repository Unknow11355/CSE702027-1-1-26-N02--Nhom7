// Bước 22: Thêm màn hình chi tiết sách và số bản khả dụng
import '../core/app_exception.dart';
import '../data/repositories/book_repository.dart';
import '../data/repositories/favorite_repository.dart';
import '../data/repositories/loan_repository.dart';
import '../models/book.dart';
import '../models/favorite.dart';
import '../models/loan_status.dart';
import '../models/user.dart';
import '../models/user_role.dart';

class BookService {
  const BookService(
    this._bookRepository,
    this._loanRepository,
    this._favoriteRepository,
  );

  final BookRepository _bookRepository;
  final LoanRepository _loanRepository;
  final FavoriteRepository _favoriteRepository;

  List<Book> getAllBooks() => _bookRepository.getAll();

  Book? findById(String bookId) => _bookRepository.findById(bookId);

  int reservedCount(String bookId) {
    final loans = _loanRepository.findByBookId(bookId);
    return loans
        .where(
          (loan) =>
              loan.status == LoanStatus.pending ||
              loan.status == LoanStatus.readyForPickup,
        )
        .length;
  }

  int borrowedCount(String bookId) {
    final loans = _loanRepository.findByBookId(bookId);
    return loans
        .where((loan) => loan.status == LoanStatus.borrowed)
        .length;
  }

  int activeLoanCount(String bookId) {
    return reservedCount(bookId) + borrowedCount(bookId);
  }

  int availableCopies(String bookId) {
    final book = _bookRepository.findById(bookId);
    if (book == null) {
      return 0;
    }
    final available = book.totalCopies - activeLoanCount(bookId);
    if (available < 0) {
      return 0;
    }
    if (available > book.totalCopies) {
      return book.totalCopies;
    }
    return available;
  }

  bool hasLoanHistory(String bookId) {
    return _loanRepository.findByBookId(bookId).isNotEmpty;
  }

  List<String> getCategories() {
    final categories = <String>{};
    for (final book in _bookRepository.getAll()) {
      if (book.category.trim().isNotEmpty) {
        categories.add(book.category.trim());
      }
    }
    return categories.toList(growable: false);
  }

  List<Book> searchReaderBooks({
    String query = '',
    String? category,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedCategory = category?.trim();

    return _bookRepository.getAll().where((book) {
      if (!book.isActive) {
        return false;
      }
      if (normalizedCategory != null &&
          normalizedCategory.isNotEmpty &&
          book.category != normalizedCategory) {
        return false;
      }
      if (normalizedQuery.isEmpty) {
        return true;
      }
      return book.title.toLowerCase().contains(normalizedQuery) ||
          book.author.toLowerCase().contains(normalizedQuery) ||
          book.category.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  List<Book> searchLibrarianBooks({
    String query = '',
    required bool isActive,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return _bookRepository.getAll().where((book) {
      if (book.isActive != isActive) {
        return false;
      }
      if (normalizedQuery.isEmpty) {
        return true;
      }
      return book.title.toLowerCase().contains(normalizedQuery) ||
          book.id.toLowerCase().contains(normalizedQuery) ||
          book.author.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  bool isFavorite({
    required String userId,
    required String bookId,
  }) {
    return _favoriteRepository.isFavorite(
      userId: userId,
      bookId: bookId,
    );
  }

  List<Book> getFavoriteBooks(String userId) {
    final favorites = _favoriteRepository.getByUserId(userId);
    final result = <Book>[];
    for (final favorite in favorites) {
      final book = _bookRepository.findById(favorite.bookId);
      if (book != null && book.isActive) {
        result.add(book);
      }
    }
    return result;
  }

  bool toggleFavorite({
    required String userId,
    required String bookId,
  }) {
    final currentlyFavorite = _favoriteRepository.isFavorite(
      userId: userId,
      bookId: bookId,
    );
    if (currentlyFavorite) {
      _favoriteRepository.remove(
        userId: userId,
        bookId: bookId,
      );
      return false;
    }
    _favoriteRepository.add(
      Favorite(
        userId: userId,
        bookId: bookId,
      ),
    );
    return true;
  }

  String generateNextBookId() {
    var maxNum = 0;
    for (final book in _bookRepository.getAll()) {
      final raw = book.id.toUpperCase().replaceFirst('B', '');
      final parsed = int.tryParse(raw);
      if (parsed != null && parsed > maxNum) {
        maxNum = parsed;
      }
    }
    final nextNum = maxNum + 1;
    return 'B${nextNum.toString().padLeft(3, '0')}';
  }

  Book createBook({
    required User actor,
    required String id,
    required String title,
    required String author,
    required String category,
    required int totalCopies,
    String description = '',
    String? coverAsset,
  }) {
    _requireLibrarian(actor);

    final normalizedId = id.trim().toUpperCase();
    final normalizedTitle = title.trim();
    final normalizedAuthor = author.trim();
    final normalizedCategory = category.trim();
    final normalizedDescription = description.trim();

    if (normalizedId.isEmpty ||
        normalizedTitle.isEmpty ||
        normalizedAuthor.isEmpty ||
        normalizedCategory.isEmpty) {
      throw const AppException('required_field');
    }

    if (_bookRepository.findById(normalizedId) != null) {
      throw const AppException('book_id_exists');
    }

    if (totalCopies < 0) {
      throw const AppException('invalid_total_copies');
    }

    final newBook = Book(
      id: normalizedId,
      title: normalizedTitle,
      author: normalizedAuthor,
      category: normalizedCategory,
      totalCopies: totalCopies,
      description: normalizedDescription,
      coverAsset: coverAsset ?? 'assets/books/demmen.png',
      isActive: true,
    );

    _bookRepository.save(newBook);
    return newBook;
  }

  Book updateBook({
    required User actor,
    required String id,
    required String title,
    required String author,
    required String category,
    required int totalCopies,
    String description = '',
    String? coverAsset,
    bool? isActive,
  }) {
    _requireLibrarian(actor);

    final existing = _bookRepository.findById(id.trim());
    if (existing == null) {
      throw const AppException('book_not_found');
    }

    final normalizedTitle = title.trim();
    final normalizedAuthor = author.trim();
    final normalizedCategory = category.trim();
    final normalizedDescription = description.trim();

    if (normalizedTitle.isEmpty ||
        normalizedAuthor.isEmpty ||
        normalizedCategory.isEmpty) {
      throw const AppException('required_field');
    }

    if (totalCopies < 0) {
      throw const AppException('invalid_total_copies');
    }

    final minRequired = activeLoanCount(existing.id);
    if (totalCopies < minRequired) {
      throw const AppException('total_copies_below_active');
    }

    final updatedBook = Book(
      id: existing.id,
      title: normalizedTitle,
      author: normalizedAuthor,
      category: normalizedCategory,
      totalCopies: totalCopies,
      description: normalizedDescription,
      coverAsset: coverAsset ?? existing.coverAsset,
      isActive: isActive ?? existing.isActive,
    );

    _bookRepository.save(updatedBook);
    return updatedBook;
  }

  Book deactivateBook({
    required User actor,
    required String bookId,
  }) {
    _requireLibrarian(actor);

    final existing = _bookRepository.findById(bookId);
    if (existing == null) {
      throw const AppException('book_not_found');
    }

    if (activeLoanCount(bookId) > 0) {
      throw const AppException('book_has_active_loans');
    }

    final updated = Book(
      id: existing.id,
      title: existing.title,
      author: existing.author,
      category: existing.category,
      totalCopies: existing.totalCopies,
      description: existing.description,
      coverAsset: existing.coverAsset,
      isActive: false,
    );

    _bookRepository.save(updated);
    return updated;
  }

  Book activateBook({
    required User actor,
    required String bookId,
  }) {
    _requireLibrarian(actor);

    final existing = _bookRepository.findById(bookId);
    if (existing == null) {
      throw const AppException('book_not_found');
    }

    final updated = Book(
      id: existing.id,
      title: existing.title,
      author: existing.author,
      category: existing.category,
      totalCopies: existing.totalCopies,
      description: existing.description,
      coverAsset: existing.coverAsset,
      isActive: true,
    );

    _bookRepository.save(updated);
    return updated;
  }

  void deleteBook({
    required User actor,
    required String bookId,
  }) {
    _requireLibrarian(actor);

    final existing = _bookRepository.findById(bookId);
    if (existing == null) {
      throw const AppException('book_not_found');
    }

    if (activeLoanCount(bookId) > 0) {
      throw const AppException('book_has_active_loans');
    }

    if (hasLoanHistory(bookId)) {
      throw const AppException('book_has_loan_history');
    }

    _bookRepository.remove(bookId);
  }

  Future<bool> toggleFavoriteAsync({
    required String userId,
    required String bookId,
  }) {
    return _bookRepository.runExclusiveWrite(
      () => toggleFavorite(
        userId: userId,
        bookId: bookId,
      ),
    );
  }

  Future<Book> createBookAsync({
    required User actor,
    required String id,
    required String title,
    required String author,
    required String category,
    required int totalCopies,
    String description = '',
    String? coverAsset,
  }) {
    return _bookRepository.runExclusiveWrite(
      () => createBook(
        actor: actor,
        id: id,
        title: title,
        author: author,
        category: category,
        totalCopies: totalCopies,
        description: description,
        coverAsset: coverAsset,
      ),
    );
  }

  Future<Book> updateBookAsync({
    required User actor,
    required String id,
    required String title,
    required String author,
    required String category,
    required int totalCopies,
    String description = '',
    String? coverAsset,
    bool? isActive,
  }) {
    return _bookRepository.runExclusiveWrite(
      () => updateBook(
        actor: actor,
        id: id,
        title: title,
        author: author,
        category: category,
        totalCopies: totalCopies,
        description: description,
        coverAsset: coverAsset,
        isActive: isActive,
      ),
    );
  }

  Future<Book> deactivateBookAsync({
    required User actor,
    required String bookId,
  }) {
    return _bookRepository.runExclusiveWrite(
      () => deactivateBook(
        actor: actor,
        bookId: bookId,
      ),
    );
  }

  Future<Book> activateBookAsync({
    required User actor,
    required String bookId,
  }) {
    return _bookRepository.runExclusiveWrite(
      () => activateBook(
        actor: actor,
        bookId: bookId,
      ),
    );
  }

  Future<void> deleteBookAsync({
    required User actor,
    required String bookId,
  }) {
    return _bookRepository.runExclusiveWrite(
      () => deleteBook(
        actor: actor,
        bookId: bookId,
      ),
    );
  }

  void _requireLibrarian(User actor) {
    if (actor.role != UserRole.librarian) {
      throw const AppException('unauthorized');
    }
  }
}



