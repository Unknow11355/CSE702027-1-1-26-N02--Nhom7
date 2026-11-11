import 'dart:convert';

import '../models/book.dart';
import '../models/favorite.dart';
import '../models/loan.dart';
import '../models/loan_status.dart';
import '../models/user.dart';
import '../models/user_role.dart';

class SeedData {
  SeedData._();

  static String computePasswordHash(String password, String salt) {
    final bytes = utf8.encode('$salt:$password:library_v1');
    var hash1 = 0x811c9dc5;
    var hash2 = 0x01000193;

    for (final byte in bytes) {
      hash1 ^= byte;
      hash1 = (hash1 * 0x01000193) & 0xFFFFFFFF;
      hash2 = ((hash2 << 5) + hash2 + byte) & 0xFFFFFFFF;
    }

    final part1 = hash1.toRadixString(16).padLeft(8, '0');
    final part2 = hash2.toRadixString(16).padLeft(8, '0');
    return '$part1$part2';
  }

  static List<User> createInitialUsers() {
    const defaultPassword = '12345678';
    const readerSalt = 'salt_u001';
    const librarianSalt = 'salt_u002';
    const reader2Salt = 'salt_u003';
    const reader3Salt = 'salt_u004';

    return <User>[
      User(
        id: 'U001',
        fullName: 'Vũ Xuân Minh',
        username: 'minh.reader',
        passwordHash: computePasswordHash(defaultPassword, readerSalt),
        passwordSalt: readerSalt,
        role: UserRole.reader,
      ),
      User(
        id: 'U002',
        fullName: 'Tài khoản thủ thư',
        username: 'librarian',
        passwordHash: computePasswordHash(defaultPassword, librarianSalt),
        passwordSalt: librarianSalt,
        role: UserRole.librarian,
      ),
      User(
        id: 'U003',
        fullName: 'Lê Anh Quân',
        username: 'anhquanreader',
        passwordHash: computePasswordHash(defaultPassword, reader2Salt),
        passwordSalt: reader2Salt,
        role: UserRole.reader,
      ),
      User(
        id: 'U004',
        fullName: 'Lê Quốc Huy',
        username: 'huy.reader',
        passwordHash: computePasswordHash(defaultPassword, reader3Salt),
        passwordSalt: reader3Salt,
        role: UserRole.reader,
      ),
    ];
  }

  static List<Book> createInitialBooks() => <Book>[
    const Book(
      id: 'B001',
      title: 'Dế Mèn phiêu lưu ký',
      author: 'Tô Hoài',
      category: 'Văn học',
      totalCopies: 5,
      coverAsset: 'assets/books/demmen.png',
      description: 'Hành trình khám phá thế giới của Dế Mèn qua những cuộc gặp gỡ, thử thách và bài học về tình bạn, lòng dũng cảm.',
    ),
    const Book(
      id: 'B002',
      title: 'Tôi thấy hoa vàng trên cỏ xanh',
      author: 'Nguyễn Nhật Ánh',
      category: 'Văn học',
      totalCopies: 4,
      coverAsset: 'assets/books/hoavang.png',
      description: 'Câu chuyện tuổi thơ trong trẻo nơi làng quê với những rung động đầu đời và tình anh em ấm áp.',
    ),
    const Book(
      id: 'B003',
      title: 'Nhà giả kim',
      author: 'Paulo Coelho',
      category: 'Văn học',
      totalCopies: 3,
      coverAsset: 'assets/books/alchemist.png',
      description: 'Hành trình đi tìm kho báu và khám phá điều có ý nghĩa với chính mình.',
    ),
    const Book(
      id: 'B004',
      title: 'Số đỏ',
      author: 'Vũ Trọng Phụng',
      category: 'Văn học',
      totalCopies: 4,
      coverAsset: 'assets/books/sodo.png',
      description: 'Tác phẩm trào phúng kinh điển phản ánh xã hội thành thị Việt Nam những năm 1930.',
    ),
    const Book(
      id: 'B005',
      title: 'Tư duy nhanh và chậm',
      author: 'Daniel Kahneman',
      category: 'Khoa học',
      totalCopies: 4,
      coverAsset: 'assets/books/thinking.png',
      description: 'Khám phá hai hệ thống tư duy chi phối cách chúng ta suy nghĩ và đưa ra quyết định.',
    ),
    const Book(
      id: 'B006',
      title: 'Lược sử thời gian',
      author: 'Stephen Hawking',
      category: 'Khoa học',
      totalCopies: 3,
      coverAsset: 'assets/books/time.png',
      description:
          'Hành trình tìm hiểu nguồn gốc, cấu trúc và tương lai của vũ trụ.',
    ),
  ];

