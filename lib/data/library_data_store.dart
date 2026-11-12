import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../models/favorite.dart';
import '../models/loan.dart';
import '../models/loan_status.dart';
import '../models/user.dart';
import '../models/user_role.dart';
import 'seed_data.dart';
import 'store_sync_stub.dart'
    if (dart.library.js_interop) 'store_sync_web.dart';

class LibraryDataStore extends ChangeNotifier {
  LibraryDataStore() {
    _loadSeedData();
    _syncAdapter = StoreSyncAdapter(
      _applySerializedState,
    );
    final existingJson = _syncAdapter.loadInitialData();
    if (existingJson != null && existingJson.isNotEmpty) {
      _applySerializedState(
        existingJson,
        notify: false,
      );
    } else {
      _syncAdapter.publishData(_encodeState());
    }
  }

  late final StoreSyncAdapter _syncAdapter;
  late List<User> _users;
  late List<Book> _books;
  late List<Loan> _loans;
  late List<Favorite> _favorites;
  int _batchDepth = 0;
  bool _hasPendingChanges = false;

  List<User> get users => List<User>.unmodifiable(_users);

  List<Book> get books => List<Book>.unmodifiable(_books);

  List<Loan> get loans => List<Loan>.unmodifiable(_loans);

  List<Favorite> get favorites =>
      List<Favorite>.unmodifiable(_favorites);

  void reloadFromStorage({bool notify = false}) {
    final rawJson = _syncAdapter.loadInitialData();
    if (rawJson != null && rawJson.isNotEmpty) {
      _applySerializedState(
        rawJson,
        notify: notify,
      );
    }
  }

  T runBatch<T>(T Function() action) {
    if (_batchDepth == 0) {
      reloadFromStorage(notify: false);
    }
    _batchDepth++;
    try {
      return action();
    } finally {
      _batchDepth--;
      if (_batchDepth == 0 && _hasPendingChanges) {
        _hasPendingChanges = false;
        _publishAndNotify();
      }
    }
  }

  Future<T> runExclusiveWrite<T>(T Function() action) {
    return _syncAdapter.runExclusive<T>(() => runBatch<T>(action));
  }

  void _loadSeedData() {
    _users = List<User>.of(SeedData.createInitialUsers());
    _books = List<Book>.of(SeedData.createInitialBooks());
    _loans = List<Loan>.of(SeedData.createInitialLoans());
    _favorites = List<Favorite>.of(
      SeedData.createInitialFavorites(),
    );
  }

  void resetToSeedData() {
    _loadSeedData();
    _publishAndNotify();
  }

  void saveUser(User user) {
    runBatch(() {
      _saveById<User>(_users, user, (item) => item.id);
    });
  }

  void saveBook(Book book) {
    runBatch(() {
      _saveById<Book>(_books, book, (item) => item.id);
    });
  }

  void saveLoan(Loan loan) {
    runBatch(() {
      _saveById<Loan>(_loans, loan, (item) => item.id);
    });
  }

  void saveLoans(List<Loan> loans) {
    if (loans.isEmpty) {
      return;
    }
    runBatch(() {
      for (final loan in loans) {
        _upsertById<Loan>(_loans, loan, (item) => item.id);
      }
      _publishAndNotify();
    });
  }

  void removeBook(String bookId) {
    runBatch(() {
      _books.removeWhere((book) => book.id == bookId);
      _favorites.removeWhere((favorite) => favorite.bookId == bookId);
      _publishAndNotify();
    });
  }

  void addFavorite(Favorite favorite) {
    runBatch(() {
      final exists = _favorites.any(
        (item) =>
            item.userId == favorite.userId &&
            item.bookId == favorite.bookId,
      );

      if (exists) return;

      _favorites.add(favorite);
      _publishAndNotify();
    });
  }

  void removeFavorite({
    required String userId,
    required String bookId,
  }) {
    runBatch(() {
      final removedCount = _favorites.length;
      _favorites.removeWhere(
        (item) => item.userId == userId && item.bookId == bookId,
      );
      if (_favorites.length != removedCount) {
        _publishAndNotify();
      }
    });
  }

  void _upsertById<T>(
    List<T> items,
    T value,
    String Function(T) idOf,
  ) {
    final index = items.indexWhere(
      (item) => idOf(item) == idOf(value),
    );

    if (index == -1) {
      items.insert(0, value);
    } else {
      items[index] = value;
    }
  }

  void _saveById<T>(
    List<T> items,
    T value,
    String Function(T) idOf,
  ) {
    _upsertById<T>(items, value, idOf);
    _publishAndNotify();
  }

  void _publishAndNotify() {
    if (_batchDepth > 0) {
      _hasPendingChanges = true;
      return;
    }
    _syncAdapter.publishData(_encodeState());
    notifyListeners();
  }

