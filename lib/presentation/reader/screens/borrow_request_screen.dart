import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_constants.dart';
import '../../../core/app_exception.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/book.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../reader_viewmodel.dart';
import 'loan_detail_screen.dart';

class BorrowRequestScreen extends StatefulWidget {
  const BorrowRequestScreen({
    super.key,
    required this.bookId,
  });

  final String bookId;

  @override
  State<BorrowRequestScreen> createState() =>
      _BorrowRequestScreenState();
}

class _BorrowRequestScreenState extends State<BorrowRequestScreen> {
  late DateTime _selectedDate;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _selectedDate = today.add(const Duration(days: 1));
    _dateController = TextEditingController(
      text: DateFormatter.formatDate(_selectedDate),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickPickupDate() async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final maxDate = today.add(
      const Duration(days: AppConstants.loanDays),
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: today,
      lastDate: maxDate,
      helpText: l10n.datePickerHelpText,
      cancelText: l10n.datePickerCancelButton,
      confirmText: l10n.datePickerConfirmButton,
    );

    if (!mounted || picked == null) {
      return;
    }

    setState(() {
      _selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
      );
      _dateController.text = DateFormatter.formatDate(
        _selectedDate,
      );
    });
  }

  Future<void> _submitRequest() async {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.read<ReaderViewModel>();

    try {
      final createdLoan = await readerVm.createBorrowRequest(
        bookId: widget.bookId,
        pickupDate: _selectedDate,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.borrowRequestSuccessMessage,
            ),
          ),
        );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (_) => ReaderLoanDetailScreen(
            loanId: createdLoan.id,
          ),
        ),
      );
    } on AppException {
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final book = readerVm.findBookById(widget.bookId);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.borrowRequestTitle,
          ),
        ),
        body: const SizedBox.shrink(),
      );
    }

    final activeCount = readerVm.activeLoanCount;
    final isLimitReached = activeCount >= AppConstants.maxActiveLoans;

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
          l10n.borrowRequestTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: isLimitReached
              ? _LimitReachedContent(
                  book: book,
                  activeCount: activeCount,
                )
              : _BorrowFormContent(
                  book: book,
                  activeCount: activeCount,
                  dateController: _dateController,
                  isSubmitting: readerVm.isSubmitting,
                  onPickDate: _pickPickupDate,
                  onSubmit: _submitRequest,
                ),
        ),
      ),
    );
  }
}

class _LimitReachedContent extends StatelessWidget {
  const _LimitReachedContent({
    required this.book,
    required this.activeCount,
  });

  final Book book;
  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final available = readerVm.availableCopies(book.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BookCard(
          book: book,
          subtitle: l10n.copiesRatioLabel(
            available,
            book.totalCopies,
          ),
        ),
        const SizedBox(height: 16),
        AppInfoBanner(
          icon: Icons.schedule,
          title: l10n.limitReachedBannerTitle,
          message: l10n.limitReachedBannerMessage,
          foregroundColor: AppTheme.warning,
          backgroundColor: AppTheme.warningSoft,
        ),
        const SizedBox(height: 16),
        _LimitReachedDetailCard(
          activeCount: activeCount,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: null,
          child: Text(
            l10n.limitReachedButton,
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          key: const Key('borrow-limit-view-my-loans-button'),
          onPressed: () {
            context.read<ReaderViewModel>().setTabIndex(1);
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          },
          child: Text(
            l10n.viewMyLoansButton,
          ),
        ),
      ],
    );
  }
}

class _LimitReachedDetailCard extends StatelessWidget {
  const _LimitReachedDetailCard({
    required this.activeCount,
  });

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            label: l10n.activeLoansShortLabel,
            value: l10n.activeLoansRatioValue(
              activeCount,
              AppConstants.maxActiveLoans,
            ),
          ),
        ],
      ),
    );
  }
}

class _BorrowFormContent extends StatelessWidget {
  const _BorrowFormContent({
    required this.book,
    required this.activeCount,
    required this.dateController,
    required this.isSubmitting,
    required this.onPickDate,
    required this.onSubmit,
  });

  final Book book;
  final int activeCount;
  final TextEditingController dateController;
  final bool isSubmitting;
  final VoidCallback onPickDate;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BookCard(
          book: book,
          subtitle: l10n.oneCopyCounterPickup,
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('borrow-pickup-date-field'),
          controller: dateController,
          readOnly: true,
          onTap: onPickDate,
          decoration: InputDecoration(
            labelText: l10n.pickupDateLabel,
            helperText: l10n.pickupDateHelper,
            suffixIcon: IconButton(
              tooltip: l10n.selectPickupDateTooltip,
              onPressed: onPickDate,
              icon: const Icon(
                Icons.calendar_today,
                color: AppTheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _BorrowSummaryCard(
          activeCount: activeCount,
        ),
        const SizedBox(height: 16),
        AppInfoBanner(
          icon: Icons.info_outline,
          title: l10n.holdNoticeBannerTitle,
          message: l10n.holdNoticeBannerMessage,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: const Key('borrow-submit-button'),
          onPressed: isSubmitting ? null : onSubmit,
          child: Text(
            l10n.submitBorrowRequestButton,
          ),
        ),
      ],
    );
  }
}

class _BorrowSummaryCard extends StatelessWidget {
  const _BorrowSummaryCard({
    required this.activeCount,
  });

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
            label: l10n.activeLoansCountLabel,
            value: l10n.activeLoansRatioValue(
              activeCount,
              AppConstants.maxActiveLoans,
            ),
          ),
          DetailInfoRow(
            label: l10n.loanDurationLabel,
            value: l10n.loanDurationFromPickupValue,
          ),
          DetailInfoRow(
            label: l10n.holdDeadlineLabel,
            value: l10n.holdDeadlineValue,
          ),
        ],
      ),
    );
  }
}
