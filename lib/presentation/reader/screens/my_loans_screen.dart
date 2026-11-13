import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/loan.dart';
import '../../../models/loan_status.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../reader_viewmodel.dart';
import 'loan_detail_screen.dart';

class MyLoansSectionContent extends StatelessWidget {
  const MyLoansSectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final showHistory = readerVm.showLoanHistory;
    final loans = showHistory
        ? readerVm.historyLoans
        : readerVm.activeLoans;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _LoanModeChipsRow(
          showHistory: showHistory,
        ),
        const SizedBox(height: 16),
        if (!showHistory) ...[
          Text(
            l10n.activeLoansSummary(
              readerVm.activeLoanCount,
              AppConstants.maxActiveLoans,
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (loans.isEmpty)
          const _EmptyLoansBox()
        else
          for (final loan in loans) ...[
            _ReaderLoanCardItem(
              loan: loan,
            ),
            const SizedBox(height: 12),
          ],
        if (!showHistory) ...[
          const SizedBox(height: 4),
          AppInfoBanner(
            icon: Icons.info_outline,
            title: l10n.trackLoansBannerTitle,
            message: l10n.trackLoansBannerMessage,
          ),
        ],
      ],
    );
  }
}

class _LoanModeChipsRow extends StatelessWidget {
  const _LoanModeChipsRow({
    required this.showHistory,
  });

  final bool showHistory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        FilterChip(
          key: const Key('my-loans-active-chip'),
          label: Text(
            l10n.filterActiveLoans,
          ),
          selected: !showHistory,
          onSelected: (_) {
            context.read<ReaderViewModel>().setShowLoanHistory(
              false,
            );
          },
        ),
        FilterChip(
          key: const Key('my-loans-history-chip'),
          label: Text(
            l10n.filterLoanHistory,
          ),
          selected: showHistory,
          onSelected: (_) {
            context.read<ReaderViewModel>().setShowLoanHistory(
              true,
            );
          },
        ),
      ],
    );
  }
}

class _ReaderLoanCardItem extends StatelessWidget {
  const _ReaderLoanCardItem({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final book = readerVm.findBookById(loan.bookId);
    final isOverdue = readerVm.isOverdue(loan);

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
      key: Key('reader-loan-card-${loan.id}'),
      loan: loan,
      book: book,
      dateLine: dateLine,
      isOverdue: isOverdue,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => ReaderLoanDetailScreen(
              loanId: loan.id,
            ),
          ),
        );
      },
    );
  }
}

class _EmptyLoansBox extends StatelessWidget {
  const _EmptyLoansBox();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

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
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.emptyLoansSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
