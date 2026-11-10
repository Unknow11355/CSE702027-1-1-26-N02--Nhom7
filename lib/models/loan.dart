import 'loan_status.dart';

class Loan {
  const Loan({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.createdAt,
    required this.pickupDate,
    this.status = LoanStatus.pending,
    this.borrowedAt,
    this.dueAt,
    this.returnedAt,
    this.renewalCount = 0,
    this.reason,
  });

  final String id;
  final String userId;
  final String bookId;
  final DateTime createdAt;
  final DateTime pickupDate;
  final LoanStatus status;
  final DateTime? borrowedAt;
  final DateTime? dueAt;
  final DateTime? returnedAt;
  final int renewalCount;
  final String? reason;
}
