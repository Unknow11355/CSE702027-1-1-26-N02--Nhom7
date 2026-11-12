import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../core/app_theme.dart';
import '../../../models/book.dart';
import '../../../models/loan.dart';
import 'loan_status_badge.dart';

class BookCoverImage extends StatelessWidget {
  const BookCoverImage({
    super.key,
    required this.coverAsset,
    this.width = 56,
    this.height = 80,
    this.borderRadius = 8,
  });

  final String? coverAsset;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final asset = coverAsset ?? 'assets/books/demmen.png';

    if (asset.startsWith('data:image/')) {
      final commaIndex = asset.indexOf(',');
      if (commaIndex != -1 && commaIndex + 1 < asset.length) {
        try {
          final bytes = base64Decode(
            asset.substring(commaIndex + 1),
          );
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.memory(
              bytes,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _CoverFallbackBox(
                width: width,
                height: height,
              ),
            ),
          );
        } catch (_) {
          return _CoverFallbackBox(
            width: width,
            height: height,
          );
        }
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _CoverFallbackBox(
          width: width,
          height: height,
        ),
      ),
    );
  }
}

class _CoverFallbackBox extends StatelessWidget {
  const _CoverFallbackBox({
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: AppTheme.primarySoft,
      alignment: Alignment.center,
      child: const Icon(
        Icons.menu_book,
        color: AppTheme.primary,
        size: 28,
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    this.subtitle,
    this.subtitleColor,
    this.isFavorite,
    this.onToggleFavorite,
    this.onTap,
  });

  final Book book;
  final String? subtitle;
  final Color? subtitleColor;
  final bool? isFavorite;
  final VoidCallback? onToggleFavorite;
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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: _BookCardBody(
            book: book,
            subtitle: subtitle,
            subtitleColor: subtitleColor,
            isFavorite: isFavorite,
            onToggleFavorite: onToggleFavorite,
          ),
        ),
      ),
    );
  }
}

class _BookCardBody extends StatelessWidget {
  const _BookCardBody({
    required this.book,
    this.subtitle,
    this.subtitleColor,
    this.isFavorite,
    this.onToggleFavorite,
  });

  final Book book;
  final String? subtitle;
  final Color? subtitleColor;
  final bool? isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookCoverImage(
          coverAsset: book.coverAsset,
          width: 56,
          height: 80,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _BookCardTextColumn(
            book: book,
            subtitle: subtitle,
            subtitleColor: subtitleColor,
          ),
        ),
        if (onToggleFavorite != null)
          IconButton(
            key: Key('book-card-favorite-${book.id}'),
            onPressed: onToggleFavorite,
            icon: Icon(
              (isFavorite ?? false)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: (isFavorite ?? false)
                  ? AppTheme.danger
                  : AppTheme.muted,
            ),
          ),
      ],
    );
  }
}

class _BookCardTextColumn extends StatelessWidget {
  const _BookCardTextColumn({
    required this.book,
    this.subtitle,
    this.subtitleColor,
  });

  final Book book;
  final String? subtitle;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          book.author,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 13,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: textTheme.bodyMedium?.copyWith(
              color: subtitleColor ?? AppTheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class ShelfBookTile extends StatelessWidget {
  const ShelfBookTile({
    super.key,
    required this.book,
    required this.availabilityLabel,
    required this.isAvailable,
    this.isFavorite,
    this.onToggleFavorite,
    this.onTap,
  });

  final Book book;
  final String availabilityLabel;
  final bool isAvailable;
  final bool? isFavorite;
  final VoidCallback? onToggleFavorite;
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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _ShelfBookTileContent(
            book: book,
            availabilityLabel: availabilityLabel,
            isAvailable: isAvailable,
            isFavorite: isFavorite,
            onToggleFavorite: onToggleFavorite,
          ),
        ),
      ),
    );
  }
}

class _ShelfBookTileContent extends StatelessWidget {
  const _ShelfBookTileContent({
    required this.book,
    required this.availabilityLabel,
    required this.isAvailable,
    this.isFavorite,
    this.onToggleFavorite,
  });

