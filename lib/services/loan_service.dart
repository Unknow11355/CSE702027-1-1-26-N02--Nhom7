// Bước 13: Tra cứu phiếu mượn và tự động hủy phiếu quá hạn nhận
import '../core/app_constants.dart';
import '../core/app_exception.dart';
import '../data/repositories/book_repository.dart';
import '../data/repositories/loan_repository.dart';
import '../data/repositories/user_repository.dart';
import '../models/loan.dart';
import '../models/loan_status.dart';
import '../models/user.dart';
import '../models/user_role.dart';
import 'book_service.dart';

class LoanService {
  const LoanService(
    this._loanRepository,
    this._bookRepository,
    this._userRepository,
    this._bookService,
  );

  final LoanRepository _loanRepository;
  final BookRepository _bookRepository;
  final UserRepository _userRepository;
  final BookService _bookService;

  static const String expiredPickupReasonCode = 'Quá hạn nhận';
  static const String readerCancelledReasonCode =
      'Độc giả hủy yêu cầu';

  DateTime _dateOnly(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  bool isActiveStatus(LoanStatus status) {
    return status == LoanStatus.pending ||
        status == LoanStatus.readyForPickup ||
        status == LoanStatus.borrowed;
  }

  bool isActiveLoan(Loan loan) => isActiveStatus(loan.status);

  bool isPickupExpired(
    Loan loan, {
    DateTime? now,
  }) {
    if (loan.status != LoanStatus.pending &&
        loan.status != LoanStatus.readyForPickup) {
      return false;
    }
    final today = _dateOnly(now ?? DateTime.now());
    final pickupDay = _dateOnly(loan.pickupDate);
    return pickupDay.isBefore(today);
  }

  int cancelExpiredPickups({DateTime? now}) {
    final allLoans = _loanRepository.getAll();
    final expiredLoans = <Loan>[];

    for (final loan in allLoans) {
      if (isPickupExpired(loan, now: now)) {
        expiredLoans.add(
          Loan(
            id: loan.id,
            userId: loan.userId,
            bookId: loan.bookId,
            createdAt: loan.createdAt,
            pickupDate: loan.pickupDate,
            status: LoanStatus.cancelled,
            borrowedAt: loan.borrowedAt,
            dueAt: loan.dueAt,
            returnedAt: loan.returnedAt,
            renewalCount: loan.renewalCount,
            reason: expiredPickupReasonCode,
          ),
        );
      }
    }

    if (expiredLoans.isNotEmpty) {
      _loanRepository.saveAll(expiredLoans);
    }

    return expiredLoans.length;
  }

  Future<int> cancelExpiredPickupsAsync({DateTime? now}) {
    return _loanRepository.runExclusiveWrite(
      () => cancelExpiredPickups(now: now),
    );
  }

  bool isOverdue(
    Loan loan, {
    DateTime? now,
  }) {
    if (loan.status != LoanStatus.borrowed || loan.dueAt == null) {
      return false;
    }
    final today = _dateOnly(now ?? DateTime.now());
    final dueDay = _dateOnly(loan.dueAt!);
    return dueDay.isBefore(today);
  }

  int daysUntilDue(
    Loan loan, {
    DateTime? now,
  }) {
    if (loan.dueAt == null) {
      return 0;
    }
    final today = _dateOnly(now ?? DateTime.now());
    final dueDay = _dateOnly(loan.dueAt!);
    return dueDay.difference(today).inDays;
  }

  int overdueDays(
    Loan loan, {
    DateTime? now,
  }) {
    if (!isOverdue(loan, now: now)) {
      return 0;
    }
    final diff = daysUntilDue(loan, now: now);
    return diff < 0 ? -diff : 1;
  }

  bool isDueSoon(
    Loan loan, {
    DateTime? now,
  }) {
    if (loan.status != LoanStatus.borrowed || loan.dueAt == null) {
      return false;
    }
    final remaining = daysUntilDue(loan, now: now);
    return remaining >= 0 && remaining <= 2;
  }

  List<Loan> getAllLoans({DateTime? now}) {
    return _loanRepository.getAll();
  }

  Loan? findById(
    String loanId, {
    DateTime? now,
  }) {
    return _loanRepository.findById(loanId);
  }

  List<Loan> getUserLoans(
    String userId, {
    DateTime? now,
  }) {
    return _loanRepository.findByUserId(userId);
  }

  List<Loan> getUserActiveLoans(
    String userId, {
    DateTime? now,
  }) {
    return getUserLoans(userId, now: now)
        .where(isActiveLoan)
        .toList();
  }

  List<Loan> getUserHistoryLoans(
    String userId, {
    DateTime? now,
  }) {
    return getUserLoans(userId, now: now)
        .where((loan) => !isActiveLoan(loan))
        .toList();
  }

  int activeLoanCountForUser(
    String userId, {
    DateTime? now,
  }) {
    return getUserActiveLoans(userId, now: now).length;
  }

  Loan? findActiveLoanForUserAndBook({
    required String userId,
    required String bookId,
    DateTime? now,
  }) {
    final activeLoans = getUserActiveLoans(userId, now: now);
    for (final loan in activeLoans) {
      if (loan.bookId == bookId) {
        return loan;
      }
    }
    return null;
  }

  List<Loan> getUserDueSoonOrOverdueLoans(
    String userId, {
    DateTime? now,
  }) {
    final active = getUserActiveLoans(userId, now: now);
    return active
        .where(
          (loan) =>
              isOverdue(loan, now: now) || isDueSoon(loan, now: now),
        )
        .toList();
  }

  List<Loan> getOverdueLoans({DateTime? now}) {
    return getAllLoans(now: now)
        .where((loan) => isOverdue(loan, now: now))
        .toList();
  }

  bool canCancel({
    required Loan loan,
    required User user,
  }) {
    if (loan.userId != user.id) {
      return false;
    }
    return loan.status == LoanStatus.pending ||
        loan.status == LoanStatus.readyForPickup;
  }

  bool canRenew({
    required Loan loan,
    required User user,
    DateTime? now,
  }) {
    if (loan.userId != user.id) {
      return false;
    }
    if (loan.status != LoanStatus.borrowed || loan.dueAt == null) {
      return false;
    }
    if (isOverdue(loan, now: now)) {
      return false;
    }
    return loan.renewalCount < 1;
  }

  String generateNextLoanId() {
    var maxNum = 0;
    for (final loan in _loanRepository.getAll()) {
      final raw = loan.id.toUpperCase().replaceFirst('PM', '');
      final parsed = int.tryParse(raw);
      if (parsed != null && parsed > maxNum) {
        maxNum = parsed;
      }
    }
    final nextNum = maxNum + 1;
    return 'PM${nextNum.toString().padLeft(3, '0')}';
  }

  Loan createRequest({
    required User actor,
    required String bookId,
    required DateTime pickupDate,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);

    if (actor.role != UserRole.reader) {
      throw const AppException('unauthorized');
    }

    final book = _bookRepository.findById(bookId);
    if (book == null || !book.isActive) {
      throw const AppException('book_not_available');
    }

    final duplicate = findActiveLoanForUserAndBook(
      userId: actor.id,
      bookId: bookId,
      now: now,
    );
    if (duplicate != null) {
      throw const AppException('duplicate_active_loan');
    }

    final activeCount = activeLoanCountForUser(actor.id, now: now);
    if (activeCount >= AppConstants.maxActiveLoans) {
      throw const AppException('active_loan_limit_reached');
    }

    if (_bookService.availableCopies(bookId) <= 0) {
      throw const AppException('no_available_copies');
    }

    final current = now ?? DateTime.now();
    final today = _dateOnly(current);
    final selectedDay = _dateOnly(pickupDate);
    final maxPickupDay = today.add(
      const Duration(days: AppConstants.loanDays),
    );

    if (selectedDay.isBefore(today) ||
        selectedDay.isAfter(maxPickupDay)) {
      throw const AppException('invalid_pickup_date');
    }

    final newLoan = Loan(
      id: generateNextLoanId(),
      userId: actor.id,
      bookId: bookId,
      createdAt: current,
      pickupDate: selectedDay,
      status: LoanStatus.pending,
    );

    _loanRepository.save(newLoan);
    return newLoan;
  }

  Loan cancelRequest({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);

    final loan = _loanRepository.findById(loanId);
    if (loan == null) {
      throw const AppException('loan_not_found');
    }

    if (loan.userId != actor.id) {
      throw const AppException('unauthorized');
    }

    if (loan.status != LoanStatus.pending &&
        loan.status != LoanStatus.readyForPickup) {
      throw const AppException('cannot_cancel_loan');
    }

    final updated = Loan(
      id: loan.id,
      userId: loan.userId,
      bookId: loan.bookId,
      createdAt: loan.createdAt,
      pickupDate: loan.pickupDate,
      status: LoanStatus.cancelled,
      borrowedAt: loan.borrowedAt,
      dueAt: loan.dueAt,
      returnedAt: loan.returnedAt,
      renewalCount: loan.renewalCount,
      reason: readerCancelledReasonCode,
    );

    _loanRepository.save(updated);
    return updated;
  }

  Loan renewLoan({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);

    final loan = _loanRepository.findById(loanId);
    if (loan == null) {
      throw const AppException('loan_not_found');
    }

    if (loan.userId != actor.id) {
      throw const AppException('unauthorized');
    }

    if (loan.status != LoanStatus.borrowed || loan.dueAt == null) {
      throw const AppException('cannot_renew_loan');
    }

    if (isOverdue(loan, now: now)) {
      throw const AppException('cannot_renew_overdue');
    }

    if (loan.renewalCount >= 1) {
      throw const AppException('renewal_limit_reached');
    }

    final newDueAt = loan.dueAt!.add(
      const Duration(days: AppConstants.renewalDays),
    );

    final updated = Loan(
      id: loan.id,
      userId: loan.userId,
      bookId: loan.bookId,
      createdAt: loan.createdAt,
      pickupDate: loan.pickupDate,
      status: LoanStatus.borrowed,
      borrowedAt: loan.borrowedAt,
      dueAt: newDueAt,
      returnedAt: loan.returnedAt,
      renewalCount: loan.renewalCount + 1,
      reason: loan.reason,
    );

    _loanRepository.save(updated);
    return updated;
  }

  Loan approveRequest({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);
    _requireLibrarian(actor);

    final loan = _loanRepository.findById(loanId);
    if (loan == null) {
      throw const AppException('loan_not_found');
    }

    if (loan.status != LoanStatus.pending) {
      throw const AppException('invalid_loan_transition');
    }

    if (isPickupExpired(loan, now: now)) {
      throw const AppException('pickup_expired');
    }

    final updated = Loan(
      id: loan.id,
      userId: loan.userId,
      bookId: loan.bookId,
      createdAt: loan.createdAt,
      pickupDate: loan.pickupDate,
      status: LoanStatus.readyForPickup,
      borrowedAt: loan.borrowedAt,
      dueAt: loan.dueAt,
      returnedAt: loan.returnedAt,
      renewalCount: loan.renewalCount,
      reason: loan.reason,
    );

    _loanRepository.save(updated);
    return updated;
  }

  Loan rejectRequest({
    required User actor,
    required String loanId,
    required String reason,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);
    _requireLibrarian(actor);

    final loan = _loanRepository.findById(loanId);
    if (loan == null) {
      throw const AppException('loan_not_found');
    }

    if (loan.status != LoanStatus.pending) {
      throw const AppException('invalid_loan_transition');
    }

    final trimmedReason = reason.trim();
    if (trimmedReason.isEmpty) {
      throw const AppException('required_field');
    }

    final updated = Loan(
      id: loan.id,
      userId: loan.userId,
      bookId: loan.bookId,
      createdAt: loan.createdAt,
      pickupDate: loan.pickupDate,
      status: LoanStatus.rejected,
      borrowedAt: loan.borrowedAt,
      dueAt: loan.dueAt,
      returnedAt: loan.returnedAt,
      renewalCount: loan.renewalCount,
      reason: trimmedReason,
    );

    _loanRepository.save(updated);
    return updated;
  }

  Loan confirmHandover({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);
    _requireLibrarian(actor);

    final loan = _loanRepository.findById(loanId);
    if (loan == null) {
      throw const AppException('loan_not_found');
    }

    if (loan.status != LoanStatus.readyForPickup) {
      throw const AppException('invalid_loan_transition');
    }

    if (isPickupExpired(loan, now: now)) {
      throw const AppException('pickup_expired');
    }

    final currentTime = now ?? DateTime.now();
    final dueTime = currentTime.add(
      const Duration(days: AppConstants.loanDays),
    );

    final updated = Loan(
      id: loan.id,
      userId: loan.userId,
      bookId: loan.bookId,
      createdAt: loan.createdAt,
      pickupDate: loan.pickupDate,
      status: LoanStatus.borrowed,
      borrowedAt: currentTime,
      dueAt: dueTime,
      returnedAt: loan.returnedAt,
      renewalCount: loan.renewalCount,
      reason: loan.reason,
    );

    _loanRepository.save(updated);
    return updated;
  }

  Loan confirmReturn({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    cancelExpiredPickups(now: now);
    _requireLibrarian(actor);

    final loan = _loanRepository.findById(loanId);
    if (loan == null) {
      throw const AppException('loan_not_found');
    }

    if (loan.status != LoanStatus.borrowed) {
      throw const AppException('invalid_loan_transition');
    }

    final currentTime = now ?? DateTime.now();

    final updated = Loan(
      id: loan.id,
      userId: loan.userId,
      bookId: loan.bookId,
      createdAt: loan.createdAt,
      pickupDate: loan.pickupDate,
      status: LoanStatus.returned,
      borrowedAt: loan.borrowedAt,
      dueAt: loan.dueAt,
      returnedAt: currentTime,
      renewalCount: loan.renewalCount,
      reason: loan.reason,
    );

    _loanRepository.save(updated);
    return updated;
  }

  Future<Loan> createRequestAsync({
    required User actor,
    required String bookId,
    required DateTime pickupDate,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => createRequest(
        actor: actor,
        bookId: bookId,
        pickupDate: pickupDate,
        now: now,
      ),
    );
  }

  Future<Loan> cancelRequestAsync({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => cancelRequest(
        actor: actor,
        loanId: loanId,
        now: now,
      ),
    );
  }

  Future<Loan> renewLoanAsync({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => renewLoan(
        actor: actor,
        loanId: loanId,
        now: now,
      ),
    );
  }

  Future<Loan> approveRequestAsync({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => approveRequest(
        actor: actor,
        loanId: loanId,
        now: now,
      ),
    );
  }

  Future<Loan> rejectRequestAsync({
    required User actor,
    required String loanId,
    required String reason,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => rejectRequest(
        actor: actor,
        loanId: loanId,
        reason: reason,
        now: now,
      ),
    );
  }

  Future<Loan> confirmHandoverAsync({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => confirmHandover(
        actor: actor,
        loanId: loanId,
        now: now,
      ),
    );
  }

  Future<Loan> confirmReturnAsync({
    required User actor,
    required String loanId,
    DateTime? now,
  }) {
    return _loanRepository.runExclusiveWrite(
      () => confirmReturn(
        actor: actor,
        loanId: loanId,
        now: now,
      ),
    );
  }

  List<Loan> searchLibrarianLoans({
    String query = '',
    LoanStatus? statusFilter,
    bool onlyOverdue = false,
    DateTime? now,
  }) {
    final all = getAllLoans(now: now);
    final normalizedQuery = query.trim().toLowerCase();

    return all.where((loan) {
      if (onlyOverdue) {
        if (!isOverdue(loan, now: now)) {
          return false;
        }
      } else if (statusFilter != null) {
        if (loan.status != statusFilter) {
          return false;
        }
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      final book = _bookRepository.findById(loan.bookId);
      final user = _userRepository.findById(loan.userId);
      final matchLoanId = loan.id.toLowerCase().contains(
        normalizedQuery,
      );
      final matchBookId = loan.bookId.toLowerCase().contains(
        normalizedQuery,
      );
      final matchBookTitle =
          book?.title.toLowerCase().contains(normalizedQuery) ??
          false;
      final matchReaderName =
          user?.fullName.toLowerCase().contains(normalizedQuery) ??
          false;
      final matchUsername =
          user?.username.toLowerCase().contains(normalizedQuery) ??
          false;

      return matchLoanId ||
          matchBookId ||
          matchBookTitle ||
          matchReaderName ||
          matchUsername;
    }).toList();
  }

  void _requireLibrarian(User actor) {
    if (actor.role != UserRole.librarian) {
      throw const AppException('unauthorized');
    }
  }
}

