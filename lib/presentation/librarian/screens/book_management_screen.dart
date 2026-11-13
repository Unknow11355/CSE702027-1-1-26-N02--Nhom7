import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_exception.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/book.dart';
import '../../common/widgets/book_card.dart';
import '../librarian_viewmodel.dart';
import 'book_form_screen.dart';

class BookManagementSectionContent extends StatefulWidget {
  const BookManagementSectionContent({super.key});

  @override
  State<BookManagementSectionContent> createState() =>
      _BookManagementSectionContentState();
}

class _BookManagementSectionContentState
    extends State<BookManagementSectionContent> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = context
        .read<LibrarianViewModel>()
        .bookSearchQuery;
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
    final books = vm.filteredBooks;
    final showInactive = vm.showInactiveBooks;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextField(
          key: const Key('librarian-book-search-field'),
          controller: _searchController,
          onChanged: (value) {
            context.read<LibrarianViewModel>().setBookSearchQuery(
              value,
            );
          },
          decoration: InputDecoration(
            hintText: l10n.searchBookOrCodeHint,
            prefixIcon: const Icon(
              Icons.search,
              color: AppTheme.muted,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          key: const Key('librarian-add-book-button'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const BookFormScreen(),
              ),
            );
          },
          child: Text(
            l10n.addBookButton,
          ),
        ),
        const SizedBox(height: 12),
        _BookStatusFilterChips(
          showInactive: showInactive,
        ),
        const SizedBox(height: 16),
        for (final book in books) ...[
          _LibrarianBookCardItem(
            book: book,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _BookStatusFilterChips extends StatelessWidget {
  const _BookStatusFilterChips({
    required this.showInactive,
  });

  final bool showInactive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        FilterChip(
          key: const Key('librarian-books-active-chip'),
          label: Text(
            l10n.filterActiveBooks,
          ),
          selected: !showInactive,
          onSelected: (_) {
            context
                .read<LibrarianViewModel>()
                .setShowInactiveBooks(false);
          },
        ),
        FilterChip(
          key: const Key('librarian-books-inactive-chip'),
          label: Text(
            l10n.filterInactiveBooks,
          ),
          selected: showInactive,
          onSelected: (_) {
            context
                .read<LibrarianViewModel>()
                .setShowInactiveBooks(true);
          },
        ),
      ],
    );
  }
}

class _LibrarianBookCardItem extends StatelessWidget {
  const _LibrarianBookCardItem({
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final available = vm.availableCopies(book.id);

    final subtitle = book.isActive
        ? l10n.bookSummaryLine(
            book.id,
            book.totalCopies,
            available,
          )
        : l10n.bookInactiveSummaryLine(book.id);

    return BookCard(
      key: Key('librarian-book-card-${book.id}'),
      book: book,
      subtitle: subtitle,
      subtitleColor: book.isActive
          ? AppTheme.primary
          : AppTheme.muted,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => LibrarianBookInfoScreen(
              bookId: book.id,
            ),
          ),
        );
      },
    );
  }
}

class LibrarianBookInfoScreen extends StatelessWidget {
  const LibrarianBookInfoScreen({
    super.key,
    required this.bookId,
  });

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final book = vm.findBookById(bookId);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.bookInfoTitle,
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
          l10n.bookInfoTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _LibrarianBookInfoBody(
            book: book,
          ),
        ),
      ),
    );
  }
}

class _LibrarianBookInfoBody extends StatelessWidget {
  const _LibrarianBookInfoBody({
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final reserved = vm.reservedCopies(book.id);
    final borrowed = vm.borrowedCopies(book.id);
    final available = vm.availableCopies(book.id);
    final activeLoans = vm.activeLoanCountForBook(book.id);
    final hasHistory = vm.hasLoanHistory(book.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BookCard(
          book: book,
        ),
        const SizedBox(height: 16),
        _BookInventoryCard(
          bookId: book.id,
          totalCopies: book.totalCopies,
          reservedCopies: reserved,
          borrowedCopies: borrowed,
          availableCopies: available,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: const Key('book-info-edit-button'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => BookFormScreen(
                  existingBook: book,
                ),
              ),
            );
          },
          child: Text(
            l10n.editBookButton,
          ),
        ),
        const SizedBox(height: 12),
        if (book.isActive)
          OutlinedButton(
            key: const Key('book-info-deactivate-button'),
            onPressed: vm.isSubmitting
                ? null
                : () => _handleDeactivateTap(
                    context: context,
                    book: book,
                    activeLoanCount: activeLoans,
                  ),
            child: Text(
              l10n.deactivateBookButton,
            ),
          )
        else
          OutlinedButton(
            key: const Key('book-info-activate-button'),
            onPressed: vm.isSubmitting
                ? null
                : () {
                    context
                        .read<LibrarianViewModel>()
                        .activateBook(book.id);
                  },
            child: Text(
              l10n.activateBookButton,
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton(
          key: const Key('book-info-delete-button'),
          onPressed: vm.isSubmitting
              ? null
              : () => _handleDeleteTap(
                  context: context,
                  book: book,
                  activeLoanCount: activeLoans,
                  hasHistory: hasHistory,
                ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.danger,
            side: const BorderSide(
              color: AppTheme.danger,
            ),
          ),
          child: Text(
            l10n.deleteBookButton,
          ),
        ),
        const SizedBox(height: 16),
        if (activeLoans > 0)
          AppInfoBanner(
            icon: Icons.schedule,
            title: l10n.activeLoansOnBookBannerTitle,
            message: l10n.activeLoansOnBookBannerMessage,
            foregroundColor: AppTheme.warning,
            backgroundColor: AppTheme.warningSoft,
          )
        else if (hasHistory)
          AppInfoBanner(
            icon: Icons.info_outline,
            title: l10n.historyOnlyOnBookBannerTitle,
            message: l10n.historyOnlyOnBookBannerMessage,
          ),
      ],
    );
  }
}

