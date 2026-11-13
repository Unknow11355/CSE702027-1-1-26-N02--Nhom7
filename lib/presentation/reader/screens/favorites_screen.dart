import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/book.dart';
import '../../common/widgets/book_card.dart';
import '../reader_viewmodel.dart';
import 'book_detail_screen.dart';

class FavoritesSectionContent extends StatelessWidget {
  const FavoritesSectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    final readerVm = context.watch<ReaderViewModel>();
    final favorites = readerVm.favoriteBooks;

    if (favorites.isEmpty) {
      return const SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: _EmptyFavoritesContent(),
      );
    }

    return _FavoriteBooksListView(
      books: favorites,
    );
  }
}

class _FavoriteBooksListView extends StatelessWidget {
  const _FavoriteBooksListView({
    required this.books,
  });

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          l10n.savedBooksCountLabel(books.length),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.muted,
          ),
        ),
        const SizedBox(height: 12),
        for (final book in books) ...[
          _FavoriteBookCardItem(
            book: book,
            availableCopies: readerVm.availableCopies(book.id),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FavoriteBookCardItem extends StatelessWidget {
  const _FavoriteBookCardItem({
    required this.book,
    required this.availableCopies,
  });

  final Book book;
  final int availableCopies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subtitle = availableCopies > 0
        ? l10n.copiesRatioLabel(availableCopies, book.totalCopies)
        : l10n.outOfCopiesLabel;

    return BookCard(
      key: Key('favorite-book-card-${book.id}'),
      book: book,
      subtitle: subtitle,
      subtitleColor: availableCopies > 0
          ? AppTheme.success
          : AppTheme.danger,
      isFavorite: true,
      onToggleFavorite: () {
        context.read<ReaderViewModel>().toggleFavorite(book.id);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                l10n.favoriteRemovedMessage,
              ),
            ),
          );
      },
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
    );
  }
}

class _EmptyFavoritesContent extends StatelessWidget {
  const _EmptyFavoritesContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 48,
            color: AppTheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.emptyFavoritesTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.emptyFavoritesSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            key: const Key('empty-favorites-explore-button'),
            onPressed: () {
              context.read<ReaderViewModel>().setTabIndex(0);
            },
            child: Text(
              l10n.exploreBooksButton,
            ),
          ),
        ],
      ),
    );
  }
}
