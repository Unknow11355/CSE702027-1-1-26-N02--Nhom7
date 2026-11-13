import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_exception.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/loan.dart';
import '../../../models/loan_status.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../librarian_viewmodel.dart';

class LibrarianLoanDetailScreen extends StatelessWidget {
  const LibrarianLoanDetailScreen({
    super.key,
    required this.loanId,
  });

  final String loanId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final loan = vm.findLoanById(loanId);

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
          child: _LibrarianLoanDetailBody(
            loan: loan,
          ),
        ),
      ),
    );
  }
}

class _LibrarianLoanDetailBody extends StatelessWidget {
  const _LibrarianLoanDetailBody({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LibrarianViewModel>();
    final book = vm.findBookById(loan.bookId);
    final isOverdue = vm.isOverdue(loan);

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
          ),
          const SizedBox(height: 16),
        ],
        _LibrarianLoanBanner(
          loan: loan,
        ),
        const SizedBox(height: 16),
        _LibrarianLoanInfoCard(
          loan: loan,
        ),
        const SizedBox(height: 20),
        _LibrarianLoanActions(
          loan: loan,
        ),
      ],
    );
  }
}

class _LibrarianLoanBanner extends StatelessWidget {
  const _LibrarianLoanBanner({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();

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
        if (vm.isOverdue(loan)) {
          return AppInfoBanner(
            icon: Icons.warning_amber,
            title: l10n.overdueLoanBannerTitle(
              vm.overdueDays(loan),
            ),
            message: l10n.overdueLoanBannerMessage,
            foregroundColor: AppTheme.danger,
            backgroundColor: AppTheme.dangerSoft,
          );
        }
        return AppInfoBanner(
          icon: Icons.info_outline,
          title: l10n.borrowedBannerTitle(
            vm.daysUntilDue(loan),
          ),
          message: l10n.borrowedRenewableBannerMessage,
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
          title: l10n.rejectedLibrarianBannerTitle,
          message: l10n.rejectedBannerMessage(
            loan.reason ?? '',
          ),
          foregroundColor: AppTheme.warning,
          backgroundColor: AppTheme.warningSoft,
        );
      case LoanStatus.cancelled:
        return AppInfoBanner(
          icon: Icons.schedule,
          title: l10n.cancelledBannerTitle,
          message: l10n.cancelledBannerMessage,
          foregroundColor: AppTheme.warning,
          backgroundColor: AppTheme.warningSoft,
        );
    }
  }
}

class _LibrarianLoanInfoCard extends StatelessWidget {
  const _LibrarianLoanInfoCard({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final user = vm.findUserById(loan.userId);
    final availableAfter = vm.availableCopies(loan.bookId);

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
            value: user?.fullName ?? '',
          ),
          DetailInfoRow(
            label: l10n.accountLabel,
            value: user?.username ?? '',
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
              label: l10n.dueAtLabel,
              value: DateFormatter.formatDateTime(loan.dueAt!),
            ),
          if (loan.returnedAt != null)
            DetailInfoRow(
              label: l10n.returnedAtLabel,
              value: DateFormatter.formatDateTime(loan.returnedAt!),
            ),
          if (loan.status == LoanStatus.rejected)
            DetailInfoRow(
              label: l10n.availableAfterProcessLabel,
              value: l10n.copiesCountValue(availableAfter),
            ),
        ],
      ),
    );
  }
}

class _LibrarianLoanActions extends StatelessWidget {
  const _LibrarianLoanActions({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();

    if (loan.status == LoanStatus.pending) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            key: const Key('librarian-approve-loan-button'),
            onPressed: vm.isSubmitting
                ? null
                : () => _handleApprove(context, loan.id),
            child: Text(
              l10n.approveRequestButton,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('librarian-reject-loan-button'),
            onPressed: vm.isSubmitting
                ? null
                : () => _showRejectDialog(context, loan),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.danger,
              side: const BorderSide(
                color: AppTheme.danger,
              ),
            ),
            child: Text(
              l10n.rejectRequestButton,
            ),
          ),
        ],
      );
    }

    if (loan.status == LoanStatus.readyForPickup) {
      return ElevatedButton(
        key: const Key('librarian-handover-loan-button'),
        onPressed: vm.isSubmitting
            ? null
            : () => _showHandoverDialog(context, loan),
        child: Text(
          l10n.confirmHandoverButton,
        ),
      );
    }

    if (loan.status == LoanStatus.borrowed) {
      return ElevatedButton(
        key: const Key('librarian-return-loan-button'),
        onPressed: vm.isSubmitting
            ? null
            : () => _showReturnDialog(context, loan),
        child: Text(
          l10n.confirmReturnButton,
        ),
      );
    }

    return OutlinedButton(
      key: const Key('librarian-back-to-loans-button'),
      onPressed: () => Navigator.pop(context),
      child: Text(
        l10n.backToLoanListButton,
      ),
    );
  }
}

