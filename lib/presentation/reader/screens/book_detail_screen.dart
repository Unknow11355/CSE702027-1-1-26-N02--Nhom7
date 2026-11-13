import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/book.dart';
import '../../../models/loan.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../reader_viewmodel.dart';
import 'borrow_request_screen.dart';
import 'loan_detail_screen.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({
    super.key,
    required this.bookId,
  });

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final book = readerVm.findBookById(bookId);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.bookDetailTitle,
          ),
        ),
        body: const SizedBox.shrink(),
      );
    }

    final isFav = readerVm.isFavorite(bookId);

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
          l10n.bookDetailTitle,
        ),
        actions: [
          IconButton(
            key: const Key('book-detail-favorite-icon-button'),
            tooltip: isFav
                ? l10n.removeFromFavoritesButton
                : l10n.addToFavoritesButton,
            onPressed: () => _handleToggleFavorite(
              context,
              book.id,
            ),
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppTheme.danger : AppTheme.ink,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: _BookDetailBody(
            book: book,
          ),
        ),
      ),
    );
  }
}

void _handleToggleFavorite(
  BuildContext context,
  String bookId,
) {
  final l10n = AppLocalizations.of(context)!;
  final added = context.read<ReaderViewModel>().toggleFavorite(
    bookId,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          added
              ? l10n.favoriteAddedMessage
              : l10n.favoriteRemovedMessage,
        ),
      ),
    );
}

class _BookDetailBody extends StatelessWidget {
  const _BookDetailBody({
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final available = readerVm.availableCopies(book.id);
    final activeLoan = readerVm.activeLoanForBook(book.id);
    final isFav = readerVm.isFavorite(book.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BookHeroCard(
          book: book,
          availableCopies: available,
        ),
        const SizedBox(height: 16),
        _BookStatusAndActions(
          book: book,
          availableCopies: available,
          activeLoan: activeLoan,
          isFavorite: isFav,
        ),
        const SizedBox(height: 20),
        _BookAboutCard(
          description: book.description,
        ),
        const SizedBox(height: 16),
        _BookSpecCard(
          l10n: l10n,
        ),
      ],
    );
  }
}

class _BookHeroCard extends StatelessWidget {
  const _BookHeroCard({
    required this.book,
    required this.availableCopies,
  });

  final Book book;
  final int availableCopies;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.outline,
        ),
      ),
      child: _BookHeroRow(
        book: book,
        availableCopies: availableCopies,
      ),
    );
  }
}

class _BookHeroRow extends StatelessWidget {
  const _BookHeroRow({
    required this.book,
    required this.availableCopies,
  });

  final Book book;
  final int availableCopies;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookCoverImage(
          coverAsset: book.coverAsset,
          width: 96,
          height: 138,
          borderRadius: 10,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _BookHeroInfoColumn(
            book: book,
            availableCopies: availableCopies,
          ),
        ),
      ],
    );
  }
}

class _BookHeroInfoColumn extends StatelessWidget {
  const _BookHeroInfoColumn({
    required this.book,
    required this.availableCopies,
  });

  final Book book;
  final int availableCopies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final categoryLabel = book.category == 'Văn học'
        ? l10n.categoryLiterature.toUpperCase()
        : book.category == 'Khoa học'
        ? l10n.categoryScience.toUpperCase()
        : book.category.toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryLabel,
          style: textTheme.bodySmall?.copyWith(
            color: AppTheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          book.title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          book.author,
          style: textTheme.bodyMedium?.copyWith(
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.copiesRatioLabel(availableCopies, book.totalCopies),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: availableCopies > 0
                ? AppTheme.success
                : AppTheme.danger,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.bookIdPrefix(book.id),
          style: textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _BookStatusAndActions extends StatelessWidget {
  const _BookStatusAndActions({
    required this.book,
    required this.availableCopies,
    required this.activeLoan,
    required this.isFavorite,
  });

  final Book book;
  final int availableCopies;
  final Loan? activeLoan;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (activeLoan != null) {
      final statusText = LoanStatusBadge.localizedLabel(
        l10n,
        activeLoan!.status,
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInfoBanner(
            icon: Icons.info_outline,
            title: l10n.duplicateActiveLoanBannerTitle,
            message: l10n.duplicateActiveLoanBannerMessage(
              activeLoan!.id,
              statusText,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            key: const Key('book-detail-view-existing-loan-button'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => ReaderLoanDetailScreen(
                    loanId: activeLoan!.id,
                  ),
                ),
              );
            },
            child: Text(
              l10n.viewLoanButton(activeLoan!.id),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: null,
            child: Text(
              l10n.alreadyHasActiveLoanButton,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            key: const Key('book-detail-favorite-button'),
            onPressed: () => _handleToggleFavorite(
              context,
              book.id,
            ),
            child: Text(
              isFavorite
                  ? l10n.removeFromFavoritesButton
                  : l10n.addToFavoritesButton,
            ),
          ),
        ],
      );
    }

    if (availableCopies <= 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppInfoBanner(
            icon: Icons.schedule,
            title: l10n.outOfCopiesBannerTitle,
            message: l10n.outOfCopiesBannerMessage,
            foregroundColor: AppTheme.warning,
            backgroundColor: AppTheme.warningSoft,
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: null,
            child: Text(
              l10n.outOfStockButton,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            key: const Key('book-detail-favorite-button'),
            onPressed: () => _handleToggleFavorite(
              context,
              book.id,
            ),
            child: Text(
              isFavorite
                  ? l10n.removeFromFavoritesButton
                  : l10n.addToFavoritesButton,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          key: const Key('book-detail-borrow-button'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => BorrowRequestScreen(
                  bookId: book.id,
                ),
              ),
            );
          },
          child: Text(
            l10n.requestBorrowButton,
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          key: const Key('book-detail-favorite-button'),
          onPressed: () => _handleToggleFavorite(
            context,
            book.id,
          ),
          child: Text(
            isFavorite
                ? l10n.removeFromFavoritesButton
                : l10n.addToFavoritesButton,
          ),
        ),
      ],
    );
  }
}

class _BookAboutCard extends StatelessWidget {
  const _BookAboutCard({
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

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
            l10n.aboutBookSection,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: AppTheme.muted,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookSpecCard extends StatelessWidget {
  const _BookSpecCard({
    required this.l10n,
  });

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
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
            label: l10n.formatLabel,
            value: l10n.formatPhysicalBook,
          ),
          DetailInfoRow(
            label: l10n.loanDurationLabel,
            value: l10n.loanDurationValue,
          ),
          DetailInfoRow(
            label: l10n.perLoanLabel,
            value: l10n.perLoanValue,
          ),
        ],
      ),
    );
  }
}
