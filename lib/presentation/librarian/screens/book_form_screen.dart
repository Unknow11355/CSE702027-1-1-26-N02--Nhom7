import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_exception.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/book.dart';
import '../../common/widgets/book_card.dart';
import '../librarian_viewmodel.dart';
import 'image_picker_stub.dart'
    if (dart.library.js_interop) 'image_picker_web.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({
    super.key,
    this.existingBook,
  });

  final Book? existingBook;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  static const List<String> _presetCoverAssets = <String>[
    'assets/books/demmen.png',
    'assets/books/hoavang.png',
    'assets/books/alchemist.png',
    'assets/books/sodo.png',
    'assets/books/thinking.png',
    'assets/books/time.png',
  ];

  late final TextEditingController _idController;
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _categoryController;
  late final TextEditingController _totalCopiesController;
  late final TextEditingController _descriptionController;

  late String _selectedCoverAsset;
  String? _idError;
  String? _titleError;
  String? _authorError;
  String? _categoryError;
  String? _totalCopiesError;
  bool _showBelowActiveBanner = false;

  bool get _isEditing => widget.existingBook != null;

  @override
  void initState() {
    super.initState();
    final book = widget.existingBook;
    final nextId = book?.id ??
        context.read<LibrarianViewModel>().generateNextBookId();

    _idController = TextEditingController(text: nextId);
    _titleController = TextEditingController(
      text: book?.title ?? '',
    );
    _authorController = TextEditingController(
      text: book?.author ?? '',
    );
    _categoryController = TextEditingController(
      text: book?.category ?? 'Văn học',
    );
    _totalCopiesController = TextEditingController(
      text: book != null ? book.totalCopies.toString() : '1',
    );
    _descriptionController = TextEditingController(
      text: book?.description ?? '',
    );
    _selectedCoverAsset =
        book?.coverAsset ?? _presetCoverAssets.first;
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    _totalCopiesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUploadFromComputer() async {
    final dataUrl = await pickCoverImageAsDataUrl();
    if (!mounted || dataUrl == null || dataUrl.isEmpty) {
      return;
    }

    setState(() {
      _selectedCoverAsset = dataUrl;
    });
  }

  Future<void> _selectCategory() async {
    final vm = context.read<LibrarianViewModel>();
    final categories = vm.categories;

    final chosen = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final cat in categories)
                ListTile(
                  title: Text(cat),
                  trailing: _categoryController.text.trim() == cat
                      ? const Icon(
                          Icons.check,
                          color: AppTheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(sheetContext, cat),
                ),
            ],
          ),
        );
      },
    );

    if (!mounted || chosen == null) {
      return;
    }

    setState(() {
      _categoryController.text = chosen;
      _categoryError = null;
    });
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.read<LibrarianViewModel>();

    final idText = _idController.text.trim().toUpperCase();
    final titleText = _titleController.text.trim();
    final authorText = _authorController.text.trim();
    final categoryText = _categoryController.text.trim();
    final copiesRaw = _totalCopiesController.text.trim();
    final descriptionText = _descriptionController.text.trim();

    String? idErr;
    String? titleErr;
    String? authorErr;
    String? categoryErr;
    String? copiesErr;
    var belowActive = false;

    if (!_isEditing && idText.isEmpty) {
      idErr = l10n.errorRequiredField;
    } else if (!_isEditing && vm.findBookById(idText) != null) {
      idErr = l10n.errorBookIdExists;
    }

    if (titleText.isEmpty) {
      titleErr = l10n.errorRequiredField;
    }
    if (authorText.isEmpty) {
      authorErr = l10n.errorRequiredField;
    }
    if (categoryText.isEmpty) {
      categoryErr = l10n.errorRequiredField;
    }

    final parsedCopies = int.tryParse(copiesRaw);
    if (parsedCopies == null || parsedCopies < 0) {
      copiesErr = l10n.errorInvalidTotalCopies;
    } else if (_isEditing) {
      final bookId = widget.existingBook!.id;
      final minActive = vm.activeLoanCountForBook(bookId);
      if (parsedCopies < minActive) {
        final reserved = vm.reservedCopies(bookId);
        final borrowed = vm.borrowedCopies(bookId);
        copiesErr = l10n.errorTotalCopiesBelowActive(
          minActive,
          reserved,
          borrowed,
        );
        belowActive = true;
      }
    }

    if (idErr != null ||
        titleErr != null ||
        authorErr != null ||
        categoryErr != null ||
        copiesErr != null) {
      setState(() {
        _idError = idErr;
        _titleError = titleErr;
        _authorError = authorErr;
        _categoryError = categoryErr;
        _totalCopiesError = copiesErr;
        _showBelowActiveBanner = belowActive;
      });
      return;
    }

    try {
      if (_isEditing) {
        await vm.updateBook(
          id: widget.existingBook!.id,
          title: titleText,
          author: authorText,
          category: categoryText,
          totalCopies: parsedCopies!,
          description: descriptionText,
          coverAsset: _selectedCoverAsset,
        );
      } else {
        await vm.createBook(
          id: idText,
          title: titleText,
          author: authorText,
          category: categoryText,
          totalCopies: parsedCopies!,
          description: descriptionText,
          coverAsset: _selectedCoverAsset,
        );
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              l10n.saveBookSuccessMessage,
            ),
          ),
        );
      Navigator.pop(context);
    } on AppException catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (error.code == 'book_id_exists') {
          _idError = l10n.errorBookIdExists;
        } else if (error.code == 'total_copies_below_active' &&
            _isEditing) {
          final bookId = widget.existingBook!.id;
          final minActive = vm.activeLoanCountForBook(bookId);
          _totalCopiesError = l10n.errorTotalCopiesBelowActive(
            minActive,
            vm.reservedCopies(bookId),
            vm.borrowedCopies(bookId),
          );
          _showBelowActiveBanner = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<LibrarianViewModel>();

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
          _isEditing ? l10n.editBookTitle : l10n.addBookTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_isEditing) ...[
                Text(
                  l10n.requiredFieldsNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
              ],
              if (_showBelowActiveBanner) ...[
                AppInfoBanner(
                  icon: Icons.warning_amber,
                  title: l10n.cannotSaveBookBannerTitle,
                  message: l10n.cannotSaveBookBannerMessage,
                  foregroundColor: AppTheme.danger,
                  backgroundColor: AppTheme.dangerSoft,
                ),
                const SizedBox(height: 16),
              ],
              _BookCoverPickerCard(
                selectedCoverAsset: _selectedCoverAsset,
                presetAssets: _presetCoverAssets,
                onUploadFromComputer: _handleUploadFromComputer,
                onSelectPreset: (asset) {
                  setState(() {
                    _selectedCoverAsset = asset;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_isEditing)
                _FixedBookIdCard(
                  bookId: widget.existingBook!.id,
                )
              else
                TextFormField(
                  key: const Key('book-form-id-field'),
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: l10n.bookIdRequiredLabel,
                    errorText: _idError,
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('book-form-title-field'),
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: l10n.bookTitleRequiredLabel,
                  hintText: l10n.bookTitleHint,
                  errorText: _titleError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('book-form-author-field'),
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: l10n.authorRequiredLabel,
                  hintText: l10n.authorHint,
                  errorText: _authorError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('book-form-category-field'),
                controller: _categoryController,
                readOnly: true,
                onTap: _selectCategory,
                decoration: InputDecoration(
                  labelText: l10n.categoryRequiredLabel,
                  hintText: l10n.categoryHint,
                  errorText: _categoryError,
                  suffixIcon: const Icon(
                    Icons.chevron_right,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('book-form-copies-field'),
                controller: _totalCopiesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.totalCopiesRequiredLabel,
                  errorText: _totalCopiesError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('book-form-description-field'),
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l10n.descriptionLabel,
                  hintText: l10n.descriptionHint,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('book-form-submit-button'),
                onPressed: vm.isSubmitting ? null : _handleSave,
                child: Text(
                  _isEditing
                      ? l10n.saveChangesButton
                      : l10n.saveBookButton,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCoverPickerCard extends StatelessWidget {
  const _BookCoverPickerCard({
    required this.selectedCoverAsset,
    required this.presetAssets,
    required this.onUploadFromComputer,
    required this.onSelectPreset,
  });

  final String selectedCoverAsset;
  final List<String> presetAssets;
  final VoidCallback onUploadFromComputer;
  final ValueChanged<String> onSelectPreset;

  @override
  Widget build(BuildContext context) {
    final isVi =
        Localizations.localeOf(context).languageCode == 'vi';

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
          _CoverPreviewAndUploadRow(
            selectedCoverAsset: selectedCoverAsset,
            isVi: isVi,
            onUploadFromComputer: onUploadFromComputer,
          ),
          const SizedBox(height: 12),
          Text(
            kIsWeb
                ? (isVi
                      ? 'Hoặc chọn nhanh bìa mẫu:'
                      : 'Or pick a preset:')
                : (isVi ? 'Chọn bìa mẫu:' : 'Pick a preset cover:'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          _PresetCoverHorizontalList(
            presetAssets: presetAssets,
            selectedCoverAsset: selectedCoverAsset,
            onSelectPreset: onSelectPreset,
          ),
        ],
      ),
    );
  }
}

class _CoverPreviewAndUploadRow extends StatelessWidget {
  const _CoverPreviewAndUploadRow({
    required this.selectedCoverAsset,
    required this.isVi,
    required this.onUploadFromComputer,
  });

  final String selectedCoverAsset;
  final bool isVi;
  final VoidCallback onUploadFromComputer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BookCoverImage(
          coverAsset: selectedCoverAsset,
          width: 72,
          height: 102,
          borderRadius: 10,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isVi ? 'Ảnh bìa sách' : 'Book cover',
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (kIsWeb) ...[
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  key: const Key('upload-cover-from-computer-button'),
                  onPressed: onUploadFromComputer,
                  icon: const Icon(
                    Icons.upload_file,
                  ),
                  label: Text(
                    isVi ? 'Tải ảnh từ máy' : 'Upload from device',
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                Text(
                  isVi
                      ? 'Chọn một trong 6 bìa mẫu bên dưới'
                      : 'Select one of the 6 preset covers below',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PresetCoverHorizontalList extends StatelessWidget {
  const _PresetCoverHorizontalList({
    required this.presetAssets,
    required this.selectedCoverAsset,
    required this.onSelectPreset,
  });

  final List<String> presetAssets;
  final String selectedCoverAsset;
  final ValueChanged<String> onSelectPreset;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final asset in presetAssets) ...[
            _PresetCoverThumbnail(
              assetPath: asset,
              isSelected: asset == selectedCoverAsset,
              onTap: () => onSelectPreset(asset),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

class _PresetCoverThumbnail extends StatelessWidget {
  const _PresetCoverThumbnail({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: BookCoverImage(
          coverAsset: assetPath,
          width: 44,
          height: 62,
          borderRadius: 6,
        ),
      ),
    );
  }
}

class _FixedBookIdCard extends StatelessWidget {
  const _FixedBookIdCard({
    required this.bookId,
  });

  final String bookId;

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
      child: DetailInfoRow(
        label: l10n.bookIdFixedLabel,
        value: bookId,
      ),
    );
  }
}