Future<void> _handleApprove(
  BuildContext context,
  String loanId,
) async {
  final l10n = AppLocalizations.of(context)!;
  try {
    await context.read<LibrarianViewModel>().approveLoan(loanId);
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
          l10n.approveSuccessMessage,
        ),
      ),
    );
}

Future<void> _showRejectDialog(
  BuildContext context,
  Loan loan,
) async {
  final l10n = AppLocalizations.of(context)!;
  final reason = await showDialog<String>(
    context: context,
    builder: (_) => const _RejectReasonDialog(),
  );

  if (reason == null || reason.isEmpty || !context.mounted) {
    return;
  }

  try {
    await context.read<LibrarianViewModel>().rejectLoan(
      loanId: loan.id,
      reason: reason,
    );
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
          l10n.rejectSuccessMessage,
        ),
      ),
    );
}

class _RejectReasonDialog extends StatefulWidget {
  const _RejectReasonDialog();

  @override
  State<_RejectReasonDialog> createState() =>
      _RejectReasonDialogState();
}

class _RejectReasonDialogState extends State<_RejectReasonDialog> {
  late final TextEditingController _reasonController;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _confirm() {
    final l10n = AppLocalizations.of(context)!;
    final trimmed = _reasonController.text.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _errorText = l10n.errorRequiredField;
      });
      return;
    }
    Navigator.pop(context, trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        l10n.rejectDialogTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rejectDialogSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('reject-reason-field'),
            controller: _reasonController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: l10n.rejectReasonLabel,
              hintText: l10n.rejectReasonHint,
              errorText: _errorText,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.backTooltip,
          ),
        ),
        ElevatedButton(
          key: const Key('confirm-reject-loan-button'),
          onPressed: _confirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.danger,
          ),
          child: Text(
            l10n.confirmRejectButton,
          ),
        ),
      ],
    );
  }
}

Future<void> _showHandoverDialog(
  BuildContext context,
  Loan loan,
) async {
  final l10n = AppLocalizations.of(context)!;
  final vm = context.read<LibrarianViewModel>();
  final user = vm.findUserById(loan.userId);
  final book = vm.findBookById(loan.bookId);
  final now = DateTime.now();
  final expectedDue = now.add(
    const Duration(days: AppConstants.loanDays),
  );

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.handoverDialogTitle,
        ),
        content: _HandoverDialogContent(
          subtitle: l10n.handoverDialogSubtitle(
            user?.fullName ?? '',
            book?.title ?? '',
          ),
          pickupTimeText: DateFormatter.formatDateTime(now),
          expectedDueText: DateFormatter.formatDateTime(expectedDue),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.notHandedOverButton,
            ),
          ),
          ElevatedButton(
            key: const Key('confirm-handover-dialog-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.confirmHandedOverButton,
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
    await context.read<LibrarianViewModel>().confirmHandover(loan.id);
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
          l10n.handoverSuccessMessage,
        ),
      ),
    );
}

class _HandoverDialogContent extends StatelessWidget {
  const _HandoverDialogContent({
    required this.subtitle,
    required this.pickupTimeText,
    required this.expectedDueText,
  });

  final String subtitle;
  final String pickupTimeText;
  final String expectedDueText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 12),
        DetailInfoRow(
          label: l10n.pickupTimeLabel,
          value: pickupTimeText,
        ),
        DetailInfoRow(
          label: l10n.expectedDueDateLabel,
          value: expectedDueText,
        ),
      ],
    );
  }
}

Future<void> _showReturnDialog(
  BuildContext context,
  Loan loan,
) async {
  final l10n = AppLocalizations.of(context)!;
  final vm = context.read<LibrarianViewModel>();
  final user = vm.findUserById(loan.userId);
  final book = vm.findBookById(loan.bookId);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.returnDialogTitle,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.returnDialogSubtitle(
                book?.title ?? '',
                user?.fullName ?? '',
              ),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.returnDialogMessage(loan.id),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.notReturnedYetButton,
            ),
          ),
          ElevatedButton(
            key: const Key('confirm-return-dialog-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.confirmReturnDialogButton,
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
    await context.read<LibrarianViewModel>().confirmReturn(loan.id);
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
          l10n.returnSuccessMessage,
        ),
      ),
    );
}
