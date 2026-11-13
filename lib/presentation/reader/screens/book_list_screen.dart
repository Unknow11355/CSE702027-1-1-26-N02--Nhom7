import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/book.dart';
import '../../common/settings_screen.dart';
import '../../common/widgets/book_card.dart';
import '../reader_viewmodel.dart';
import 'book_detail_screen.dart';
import 'favorites_screen.dart';
import 'my_loans_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen>
    with WidgetsBindingObserver {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ReaderViewModel>()
        ..setTabIndex(0)
        ..runStartupChecks();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ReaderViewModel>().runStartupChecks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final tabIndex = readerVm.selectedTabIndex;

    if (_searchController.text != readerVm.searchQuery) {
      _searchController.value = TextEditingValue(
        text: readerVm.searchQuery,
        selection: TextSelection.collapsed(
          offset: readerVm.searchQuery.length,
        ),
      );
    }

    return Scaffold(
      appBar: _createReaderAppBar(
        context: context,
        l10n: l10n,
        readerVm: readerVm,
      ),
      body: SafeArea(
        child: _ReaderTabBody(
          tabIndex: tabIndex,
          searchController: _searchController,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.nav,
        selectedIndex: tabIndex,
        onDestinationSelected: (index) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.read<ReaderViewModel>().setTabIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.menu_book,
            ),
            label: l10n.navExplore,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.receipt_long,
            ),
            label: l10n.navMyLoans,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.favorite_border,
            ),
            label: l10n.navFavorites,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.person,
            ),
            label: l10n.navAccount,
          ),
        ],
      ),
    );
  }
}

PreferredSizeWidget _createReaderAppBar({
  required BuildContext context,
  required AppLocalizations l10n,
  required ReaderViewModel readerVm,
}) {
  final tabIndex = readerVm.selectedTabIndex;

  if (tabIndex == 0 && readerVm.isSearchMode) {
    return AppBar(
      leading: IconButton(
        tooltip: l10n.backTooltip,
        onPressed: () {
          context.read<ReaderViewModel>().closeSearch();
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
      title: Text(
        l10n.searchBooksTitle,
      ),
    );
  }

  if (tabIndex == 0) {
    return AppBar(
      title: Text(
        l10n.appTitle,
      ),
      actions: [
        IconButton(
          key: const Key('reader-home-language-button'),
          tooltip: l10n.changeLanguage,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const LanguageScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.language,
          ),
        ),
        IconButton(
          key: const Key('reader-home-account-button'),
          tooltip: l10n.navAccount,
          onPressed: () {
            context.read<ReaderViewModel>().setTabIndex(3);
          },
          icon: const Icon(
            Icons.person,
          ),
        ),
      ],
    );
  }

  if (tabIndex == 1) {
    return AppBar(
      title: Text(
        readerVm.showLoanHistory
            ? l10n.loanHistoryTitle
            : l10n.myLoansTitle,
      ),
    );
  }

  if (tabIndex == 2) {
    return AppBar(
      title: Text(
        l10n.favoritesTitle,
      ),
    );
  }

  return AppBar(
    title: Text(
      l10n.accountTitle,
    ),
  );
}

class _ReaderTabBody extends StatelessWidget {
  const _ReaderTabBody({
    required this.tabIndex,
    required this.searchController,
  });

  final int tabIndex;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    if (tabIndex == 1) {
      return const MyLoansSectionContent();
    }
    if (tabIndex == 2) {
      return const FavoritesSectionContent();
    }
    if (tabIndex == 3) {
      return AccountSectionContent(
        onOpenMyLoans: () {
          context.read<ReaderViewModel>().setTabIndex(1);
        },
      );
    }

    final isSearch = context.watch<ReaderViewModel>().isSearchMode;
    if (isSearch) {
      return _ReaderSearchSection(
        searchController: searchController,
      );
    }

    return _ReaderExploreSection(
      searchController: searchController,
    );
  }
}

