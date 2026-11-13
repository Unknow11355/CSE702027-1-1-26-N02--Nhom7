import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_exception.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/loan.dart';
import '../../../models/loan_status.dart';
import '../../../services/loan_service.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../reader_viewmodel.dart';
import 'book_detail_screen.dart';

class ReaderLoanDetailScreen extends StatelessWidget {
  const ReaderLoanDetailScreen({
    super.key,
    required this.loanId,
  });

  final String loanId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final loan = readerVm.findLoanById(loanId);

    if (loan == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.loanDetailTitle,
          ),
        ),
        body: const SizedBox.shrink(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.backTooltip,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          l10n.loanDetailTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _ReaderLoanDetailBody(
            loan: loan,
          ),
        ),
      ),
    );
  }
}

class _ReaderLoanDetailBody extends StatelessWidget {
  const _ReaderLoanDetailBody({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final readerVm = context.watch<ReaderViewModel>();
    final book = readerVm.findBookById(loan.bookId);
    final isOverdue = readerVm.isOverdue(loan);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            LoanStatusBadge(
              status: loan.status,
            ),
            if (isOverdue) const OverdueBadge(),
          ],
        ),
        const SizedBox(height: 16),
        if (book != null) ...[
          BookCard(
            book: book,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => BookDetailScreen(
                    bookId: book.id,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        _ReaderLoanBanner(
          loan: loan,
        ),
        const SizedBox(height: 16),
        _ReaderLoanInfoCard(
          loan: loan,
        ),
        const SizedBox(height: 20),
        _ReaderLoanActions(
          loan: loan,
        ),
      ],
    );
  }
}

