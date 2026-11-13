import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/loan.dart';
import '../../../models/loan_status.dart';
import '../../common/settings_screen.dart';
import '../../common/widgets/book_card.dart';
import '../../common/widgets/loan_status_badge.dart';
import '../librarian_viewmodel.dart';
import 'book_management_screen.dart';
import 'loan_detail_screen.dart';
import 'loan_management_screen.dart';

class LibrarianHomeScreen extends StatefulWidget {
  const LibrarianHomeScreen({super.key});

  @override
  State<LibrarianHomeScreen> createState() =>
      _LibrarianHomeScreenState();
}

class _LibrarianHomeScreenState extends State<LibrarianHomeScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<LibrarianViewModel>()
        ..setTabIndex(0)
        ..runStartupChecks();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<LibrarianViewModel>().runStartupChecks();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final tabIndex = vm.selectedTabIndex;

    return Scaffold(
      appBar: _createLibrarianAppBar(
        context: context,
        l10n: l10n,
        tabIndex: tabIndex,
      ),
      body: SafeArea(
        child: _LibrarianTabBody(
          tabIndex: tabIndex,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppTheme.nav,
        selectedIndex: tabIndex,
        onDestinationSelected: (index) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          context.read<LibrarianViewModel>().setTabIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.dashboard,
            ),
            label: l10n.navOverview,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.menu_book,
            ),
            label: l10n.navBooks,
          ),
          NavigationDestination(
            icon: const Icon(
              Icons.receipt_long,
            ),
            label: l10n.navLoans,
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

PreferredSizeWidget _createLibrarianAppBar({
  required BuildContext context,
  required AppLocalizations l10n,
  required int tabIndex,
}) {
  if (tabIndex == 0) {
    return AppBar(
      title: Text(
        l10n.librarianDeskTitle,
      ),
      actions: [
        IconButton(
          key: const Key('librarian-home-language-button'),
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
          key: const Key('librarian-home-account-button'),
          tooltip: l10n.navAccount,
          onPressed: () {
            context.read<LibrarianViewModel>().setTabIndex(3);
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
        l10n.bookManagementTitle,
      ),
    );
  }

  if (tabIndex == 2) {
    return AppBar(
      title: Text(
        l10n.loanManagementTitle,
      ),
    );
  }

  return AppBar(
    title: Text(
      l10n.accountTitle,
    ),
  );
}

class _LibrarianTabBody extends StatelessWidget {
  const _LibrarianTabBody({
    required this.tabIndex,
  });

  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    if (tabIndex == 1) {
      return const BookManagementSectionContent();
    }
    if (tabIndex == 2) {
      return const LoanManagementSectionContent();
    }
    if (tabIndex == 3) {
      return const AccountSectionContent();
    }
    return const _LibrarianOverviewContent();
  }
}

class _LibrarianOverviewContent extends StatelessWidget {
  const _LibrarianOverviewContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final recentLoans = vm.recentRequests;
    final overdueList = vm.overdueLoans;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.librarianGreetingTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.librarianGreetingSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.muted,
            ),
          ),
          const SizedBox(height: 16),
          const _LibrarianMetricsGrid(),
          const SizedBox(height: 20),
          _OverviewSectionHeader(
            title: l10n.recentRequestsTitle,
            actionLabel: l10n.viewAllButton,
            onAction: () {
              context.read<LibrarianViewModel>().openLoansTab();
            },
          ),
          const SizedBox(height: 10),
          for (final loan in recentLoans) ...[
            _OverviewLoanCardItem(
              loan: loan,
            ),
            const SizedBox(height: 12),
          ],
          if (overdueList.isNotEmpty) ...[
            const SizedBox(height: 4),
            AppInfoBanner(
              key: const Key('librarian-overdue-banner'),
              icon: Icons.warning_amber,
              title: l10n.overdueLibrarianBannerTitle(
                overdueList.length,
              ),
              message: l10n.overdueLibrarianBannerMessage,
              foregroundColor: AppTheme.danger,
              backgroundColor: AppTheme.dangerSoft,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => LibrarianLoanDetailScreen(
                      loanId: overdueList.first.id,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _LibrarianMetricsGrid extends StatelessWidget {
  const _LibrarianMetricsGrid();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                cardKey: const Key('metric-books-card'),
                icon: Icons.menu_book,
                value: vm.totalBookTitles.toString(),
                label: l10n.metricBookTitles,
                color: AppTheme.primary,
                onTap: () {
                  context.read<LibrarianViewModel>().openBooksTab();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                cardKey: const Key('metric-borrowed-card'),
                icon: Icons.inventory_2,
                value: vm.borrowedCopiesCount.toString(),
                label: l10n.metricBorrowedCopies,
                color: AppTheme.success,
                onTap: () {
                  context.read<LibrarianViewModel>().openLoansTab(
                    statusFilter: LoanStatus.borrowed,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                cardKey: const Key('metric-pending-card'),
                icon: Icons.schedule,
                value: vm.pendingRequestsCount.toString(),
                label: l10n.metricPendingRequests,
                color: AppTheme.warning,
                onTap: () {
                  context.read<LibrarianViewModel>().openLoansTab(
                    statusFilter: LoanStatus.pending,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                cardKey: const Key('metric-overdue-card'),
                icon: Icons.warning_amber,
                value: vm.overdueLoansCount.toString(),
                label: l10n.metricOverdueLoans,
                color: AppTheme.danger,
                onTap: () {
                  context.read<LibrarianViewModel>().openLoansTab(
                    onlyOverdue: true,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    this.cardKey,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  final Key? cardKey;
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppTheme.outline,
        ),
      ),
      child: InkWell(
        key: cardKey,
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium
                    ?.copyWith(
                      color: AppTheme.ink,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewSectionHeader extends StatelessWidget {
  const _OverviewSectionHeader({
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
          key: const Key('overview-view-all-loans-button'),
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

class _OverviewLoanCardItem extends StatelessWidget {
  const _OverviewLoanCardItem({
    required this.loan,
  });

  final Loan loan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();
    final book = vm.findBookById(loan.bookId);

    return LoanCard(
      key: Key('overview-loan-card-${loan.id}'),
      loan: loan,
      book: book,
      dateLine: l10n.pickupDateInline(
        DateFormatter.formatDate(loan.pickupDate),
      ),
      isOverdue: vm.isOverdue(loan),
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
