import 'package:flutter/material.dart';

import '../../core/app_routes.dart';
import '../../core/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(24), child: _WelcomeContent()),
        ),
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const _WelcomeBrandRow(),
        const SizedBox(height: 16),
        const _BookshelfIllustration(),
        const SizedBox(height: 16),
        const _WelcomeIntroSection(),
        const SizedBox(height: 24),
        ElevatedButton(
          key: const Key('welcome-login-button'),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.login);
          },
          child: Text(l10n.loginButton),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          key: const Key('welcome-register-button'),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: Text(l10n.createReaderAccountButton),
        ),
      ],
    );
  }
}

class _WelcomeBrandRow extends StatelessWidget {
  const _WelcomeBrandRow();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const Icon(Icons.menu_book, size: 32, color: AppTheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            l10n.appBrandUpper,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              height: 26 / 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookshelfIllustration extends StatelessWidget {
  const _BookshelfIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: _CoverPreviewItem(
              assetPath: 'assets/books/hoavang.png',
              height: 124,
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: _CoverPreviewItem(
              assetPath: 'assets/books/demmen.png',
              height: 152,
            ),
          ),
          SizedBox(width: 16),
          Flexible(
            child: _CoverPreviewItem(
              assetPath: 'assets/books/alchemist.png',
              height: 124,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverPreviewItem extends StatelessWidget {
  const _CoverPreviewItem({required this.assetPath, required this.height});

  final String assetPath;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.asset(assetPath, height: height, fit: BoxFit.contain),
    );
  }
}

class _WelcomeIntroSection extends StatelessWidget {
  const _WelcomeIntroSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcomeHeadline,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
            height: 40 / 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.welcomeSubtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppTheme.muted,
            height: 24 / 16,
          ),
        ),
      ],
    );
  }
}
