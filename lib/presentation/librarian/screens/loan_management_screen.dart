import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/loan.dart';
import '../../../models/loan_status.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../librarian_viewmodel.dart';
import 'loan_detail_screen.dart';

class LoanManagementSectionContent extends StatefulWidget {
  const LoanManagementSectionContent({super.key});

  @override
  State<LoanManagementSectionContent> createState() =>
      _LoanManagementSectionContentState();
}

class _LoanManagementSectionContentState
    extends State<LoanManagementSectionContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = context
        .read<LibrarianViewModel>()
        .loanSearchQuery;
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final loans = vm.filteredLoans;

    if (_searchController.text != vm.loanSearchQuery) {
      _searchController.value = TextEditingValue(
        text: vm.loanSearchQuery,
        selection: TextSelection.collapsed(
          offset: vm.loanSearchQuery.length,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          key: const Key('librarian-loan-search-field'),
          controller: _searchController,
          onChanged: (value) {
            context.read<LibrarianViewModel>().setLoanSearchQuery(
              value,
            );
          },
          decoration: InputDecoration(
            hintText: l10n.searchLoansHint,
            prefixIcon: const Icon(
              Icons.search,
              color: AppTheme.muted,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _LibrarianLoanFilterBar(),
        const SizedBox(height: 16),
        if (loans.isEmpty)
          const _EmptyLibrarianLoansBox()
        else
          for (final loan in loans) ...[
            _LibrarianLoanCardItem(
              loan: loan,
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _LibrarianLoanFilterBar extends StatelessWidget {
  const _LibrarianLoanFilterBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final selectedStatus = vm.loanStatusFilter;
    final onlyOverdue = vm.onlyOverdueFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChip(
                key: const Key('loan-filter-pending-chip'),
                label: Text(
                  l10n.statusPending,
                ),
                selected:
                    !onlyOverdue &&
                    selectedStatus == LoanStatus.pending,
                onSelected: (_) {
                  context
                      .read<LibrarianViewModel>()
                      .setLoanStatusFilter(LoanStatus.pending);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                key: const Key('loan-filter-ready-chip'),
                label: Text(
                  l10n.statusReadyForPickup,
                ),
                selected:
                    !onlyOverdue &&
                    selectedStatus == LoanStatus.readyForPickup,
                onSelected: (_) {
                  context
                      .read<LibrarianViewModel>()
                      .setLoanStatusFilter(
                        LoanStatus.readyForPickup,
                      );
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                key: const Key('loan-filter-borrowed-chip'),
                label: Text(
                  l10n.statusBorrowed,
                ),
                selected:
                    !onlyOverdue &&
                    selectedStatus == LoanStatus.borrowed,
                onSelected: (_) {
                  context
                      .read<LibrarianViewModel>()
                      .setLoanStatusFilter(LoanStatus.borrowed);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                key: const Key('loan-filter-returned-chip'),
                label: Text(
                  l10n.statusReturned,
                ),
                selected:
                    !onlyOverdue &&
                    selectedStatus == LoanStatus.returned,
                onSelected: (_) {
                  context
                      .read<LibrarianViewModel>()
                      .setLoanStatusFilter(LoanStatus.returned);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                key: const Key('loan-filter-rejected-chip'),
                label: Text(
                  l10n.statusRejected,
                ),
                selected:
                    !onlyOverdue &&
                    selectedStatus == LoanStatus.rejected,
                onSelected: (_) {
                  context
                      .read<LibrarianViewModel>()
                      .setLoanStatusFilter(LoanStatus.rejected);
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                key: const Key('loan-filter-cancelled-chip'),
                label: Text(
                  l10n.statusCancelled,
                ),
                selected:
                    !onlyOverdue &&
                    selectedStatus == LoanStatus.cancelled,
                onSelected: (_) {
                  context
                      .read<LibrarianViewModel>()
                      .setLoanStatusFilter(LoanStatus.cancelled);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                key: const Key('loan-filter-overdue-button'),
                onPressed: () {
                  context
                      .read<LibrarianViewModel>()
                      .setOnlyOverdueFilter(!onlyOverdue);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: onlyOverdue
                      ? AppTheme.dangerSoft
                      : AppTheme.surface,
                  foregroundColor: onlyOverdue
                      ? AppTheme.danger
                      : AppTheme.ink,
                  side: BorderSide(
                    color: onlyOverdue
                        ? AppTheme.danger
                        : AppTheme.outline,
                  ),
                ),
                child: Text(
                  l10n.statusOverdue,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                key: const Key('loan-filter-all-button'),
                onPressed: () {
                  context.read<LibrarianViewModel>().showAllLoans();
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      !onlyOverdue && selectedStatus == null
                      ? AppTheme.primarySoft
                      : AppTheme.surface,
                ),
                child: Text(
                  l10n.allLoansButton,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LibrarianLoanCardItem extends StatelessWidget {
  const _LibrarianLoanCardItem({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final book = vm.findBookById(loan.bookId);
    final isOverdue = vm.isOverdue(loan);

    final String dateLine;
    if (loan.status == LoanStatus.borrowed && loan.dueAt != null) {
      dateLine = l10n.dueDateInline(
        DateFormatter.formatDate(loan.dueAt!),
      );
    } else {
      dateLine = l10n.pickupDateInline(
        DateFormatter.formatDate(loan.pickupDate),
      );
    }

    return LoanCard(
      key: Key('librarian-loan-card-${loan.id}'),
      loan: loan,
      book: book,
      dateLine: dateLine,
      isOverdue: isOverdue,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => LibrarianLoanDetailScreen(
              loanId: loan.id,
            ),
          ),
        );
      },
    );
  }
}

class _EmptyLibrarianLoansBox extends StatelessWidget {
  const _EmptyLibrarianLoansBox();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outline,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long,
            size: 40,
            color: AppTheme.muted,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.emptyLoansTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
