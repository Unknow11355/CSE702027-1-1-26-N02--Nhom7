class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.totalCopies,
    this.description = '',
    this.coverAsset,
    this.isActive = true,
  });

  final String id;
  final String title;
  final String author;
  final String category;
  final int totalCopies;
  final String description;
  final String? coverAsset;
  final bool isActive;
}