class _BookInventoryCard extends StatelessWidget {
  const _BookInventoryCard({
    required this.bookId,
    required this.totalCopies,
    required this.reservedCopies,
    required this.borrowedCopies,
    required this.availableCopies,
  });

  final String bookId;
  final int totalCopies;
  final int reservedCopies;
  final int borrowedCopies;
  final int availableCopies;

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
            label: l10n.bookIdShortLabel,
            value: bookId,
          ),
          DetailInfoRow(
            label: l10n.totalCopiesLabel,
            value: totalCopies.toString(),
          ),
          DetailInfoRow(
            label: l10n.reservedCopiesLabel,
            value: reservedCopies.toString(),
          ),
          DetailInfoRow(
            label: l10n.borrowedCopiesLabel,
            value: borrowedCopies.toString(),
          ),
          DetailInfoRow(
            label: l10n.availableCopiesLabel,
            value: availableCopies.toString(),
          ),
        ],
      ),
    );
  }
}

Future<void> _handleDeactivateTap({
  required BuildContext context,
  required Book book,
  required int activeLoanCount,
}) async {
  if (activeLoanCount > 0) {
    await _showCannotDeactivateDialog(
      context: context,
      book: book,
      activeLoanCount: activeLoanCount,
    );
    return;
  }

  await _showDeactivateConfirmDialog(
    context: context,
    book: book,
  );
}

Future<void> _handleDeleteTap({
  required BuildContext context,
  required Book book,
  required int activeLoanCount,
  required bool hasHistory,
}) async {
  if (activeLoanCount > 0) {
    await _showCannotDeactivateDialog(
      context: context,
      book: book,
      activeLoanCount: activeLoanCount,
    );
    return;
  }

  if (hasHistory) {
    await _showDeactivateConfirmDialog(
      context: context,
      book: book,
    );
    return;
  }

  await _showDeleteConfirmDialog(
    context: context,
    book: book,
  );
}

Future<void> _showCannotDeactivateDialog({
  required BuildContext context,
  required Book book,
  required int activeLoanCount,
}) async {
  final l10n = AppLocalizations.of(context)!;

  final openLoans = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.cannotDeactivateDialogTitle,
        ),
        content: Text(
          l10n.cannotDeactivateDialogMessage(activeLoanCount),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.closeButton,
            ),
          ),
          ElevatedButton(
            key: const Key('dialog-view-related-loans-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.viewRelatedLoansButton,
            ),
          ),
        ],
      );
    },
  );

  if (openLoans == true && context.mounted) {
    context.read<LibrarianViewModel>().openLoansTab(
      searchQuery: book.id,
    );
    Navigator.pop(context);
  }
}

Future<void> _showDeactivateConfirmDialog({
  required BuildContext context,
  required Book book,
}) async {
  final l10n = AppLocalizations.of(context)!;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.deactivateBookDialogTitle,
        ),
        content: Text(
          l10n.deactivateBookDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.backTooltip,
            ),
          ),
          ElevatedButton(
            key: const Key('confirm-deactivate-book-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.deactivateBookButton,
            ),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  final vm = context.read<LibrarianViewModel>();
  try {
    await vm.deactivateBook(book.id);
  } on AppException {
    if (!context.mounted) {
      return;
    }
    await _showCannotDeactivateDialog(
      context: context,
      book: book,
      activeLoanCount: vm.activeLoanCountForBook(book.id),
    );
    return;
  }
  if (!context.mounted) {
    return;
  }

  vm.setShowInactiveBooks(true);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          l10n.deactivateSuccessMessage,
        ),
      ),
    );
  Navigator.pop(context);
}

Future<void> _showDeleteConfirmDialog({
  required BuildContext context,
  required Book book,
}) async {
  final l10n = AppLocalizations.of(context)!;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(
          l10n.deleteBookDialogTitle(book.id),
        ),
        content: Text(
          l10n.deleteBookDialogMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              l10n.keepBookButton,
            ),
          ),
          ElevatedButton(
            key: const Key('confirm-delete-book-button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
            ),
            child: Text(
              l10n.deleteBookButton,
            ),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  final vm = context.read<LibrarianViewModel>();
  try {
    await vm.deleteBook(book.id);
  } on AppException catch (error) {
    if (!context.mounted) {
      return;
    }
    if (error.code == 'book_has_active_loans') {
      await _showCannotDeactivateDialog(
        context: context,
        book: book,
        activeLoanCount: vm.activeLoanCountForBook(book.id),
      );
    } else if (error.code == 'book_has_loan_history') {
      await _showDeactivateConfirmDialog(
        context: context,
        book: book,
      );
    }
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
          l10n.deleteBookSuccessMessage,
        ),
      ),
    );
  Navigator.pop(context);
}
