import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../l10n/generated/app_localizations.dart';

class TeamInfoScreen extends StatelessWidget {
  const TeamInfoScreen({super.key});

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
          l10n.teamInfoTitle,
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: _TeamInfoContent(),
        ),
      ),
    );
  }
}

class _TeamInfoContent extends StatelessWidget {
  const _TeamInfoContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _TeamHeaderCard(),
        const SizedBox(height: 16),
        _MemberCard(
          name: l10n.member1Name,
          info: l10n.member1Info,
        ),
        const SizedBox(height: 12),
        _MemberCard(
          name: l10n.member2Name,
          info: l10n.member2Info,
        ),
        const SizedBox(height: 12),
        _MemberCard(
          name: l10n.member3Name,
          info: l10n.member3Info,
        ),
        const SizedBox(height: 24),
        Text(
          l10n.appVersionLabel,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TeamHeaderCard extends StatelessWidget {
  const _TeamHeaderCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.menu_book,
            color: AppTheme.primary,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.teamAppHeading,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.teamCourseSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.name,
    required this.info,
  });

  final String name;
  final String info;

  @override
  Widget build(BuildContext context) {
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
      child: _MemberCardBody(
        name: name,
        info: info,
        textTheme: textTheme,
      ),
    );
  }
}

class _MemberCardBody extends StatelessWidget {
  const _MemberCardBody({
    required this.name,
    required this.info,
    required this.textTheme,
  });

  final String name;
  final String info;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: AppTheme.primarySoft,
          child: Icon(
            Icons.person,
            color: AppTheme.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                info,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: AppTheme.ink,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
