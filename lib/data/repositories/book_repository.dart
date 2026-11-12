import '../../models/book.dart';
import '../library_data_store.dart';

class BookRepository {
  const BookRepository(this._store);

  final LibraryDataStore _store;

  List<Book> getAll() => _store.books;

  Book? findById(String id) {
    for (final book in _store.books) {
      if (book.id == id) {
        return book;
      }
    }
    return null;
  }

  void save(Book book) {
    _store.saveBook(book);
  }

  void remove(String bookId) {
    _store.removeBook(bookId);
  }

  Future<T> runExclusiveWrite<T>(T Function() action) {
    return _store.runExclusiveWrite<T>(action);
  }
}
