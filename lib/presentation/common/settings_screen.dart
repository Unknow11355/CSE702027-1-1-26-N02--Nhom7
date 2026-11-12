import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/user_role.dart';
import '../auth/auth_viewmodel.dart';
import '../reader/reader_viewmodel.dart';
import 'locale_viewmodel.dart';
import 'team_info_screen.dart';

class AccountSectionContent extends StatelessWidget {
  const AccountSectionContent({
    super.key,
    this.onOpenMyLoans,
  });

  final VoidCallback? onOpenMyLoans;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authVm = context.watch<AuthViewModel>();
    final localeVm = context.watch<LocaleViewModel>();
    final user = authVm.currentUser;
    final isReader = user?.role != UserRole.librarian;
    final isVi = localeVm.locale.languageCode == 'vi';
    final currentLangLabel = isVi
        ? l10n.currentLanguageVietnamese
        : l10n.currentLanguageEnglish;

    int activeLoansCount = 0;
    if (isReader) {
      activeLoansCount = context
          .watch<ReaderViewModel>()
          .activeLoanCount;
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _UserProfileCard(
          fullName: user?.fullName ?? '',
          subtitle:
              '${user?.username ?? ''} · ${isReader ? l10n.readerRoleName : l10n.librarianRoleName}',
        ),
        const SizedBox(height: 16),
        if (isReader) ...[
          _AccountMenuTile(
            tileKey: const Key('account-my-loans-tile'),
            icon: Icons.receipt_long,
            title: l10n.myLoansTitle,
            subtitle: l10n.activeLoansSubtitle(activeLoansCount),
            onTap: onOpenMyLoans,
          ),
          const SizedBox(height: 12),
        ],
        _AccountMenuTile(
          tileKey: const Key('account-language-tile'),
          icon: Icons.language,
          title: l10n.languageTitle,
          subtitle: currentLangLabel,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const LanguageScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _AccountMenuTile(
          tileKey: const Key('account-team-info-tile'),
          icon: Icons.info_outline,
          title: l10n.teamInfoTitle,
          subtitle: isReader
              ? l10n.teamInfoSubtitleReader
              : l10n.teamInfoSubtitleLibrarian,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const TeamInfoScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          key: const Key('account-logout-button'),
          onPressed: () {
            context.read<AuthViewModel>().logout();
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            );
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.danger,
            side: const BorderSide(
              color: AppTheme.danger,
            ),
          ),
          child: Text(
            l10n.logoutButton,
          ),
        ),
      ],
    );
  }
}

class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard({
    required this.fullName,
    required this.subtitle,
  });

  final String fullName;
  final String subtitle;

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
      child: _UserProfileRow(
        fullName: fullName,
        subtitle: subtitle,
      ),
    );
  }
}

class _UserProfileRow extends StatelessWidget {
  const _UserProfileRow({
    required this.fullName,
    required this.subtitle,
  });

  final String fullName;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: AppTheme.primarySoft,
          child: Icon(
            Icons.person,
            color: AppTheme.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountMenuTile extends StatelessWidget {
  const _AccountMenuTile({
    this.tileKey,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final Key? tileKey;
  final IconData icon;
  final String title;
  final String subtitle;
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
      child: ListTile(
        key: tileKey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: Icon(
          icon,
          color: AppTheme.primary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.muted,
        ),
        onTap: onTap,
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.languageTitle,
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: _LanguageContent(),
        ),
      ),
    );
  }
}

class _LanguageContent extends StatelessWidget {
  const _LanguageContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeVm = context.watch<LocaleViewModel>();
    final isVi = localeVm.locale.languageCode == 'vi';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.selectLanguageHeading,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.selectLanguageSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        _AccountMenuTile(
          tileKey: const Key('language-vi-tile'),
          icon: isVi ? Icons.check_circle : Icons.language,
          title: l10n.currentLanguageVietnamese,
          subtitle: isVi
              ? l10n.inUseLabel
              : l10n.switchToVietnameseSubtitle,
          onTap: () {
            context.read<LocaleViewModel>().setLocale(
              const Locale('vi'),
            );
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 12),
        _AccountMenuTile(
          tileKey: const Key('language-en-tile'),
          icon: !isVi ? Icons.check_circle : Icons.language,
          title: l10n.currentLanguageEnglish,
          subtitle: !isVi
              ? l10n.inUseLabel
              : l10n.switchToEnglishSubtitle,
          onTap: () {
            context.read<LocaleViewModel>().setLocale(
              const Locale('en'),
            );
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