class _ReaderExploreSection extends StatelessWidget {
  const _ReaderExploreSection({
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final shelfBooks = readerVm.shelfBooks;
    final suggestedBooks = readerVm.suggestedBooks;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          l10n.readerGreeting(readerVm.readerShortName),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        _ReaderSearchBarField(
          controller: searchController,
        ),
        const SizedBox(height: 12),
        const _CategoryChipsBar(),
        const SizedBox(height: 16),
        const _DueSoonReminderBanner(),
        _SectionHeaderRow(
          title: l10n.exploreShelvesTitle,
          actionLabel: l10n.viewAllButton,
          onAction: () {
            context.read<ReaderViewModel>().openSearch();
          },
        ),
        const SizedBox(height: 10),
        _ShelfBooksRow(
          books: shelfBooks,
        ),
        const SizedBox(height: 20),
        Text(
          l10n.suggestedForYouTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        for (final book in suggestedBooks) ...[
          _ExploreBookCardItem(
            book: book,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ReaderSearchBarField extends StatelessWidget {
  const _ReaderSearchBarField({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      key: const Key('reader-search-field'),
      controller: controller,
      onChanged: (value) {
        context.read<ReaderViewModel>().setSearchQuery(value);
      },
      decoration: InputDecoration(
        hintText: l10n.searchBooksHint,
        prefixIcon: const Icon(
          Icons.search,
          color: AppTheme.muted,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                tooltip: l10n.clearFiltersButton,
                onPressed: () {
                  context.read<ReaderViewModel>().clearFilters();
                },
                icon: const Icon(
                  Icons.close,
                ),
              )
            : null,
      ),
    );
  }
}

class _CategoryChipsBar extends StatelessWidget {
  const _CategoryChipsBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final selected = readerVm.selectedCategory;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            key: const Key('category-chip-all'),
            label: Text(
              l10n.categoryAll,
            ),
            selected: selected == null,
            onSelected: (_) {
              context.read<ReaderViewModel>().setCategory(null);
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            key: const Key('category-chip-literature'),
            label: Text(
              l10n.categoryLiterature,
            ),
            selected: selected == 'Văn học',
            onSelected: (_) {
              context.read<ReaderViewModel>().setCategory(
                'Văn học',
              );
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            key: const Key('category-chip-science'),
            label: Text(
              l10n.categoryScience,
            ),
            selected: selected == 'Khoa học',
            onSelected: (_) {
              context.read<ReaderViewModel>().setCategory(
                'Khoa học',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DueSoonReminderBanner extends StatelessWidget {
  const _DueSoonReminderBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final reminders = readerVm.dueSoonOrOverdueLoans;

    if (reminders.isEmpty) {
      return const SizedBox.shrink();
    }

    final firstLoan = reminders.first;
    final book = readerVm.findBookById(firstLoan.bookId);
    final bookTitle = book?.title ?? firstLoan.bookId;
    final isOverdue = readerVm.isOverdue(firstLoan);

    final String bannerTitle;
    final String bannerSubtitle;
    if (isOverdue) {
      bannerTitle = l10n.overdueBannerReaderTitle(reminders.length);
      bannerSubtitle = l10n.overdueBannerReaderSubtitle(
        bookTitle,
        readerVm.overdueDays(firstLoan),
      );
    } else {
      bannerTitle = l10n.dueSoonBannerTitle(reminders.length);
      bannerSubtitle = l10n.dueSoonBannerSubtitle(
        bookTitle,
        readerVm.daysUntilDue(firstLoan),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AppInfoBanner(
        key: const Key('reader-due-soon-banner'),
        icon: isOverdue ? Icons.warning_amber : Icons.schedule,
        title: bannerTitle,
        message: bannerSubtitle,
        foregroundColor: isOverdue
            ? AppTheme.danger
            : AppTheme.warning,
        backgroundColor: isOverdue
            ? AppTheme.dangerSoft
            : AppTheme.warningSoft,
        onTap: () {
          context.read<ReaderViewModel>().setTabIndex(1);
        },
      ),
    );
  }
}

class _SectionHeaderRow extends StatelessWidget {
  const _SectionHeaderRow({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          key: const Key('explore-view-all-button'),
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 40),
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          onPressed: onAction,
          child: Text(
            actionLabel,
          ),
        ),
      ],
    );
  }
}

class _ShelfBooksRow extends StatelessWidget {
  const _ShelfBooksRow({
    required this.books,
  });

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();

    if (books.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < books.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: ShelfBookTile(
              key: Key('shelf-book-tile-${books[i].id}'),
              book: books[i],
              availabilityLabel:
                  readerVm.availableCopies(books[i].id) > 0
                  ? l10n.copiesAvailableShort(
                      readerVm.availableCopies(books[i].id),
                    )
                  : l10n.outOfCopiesLabel,
              isAvailable: readerVm.availableCopies(books[i].id) > 0,
              isFavorite: readerVm.isFavorite(books[i].id),
              onToggleFavorite: () {
                final added = context
                    .read<ReaderViewModel>()
                    .toggleFavorite(books[i].id);
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
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => BookDetailScreen(
                      bookId: books[i].id,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ExploreBookCardItem extends StatelessWidget {
  const _ExploreBookCardItem({
    required this.book,
  });

  final Book book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final available = readerVm.availableCopies(book.id);

    return BookCard(
      key: Key('book-card-${book.id}'),
      book: book,
      subtitle: available > 0
          ? l10n.copiesRatioLabel(available, book.totalCopies)
          : l10n.outOfCopiesLabel,
      subtitleColor: available > 0
          ? AppTheme.success
          : AppTheme.danger,
      isFavorite: readerVm.isFavorite(book.id),
      onToggleFavorite: () {
        final added = context
            .read<ReaderViewModel>()
            .toggleFavorite(book.id);
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

class _ReaderSearchSection extends StatelessWidget {
  const _ReaderSearchSection({
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final readerVm = context.watch<ReaderViewModel>();
    final results = readerVm.filteredBooks;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _ReaderSearchBarField(
          controller: searchController,
        ),
        const SizedBox(height: 12),
        const _CategoryChipsBar(),
        const SizedBox(height: 16),
        if (results.isEmpty)
          const _EmptySearchState()
        else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.bookCountLabel(results.length),
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(
                      color: AppTheme.muted,
                    ),
              ),
              const Icon(
                Icons.filter_list,
                size: 20,
                color: AppTheme.muted,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final book in results) ...[
            _ExploreBookCardItem(
              book: book,
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  const _EmptySearchState();

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
            Icons.search,
            size: 48,
            color: AppTheme.muted,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.noBooksFoundTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.noBooksFoundSubtitle,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            key: const Key('clear-search-filters-button'),
            onPressed: () {
              context.read<ReaderViewModel>().clearFilters();
            },
            child: Text(
              l10n.clearFiltersButton,
            ),
          ),
        ],
      ),
    );
  }
}