  static List<Loan> createInitialLoans({DateTime? referenceTime}) {
    final now = referenceTime ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return <Loan>[
      Loan(
        id: 'PM024',
        userId: 'U001',
        bookId: 'B001',
        createdAt: today.subtract(const Duration(days: 1)),
        pickupDate: today.add(const Duration(days: 1)),
        status: LoanStatus.pending,
      ),
      Loan(
        id: 'PM021',
        userId: 'U001',
        bookId: 'B006',
        createdAt: today.subtract(const Duration(days: 6)),
        pickupDate: today.subtract(const Duration(days: 5)),
        status: LoanStatus.borrowed,
        borrowedAt: today.subtract(const Duration(days: 5)),
        dueAt: today.add(const Duration(days: 2)),
      ),
      Loan(
        id: 'PM018',
        userId: 'U001',
        bookId: 'B001',
        createdAt: today.subtract(const Duration(days: 14)),
        pickupDate: today.subtract(const Duration(days: 13)),
        status: LoanStatus.returned,
        borrowedAt: today.subtract(const Duration(days: 13)),
        dueAt: today.subtract(const Duration(days: 6)),
        returnedAt: today.subtract(const Duration(days: 7)),
      ),
      Loan(
        id: 'PM015',
        userId: 'U001',
        bookId: 'B003',
        createdAt: today.subtract(const Duration(days: 10)),
        pickupDate: today.subtract(const Duration(days: 8)),
        status: LoanStatus.rejected,
        reason: 'Sách cần kiểm tra tình trạng trước khi cho mượn.',
      ),
      Loan(
        id: 'PM014',
        userId: 'U001',
        bookId: 'B004',
        createdAt: today.subtract(const Duration(days: 12)),
        pickupDate: today.subtract(const Duration(days: 9)),
        status: LoanStatus.cancelled,
        reason: 'Quá hạn nhận',
      ),
      Loan(
        id: 'PM019',
        userId: 'U003',
        bookId: 'B001',
        createdAt: today.subtract(const Duration(days: 4)),
        pickupDate: today.subtract(const Duration(days: 3)),
        status: LoanStatus.borrowed,
        borrowedAt: today.subtract(const Duration(days: 3)),
        dueAt: today.add(const Duration(days: 4)),
      ),
      Loan(
        id: 'PM025',
        userId: 'U003',
        bookId: 'B002',
        createdAt: today,
        pickupDate: today.add(const Duration(days: 2)),
        status: LoanStatus.pending,
      ),
      Loan(
        id: 'PM023',
        userId: 'U003',
        bookId: 'B002',
        createdAt: today.subtract(const Duration(days: 10)),
        pickupDate: today.subtract(const Duration(days: 9)),
        status: LoanStatus.borrowed,
        borrowedAt: today.subtract(const Duration(days: 9)),
        dueAt: today.subtract(const Duration(days: 2)),
      ),
      Loan(
        id: 'PM020',
        userId: 'U004',
        bookId: 'B003',
        createdAt: today.subtract(const Duration(days: 4)),
        pickupDate: today.subtract(const Duration(days: 3)),
        status: LoanStatus.borrowed,
        borrowedAt: today.subtract(const Duration(days: 3)),
        dueAt: today.add(const Duration(days: 4)),
      ),
      Loan(
        id: 'PM026',
        userId: 'U004',
        bookId: 'B003',
        createdAt: today.subtract(const Duration(days: 1)),
        pickupDate: today.add(const Duration(days: 1)),
        status: LoanStatus.readyForPickup,
      ),
      Loan(
        id: 'PM027',
        userId: 'U003',
        bookId: 'B003',
        createdAt: today,
        pickupDate: today.add(const Duration(days: 3)),
        status: LoanStatus.pending,
      ),
      Loan(
        id: 'PM022',
        userId: 'U004',
        bookId: 'B004',
        createdAt: today.subtract(const Duration(days: 1)),
        pickupDate: today.add(const Duration(days: 1)),
        status: LoanStatus.readyForPickup,
      ),
      Loan(
        id: 'PM028',
        userId: 'U004',
        bookId: 'B004',
        createdAt: today.subtract(const Duration(days: 3)),
        pickupDate: today.subtract(const Duration(days: 2)),
        status: LoanStatus.borrowed,
        borrowedAt: today.subtract(const Duration(days: 2)),
        dueAt: today.add(const Duration(days: 5)),
      ),
      Loan(
        id: 'PM029',
        userId: 'U003',
        bookId: 'B005',
        createdAt: today.subtract(const Duration(days: 2)),
        pickupDate: today.subtract(const Duration(days: 1)),
        status: LoanStatus.borrowed,
        borrowedAt: today.subtract(const Duration(days: 1)),
        dueAt: today.add(const Duration(days: 6)),
      ),
    ];
  }

  static List<Favorite> createInitialFavorites() => <Favorite>[
    const Favorite(userId: 'U001', bookId: 'B001'),
  ];
}