  final Book book;
  final String availabilityLabel;
  final bool isAvailable;
  final bool? isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ShelfCoverStack(
          book: book,
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
        const SizedBox(height: 10),
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 6),
        Text(
          availabilityLabel,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isAvailable ? AppTheme.success : AppTheme.danger,
          ),
        ),
      ],
    );
  }
}

class _ShelfCoverStack extends StatelessWidget {
  const _ShelfCoverStack({
    required this.book,
    this.isFavorite,
    this.onToggleFavorite,
  });

  final Book book;
  final bool? isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: BookCoverImage(
            coverAsset: book.coverAsset,
            width: 88,
            height: 124,
          ),
        ),
        if (onToggleFavorite != null)
          Positioned(
            top: -6,
            right: -6,
            child: IconButton(
              key: Key('shelf-book-favorite-${book.id}'),
              onPressed: onToggleFavorite,
              icon: Icon(
                (isFavorite ?? false)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: (isFavorite ?? false)
                    ? AppTheme.danger
                    : AppTheme.muted,
                size: 22,
              ),
            ),
          ),
      ],
    );
  }
}

class LoanCard extends StatelessWidget {
  const LoanCard({
    super.key,
    required this.loan,
    required this.book,
    required this.dateLine,
    this.isOverdue = false,
    this.onTap,
  });

  final Loan loan;
  final Book? book;
  final String dateLine;
  final bool isOverdue;
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
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: _LoanCardBody(
            loan: loan,
            book: book,
            dateLine: dateLine,
            isOverdue: isOverdue,
          ),
        ),
      ),
    );
  }
}

class _LoanCardBody extends StatelessWidget {
  const _LoanCardBody({
    required this.loan,
    required this.book,
    required this.dateLine,
    required this.isOverdue,
  });

  final Loan loan;
  final Book? book;
  final String dateLine;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LoanCardHeader(
          loan: loan,
          isOverdue: isOverdue,
        ),
        const SizedBox(height: 12),
        _LoanCardBookRow(
          book: book,
          dateLine: dateLine,
        ),
      ],
    );
  }
}

class _LoanCardHeader extends StatelessWidget {
  const _LoanCardHeader({
    required this.loan,
    required this.isOverdue,
  });

  final Loan loan;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        LoanStatusBadge(
          status: loan.status,
        ),
        if (isOverdue) const OverdueBadge(),
        Text(
          loan.id,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LoanCardBookRow extends StatelessWidget {
  const _LoanCardBookRow({
    required this.book,
    required this.dateLine,
  });

  final Book? book;
  final String dateLine;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        BookCoverImage(
          coverAsset: book?.coverAsset,
          width: 44,
          height: 62,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book?.title ?? '',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateLine,
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.foregroundColor = AppTheme.primary,
    this.backgroundColor = AppTheme.primarySoft,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: _AppInfoBannerRow(
            icon: icon,
            title: title,
            message: message,
            foregroundColor: foregroundColor,
          ),
        ),
      ),
    );
  }
}

class _AppInfoBannerRow extends StatelessWidget {
  const _AppInfoBannerRow({
    required this.icon,
    required this.title,
    required this.message,
    required this.foregroundColor,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: foregroundColor,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _AppInfoBannerTexts(
            title: title,
            message: message,
            foregroundColor: foregroundColor,
          ),
        ),
      ],
    );
  }
}

class _AppInfoBannerTexts extends StatelessWidget {
  const _AppInfoBannerTexts({
    required this.title,
    required this.message,
    required this.foregroundColor,
  });

  final String title;
  final String message;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: foregroundColor,
            height: 20 / 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: AppTheme.ink,
            height: 18 / 13,
          ),
        ),
      ],
    );
  }
}

class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final isLargeText = textScale >= 1.35;

    if (isLargeText) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: _VerticalDetailRow(
          label: label,
          value: value,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: _HorizontalDetailRow(
        label: label,
        value: value,
      ),
    );
  }
}

class _VerticalDetailRow extends StatelessWidget {
  const _VerticalDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HorizontalDetailRow extends StatelessWidget {
  const _HorizontalDetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
