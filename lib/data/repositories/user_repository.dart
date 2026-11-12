import '../../models/user.dart';
import '../library_data_store.dart';

class UserRepository {
  const UserRepository(this._store);

  final LibraryDataStore _store;

  List<User> getAll() => _store.users;

  User? findById(String id) {
    for (final user in _store.users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  User? findByUsername(String username) {
    final normalized = username.trim().toLowerCase();
    for (final user in _store.users) {
      if (user.username.trim().toLowerCase() == normalized) {
        return user;
      }
    }
    return null;
  }

  void save(User user) {
    _store.saveUser(user);
  }

  void reloadFromStorage() {
    _store.reloadFromStorage(notify: false);
  }

  Future<T> runExclusiveWrite<T>(T Function() action) {
    return _store.runExclusiveWrite<T>(action);
  }
}
