import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/loan_status.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  static String formatDateTime(DateTime date) {
    final datePart = formatDate(date);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$datePart, $hour:$minute';
  }

  static String formatDayMonth(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month';
  }
}

class LoanStatusBadge extends StatelessWidget {
  const LoanStatusBadge({
    super.key,
    required this.status,
  });

  final LoanStatus status;

  static String localizedLabel(
    AppLocalizations l10n,
    LoanStatus status,
  ) {
    switch (status) {
      case LoanStatus.pending:
        return l10n.statusPending;
      case LoanStatus.readyForPickup:
        return l10n.statusReadyForPickup;
      case LoanStatus.borrowed:
        return l10n.statusBorrowed;
      case LoanStatus.returned:
        return l10n.statusReturned;
      case LoanStatus.rejected:
        return l10n.statusRejected;
      case LoanStatus.cancelled:
        return l10n.statusCancelled;
    }
  }

  static IconData iconFor(LoanStatus status) {
    switch (status) {
      case LoanStatus.pending:
        return Icons.schedule;
      case LoanStatus.readyForPickup:
        return Icons.event_available;
      case LoanStatus.borrowed:
        return Icons.menu_book;
      case LoanStatus.returned:
        return Icons.done_all;
      case LoanStatus.rejected:
        return Icons.close;
      case LoanStatus.cancelled:
        return Icons.close;
    }
  }

  static Color foregroundFor(LoanStatus status) {
    switch (status) {
      case LoanStatus.pending:
        return AppTheme.warning;
      case LoanStatus.readyForPickup:
        return AppTheme.success;
      case LoanStatus.borrowed:
        return AppTheme.primary;
      case LoanStatus.returned:
        return AppTheme.success;
      case LoanStatus.rejected:
        return AppTheme.danger;
      case LoanStatus.cancelled:
        return AppTheme.muted;
    }
  }

  static Color backgroundFor(LoanStatus status) {
    switch (status) {
      case LoanStatus.pending:
        return AppTheme.warningSoft;
      case LoanStatus.readyForPickup:
        return AppTheme.successSoft;
      case LoanStatus.borrowed:
        return AppTheme.primarySoft;
      case LoanStatus.returned:
        return AppTheme.successSoft;
      case LoanStatus.rejected:
        return AppTheme.dangerSoft;
      case LoanStatus.cancelled:
        return AppTheme.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _BadgePill(
      icon: iconFor(status),
      label: localizedLabel(l10n, status),
      foregroundColor: foregroundFor(status),
      backgroundColor: backgroundFor(status),
    );
  }
}

class OverdueBadge extends StatelessWidget {
  const OverdueBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return _BadgePill(
      icon: Icons.warning_amber,
      label: l10n.statusOverdue,
      foregroundColor: AppTheme.danger,
      backgroundColor: AppTheme.dangerSoft,
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.icon,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: _BadgePillContent(
        icon: icon,
        label: label,
        foregroundColor: foregroundColor,
      ),
    );
  }
}

class _BadgePillContent extends StatelessWidget {
  const _BadgePillContent({
    required this.icon,
    required this.label,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: foregroundColor,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: foregroundColor,
              height: 16 / 12,
            ),
          ),
        ),
      ],
    );
  }
}