  String _encodeState() {
    final payload = <String, dynamic>{
      'users': _users.map(_userToMap).toList(),
      'books': _books.map(_bookToMap).toList(),
      'loans': _loans.map(_loanToMap).toList(),
      'favorites': _favorites.map(_favoriteToMap).toList(),
    };
    return jsonEncode(payload);
  }

  void _applySerializedState(
    String rawJson, {
    bool notify = true,
  }) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        return;
      }

      final usersList = decoded['users'];
      final booksList = decoded['books'];
      final loansList = decoded['loans'];
      final favoritesList = decoded['favorites'];

      if (usersList is List) {
        _users = usersList
            .whereType<Map<String, dynamic>>()
            .map(_userFromMap)
            .toList();
      }
      if (booksList is List) {
        _books = booksList
            .whereType<Map<String, dynamic>>()
            .map(_bookFromMap)
            .toList();
      }
      if (loansList is List) {
        _loans = loansList
            .whereType<Map<String, dynamic>>()
            .map(_loanFromMap)
            .toList();
      }
      if (favoritesList is List) {
        _favorites = favoritesList
            .whereType<Map<String, dynamic>>()
            .map(_favoriteFromMap)
            .toList();
      }

      if (notify) {
        notifyListeners();
      }
    } catch (_) {
      // Ignore malformed state payload.
    }
  }

  static Map<String, dynamic> _userToMap(User user) {
    return <String, dynamic>{
      'id': user.id,
      'fullName': user.fullName,
      'username': user.username,
      'passwordHash': user.passwordHash,
      'passwordSalt': user.passwordSalt,
      'role': user.role.name,
    };
  }

  static User _userFromMap(Map<String, dynamic> map) {
    final roleName = map['role'] as String? ?? 'reader';
    final role = UserRole.values.firstWhere(
      (item) => item.name == roleName,
      orElse: () => UserRole.reader,
    );
    return User(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      username: map['username'] as String,
      passwordHash: map['passwordHash'] as String,
      passwordSalt: map['passwordSalt'] as String,
      role: role,
    );
  }

  static Map<String, dynamic> _bookToMap(Book book) {
    return <String, dynamic>{
      'id': book.id,
      'title': book.title,
      'author': book.author,
      'category': book.category,
      'totalCopies': book.totalCopies,
      'description': book.description,
      'coverAsset': book.coverAsset,
      'isActive': book.isActive,
    };
  }

  static Book _bookFromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      category: map['category'] as String,
      totalCopies: (map['totalCopies'] as num).toInt(),
      description: map['description'] as String? ?? '',
      coverAsset: map['coverAsset'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  static Map<String, dynamic> _loanToMap(Loan loan) {
    return <String, dynamic>{
      'id': loan.id,
      'userId': loan.userId,
      'bookId': loan.bookId,
      'createdAt': loan.createdAt.toIso8601String(),
      'pickupDate': loan.pickupDate.toIso8601String(),
      'status': loan.status.name,
      'borrowedAt': loan.borrowedAt?.toIso8601String(),
      'dueAt': loan.dueAt?.toIso8601String(),
      'returnedAt': loan.returnedAt?.toIso8601String(),
      'renewalCount': loan.renewalCount,
      'reason': loan.reason,
    };
  }

  static Loan _loanFromMap(Map<String, dynamic> map) {
    final statusName = map['status'] as String? ?? 'pending';
    final status = LoanStatus.values.firstWhere(
      (item) => item.name == statusName,
      orElse: () => LoanStatus.pending,
    );
    return Loan(
      id: map['id'] as String,
      userId: map['userId'] as String,
      bookId: map['bookId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      pickupDate: DateTime.parse(map['pickupDate'] as String),
      status: status,
      borrowedAt: map['borrowedAt'] != null
          ? DateTime.parse(map['borrowedAt'] as String)
          : null,
      dueAt: map['dueAt'] != null
          ? DateTime.parse(map['dueAt'] as String)
          : null,
      returnedAt: map['returnedAt'] != null
          ? DateTime.parse(map['returnedAt'] as String)
          : null,
      renewalCount: (map['renewalCount'] as num?)?.toInt() ?? 0,
      reason: map['reason'] as String?,
    );
  }

  static Map<String, dynamic> _favoriteToMap(Favorite favorite) {
    return <String, dynamic>{
      'userId': favorite.userId,
      'bookId': favorite.bookId,
    };
  }

  static Favorite _favoriteFromMap(Map<String, dynamic> map) {
    return Favorite(
      userId: map['userId'] as String,
      bookId: map['bookId'] as String,
    );
  }

  @override
  void dispose() {
    _syncAdapter.dispose();
    super.dispose();
  }
}