class _ReaderLoanBanner extends StatelessWidget {
  const _ReaderLoanBanner({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();

    switch (loan.status) {
      case LoanStatus.pending:
        return AppInfoBanner(
          icon: Icons.info_outline,
          title: l10n.pendingBannerTitle,
          message: l10n.pendingBannerMessage,
        );
      case LoanStatus.readyForPickup:
        return AppInfoBanner(
          icon: Icons.check_circle,
          title: l10n.readyBannerTitle,
          message: l10n.readyBannerMessage(
            DateFormatter.formatDayMonth(loan.pickupDate),
            loan.id,
          ),
          foregroundColor: AppTheme.success,
          backgroundColor: AppTheme.successSoft,
        );
      case LoanStatus.borrowed:
        if (readerVm.isOverdue(loan)) {
          final days = readerVm.overdueDays(loan);
          return AppInfoBanner(
            icon: Icons.warning_amber,
            title: l10n.overdueLoanBannerTitle(days),
            message: l10n.overdueLoanBannerMessage,
            foregroundColor: AppTheme.danger,
            backgroundColor: AppTheme.dangerSoft,
          );
        }
        if (loan.renewalCount > 0 && loan.dueAt != null) {
          return AppInfoBanner(
            icon: Icons.check_circle,
            title: l10n.renewedBannerTitle,
            message: l10n.renewedBannerMessage(
              DateFormatter.formatDateTime(loan.dueAt!),
            ),
            foregroundColor: AppTheme.success,
            backgroundColor: AppTheme.successSoft,
          );
        }
        final remaining = readerVm.daysUntilDue(loan);
        return AppInfoBanner(
          icon: Icons.info_outline,
          title: l10n.borrowedBannerTitle(remaining),
          message: remaining <= 2
              ? l10n.borrowedDueSoonBannerMessage
              : l10n.borrowedRenewableBannerMessage,
        );
      case LoanStatus.returned:
        return AppInfoBanner(
          icon: Icons.check_circle,
          title: l10n.returnedBannerTitle,
          message: l10n.returnedBannerMessage,
          foregroundColor: AppTheme.success,
          backgroundColor: AppTheme.successSoft,
        );
      case LoanStatus.rejected:
        return AppInfoBanner(
          icon: Icons.warning_amber,
          title: l10n.rejectedReaderBannerTitle,
          message: l10n.rejectedBannerMessage(
            loan.reason ?? '',
          ),
          foregroundColor: AppTheme.warning,
          backgroundColor: AppTheme.warningSoft,
        );
      case LoanStatus.cancelled:
        if (loan.reason == LoanService.expiredPickupReasonCode) {
          return AppInfoBanner(
            icon: Icons.schedule,
            title: l10n.expiredPickupBannerTitle,
            message: l10n.expiredPickupBannerMessage,
            foregroundColor: AppTheme.warning,
            backgroundColor: AppTheme.warningSoft,
          );
        }
        return AppInfoBanner(
          icon: Icons.check_circle,
          title: l10n.cancelledBannerTitle,
          message: l10n.cancelledBannerMessage,
          foregroundColor: AppTheme.success,
          backgroundColor: AppTheme.successSoft,
        );
    }
  }
}

class _ReaderLoanInfoCard extends StatelessWidget {
  const _ReaderLoanInfoCard({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final user = readerVm.findUserById(loan.userId);
    final readerName = user?.fullName ?? '';

    String? localizedReason;
    if (loan.reason != null && loan.reason!.isNotEmpty) {
      if (loan.reason == LoanService.expiredPickupReasonCode) {
        localizedReason = l10n.reasonExpiredPickup;
      } else if (loan.reason ==
          LoanService.readerCancelledReasonCode) {
        localizedReason = l10n.reasonReaderCancelled;
      } else {
        localizedReason = loan.reason;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.detailInfoSection,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DetailInfoRow(
            label: l10n.loanIdLabel,
            value: loan.id,
          ),
          DetailInfoRow(
            label: l10n.readerLabel,
            value: readerName,
          ),
          DetailInfoRow(
            label: l10n.createdAtLabel,
            value: DateFormatter.formatDate(loan.createdAt),
          ),
          DetailInfoRow(
            label: l10n.pickupDateShortLabel,
            value: DateFormatter.formatDate(loan.pickupDate),
          ),
          if (loan.borrowedAt != null)
            DetailInfoRow(
              label: l10n.borrowedAtLabel,
              value: DateFormatter.formatDateTime(loan.borrowedAt!),
            ),
          if (loan.dueAt != null)
            DetailInfoRow(
              label: loan.renewalCount > 0
                  ? l10n.newDueAtLabel
                  : l10n.dueAtLabel,
              value: DateFormatter.formatDateTime(loan.dueAt!),
            ),
          if (loan.renewalCount > 0)
            DetailInfoRow(
              label: l10n.renewalLabel,
              value: l10n.renewalUsedValue(loan.renewalCount),
            ),
          if (loan.returnedAt != null)
            DetailInfoRow(
              label: l10n.returnedAtLabel,
              value: DateFormatter.formatDateTime(loan.returnedAt!),
            ),
          if (loan.status == LoanStatus.rejected)
            DetailInfoRow(
              label: l10n.processedByLabel,
              value: l10n.librarianRoleName,
            ),
          if (localizedReason != null)
            DetailInfoRow(
              label: l10n.reasonLabel,
              value: localizedReason,
            ),
        ],
      ),
    );
  }
}

class _ReaderLoanActions extends StatelessWidget {
  const _ReaderLoanActions({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();

    if (readerVm.canCancel(loan)) {
      return OutlinedButton(
        key: const Key('reader-loan-cancel-button'),
        onPressed: readerVm.isSubmitting
            ? null
            : () => _showCancelLoanDialog(context, loan),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.danger,
          side: const BorderSide(
            color: AppTheme.danger,
          ),
        ),
        child: Text(
          l10n.cancelRequestButton,
        ),
      );
    }

    if (readerVm.canRenew(loan)) {
      return ElevatedButton(
        key: const Key('reader-loan-renew-button'),
        onPressed: readerVm.isSubmitting
            ? null
            : () => _showRenewLoanDialog(context, loan),
        child: Text(
          l10n.renewLoanButton,
        ),
      );
    }

    if (loan.status == LoanStatus.borrowed &&
        loan.renewalCount >= 1 &&
        !readerVm.isOverdue(loan)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: null,
            child: Text(
              l10n.noRenewalsLeftButton,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.backToMyLoansButton,
            ),
          ),
        ],
      );
    }

    if (loan.status == LoanStatus.cancelled) {
      final isExpired =
          loan.reason == LoanService.expiredPickupReasonCode;
      return OutlinedButton(
        onPressed: () {
          context.read<ReaderViewModel>().setTabIndex(0);
          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
        },
        child: Text(
          isExpired
              ? l10n.searchToRebookButton
              : l10n.exploreOtherBooksButton,
        ),
      );
    }

    if (loan.status == LoanStatus.rejected) {
      return OutlinedButton(
        onPressed: () {
          context.read<ReaderViewModel>().setTabIndex(0);
          Navigator.popUntil(
            context,
            (route) => route.isFirst,
          );
        },
        child: Text(
          l10n.findOtherBooksButton,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

Future<void> _showCancelLoanDialog(
  BuildContext context,
  Loan loan,
) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.cancelDialogTitle,
        ),
        content: Text(
          l10n.cancelDialogMessage(loan.id),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.keepLoanButton,
            ),
          ),
          ElevatedButton(
            key: const Key('confirm-cancel-loan-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
            ),
            child: Text(
              l10n.cancelRequestButton,
            ),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  try {
    await context.read<ReaderViewModel>().cancelLoan(loan.id);
  } on AppException {
    return;
  }
  if (!context.mounted) {
    return;
  }

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          l10n.cancelSuccessMessage,
        ),
      ),
    );
}

Future<void> _showRenewLoanDialog(
  BuildContext context,
  Loan loan,
) async {
  final l10n = AppLocalizations.of(context)!;
  final currentDue = loan.dueAt ?? DateTime.now();
  final newDue = currentDue.add(
    const Duration(days: AppConstants.renewalDays),
  );

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.renewDialogTitle,
        ),
        content: _RenewDialogContent(
          currentDueText: DateFormatter.formatDateTime(currentDue),
          newDueText: DateFormatter.formatDateTime(newDue),
          message: l10n.renewDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.laterButton,
            ),
          ),
          ElevatedButton(
            key: const Key('confirm-renew-loan-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.confirmRenewButton,
            ),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  final Loan updated;
  try {
    updated = await context.read<ReaderViewModel>().renewLoan(
      loan.id,
    );
  } on AppException {
    return;
  }
  if (!context.mounted) {
    return;
  }

  final formattedDue = DateFormatter.formatDateTime(
    updated.dueAt ?? newDue,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          l10n.renewSuccessMessage(formattedDue),
        ),
      ),
    );
}

class _RenewDialogContent extends StatelessWidget {
  const _RenewDialogContent({
    required this.currentDueText,
    required this.newDueText,
    required this.message,
  });

  final String currentDueText;
  final String newDueText;
  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailInfoRow(
          label: l10n.currentDueLabel,
          value: currentDueText,
        ),
        DetailInfoRow(
          label: l10n.newDueLabel,
          value: newDueText,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
