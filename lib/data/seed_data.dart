import '../models/book.dart';
import '../models/favorite.dart';
import '../models/loan.dart';
import '../models/user.dart';

class SeedData {
  SeedData._();

  static List<User> createInitialUsers() => <User>[];

  static List<Book> createInitialBooks() => <Book>[
        const Book(
          id: 'B001',
          title: 'Nhập môn lập trình',
          author: 'Tác giả A',
          category: 'Công nghệ',
          totalCopies: 3,
          description: 'Kiến thức nền tảng về lập trình.',
        ),
        const Book(
          id: 'B002',
          title: 'Kỹ năng học tập',
          author: 'Tác giả B',
          category: 'Kỹ năng',
          totalCopies: 2,
          description: 'Phương pháp tổ chức và nâng cao hiệu quả học tập.',
        ),
      ];

  static List<Loan> createInitialLoans() => <Loan>[];

  static List<Favorite> createInitialFavorites() => <Favorite>[];
}
