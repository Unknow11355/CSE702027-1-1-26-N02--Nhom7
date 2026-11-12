import '../../models/loan.dart';
import '../library_data_store.dart';

class LoanRepository {
  const LoanRepository(this._store);

  final LibraryDataStore _store;

  List<Loan> getAll() => _store.loans;

  Loan? findById(String id) {
    for (final loan in _store.loans) {
      if (loan.id == id) {
        return loan;
      }
    }
    return null;
  }

  List<Loan> findByUserId(String userId) {
    return _store.loans
        .where((loan) => loan.userId == userId)
        .toList();
  }

  List<Loan> findByBookId(String bookId) {
    return _store.loans
        .where((loan) => loan.bookId == bookId)
        .toList();
  }

  void save(Loan loan) {
    _store.saveLoan(loan);
  }

  void saveAll(List<Loan> loans) {
    _store.saveLoans(loans);
  }

  Future<T> runExclusiveWrite<T>(T Function() action) {
    return _store.runExclusiveWrite<T>(action);
  }
}
