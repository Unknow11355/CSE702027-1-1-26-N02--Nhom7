import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../models/favorite.dart';
import '../models/loan.dart';
import '../models/user.dart';
import 'seed_data.dart';

class LibraryDataStore extends ChangeNotifier {
  LibraryDataStore() {
    _loadSeedData();
  }

  late List<User> _users;
  late List<Book> _books;
  late List<Loan> _loans;
  late List<Favorite> _favorites;

  List<User> get users => List<User>.unmodifiable(_users);

  List<Book> get books => List<Book>.unmodifiable(_books);

  List<Loan> get loans => List<Loan>.unmodifiable(_loans);

  List<Favorite> get favorites =>
      List<Favorite>.unmodifiable(_favorites);

  void _loadSeedData() {
    _users = SeedData.createInitialUsers();
    _books = SeedData.createInitialBooks();
    _loans = SeedData.createInitialLoans();
    _favorites = SeedData.createInitialFavorites();
  }

  void resetToSeedData() {
    _loadSeedData();
    notifyListeners();
  }

  void saveUser(User user) {
    _saveById<User>(_users, user, (item) => item.id);
  }

  void saveBook(Book book) {
    _saveById<Book>(_books, book, (item) => item.id);
  }

  void saveLoan(Loan loan) {
    _saveById<Loan>(_loans, loan, (item) => item.id);
  }

  void removeBook(String bookId) {
    _books.removeWhere((book) => book.id == bookId);
    _favorites.removeWhere((favorite) => favorite.bookId == bookId);
    notifyListeners();
  }

  void addFavorite(Favorite favorite) {
    final exists = _favorites.any(
      (item) =>
          item.userId == favorite.userId &&
          item.bookId == favorite.bookId,
    );

    if (exists) return;

    _favorites.add(favorite);
    notifyListeners();
  }

  void removeFavorite({
    required String userId,
    required String bookId,
  }) {
    _favorites.removeWhere(
      (item) => item.userId == userId && item.bookId == bookId,
    );
    notifyListeners();
  }

  void _saveById<T>(
    List<T> items,
    T value,
    String Function(T) idOf,
  ) {
    final index = items.indexWhere(
      (item) => idOf(item) == idOf(value),
    );

    if (index == -1) {
      items.add(value);
    } else {
      items[index] = value;
    }

    notifyListeners();
  }
}
