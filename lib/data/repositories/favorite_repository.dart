import '../../models/favorite.dart';
import '../library_data_store.dart';

class FavoriteRepository {
  const FavoriteRepository(this._store);

  final LibraryDataStore _store;

  List<Favorite> getByUserId(String userId) {
    return _store.favorites
        .where((favorite) => favorite.userId == userId)
        .toList();
  }

  bool isFavorite({
    required String userId,
    required String bookId,
  }) {
    return _store.favorites.any(
      (favorite) =>
          favorite.userId == userId && favorite.bookId == bookId,
    );
  }

  void add(Favorite favorite) {
    _store.addFavorite(favorite);
  }

  void remove({
    required String userId,
    required String bookId,
  }) {
    _store.removeFavorite(
      userId: userId,
      bookId: bookId,
    );
  }

  Future<T> runExclusiveWrite<T>(T Function() action) {
    return _store.runExclusiveWrite<T>(action);
  }
}
