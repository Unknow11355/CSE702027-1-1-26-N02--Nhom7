import '../core/app_exception.dart';
import '../data/repositories/user_repository.dart';
import '../data/seed_data.dart';
import '../models/user.dart';
import '../models/user_role.dart';

class AuthService {
  AuthService(this._userRepository);

  final UserRepository _userRepository;
  User? _currentUser;

  User? get currentUser => _currentUser;

  bool isUsernameTaken(String username) {
    _userRepository.reloadFromStorage();
    final normalized = username.trim();
    if (normalized.isEmpty) {
      return false;
    }
    return _userRepository.findByUsername(normalized) != null;
  }

  User login({
    required String username,
    required String password,
  }) {
    _userRepository.reloadFromStorage();

    final normalizedUsername = username.trim();
    if (normalizedUsername.isEmpty || password.isEmpty) {
      throw const AppException('invalid_credentials');
    }

    final user = _userRepository.findByUsername(normalizedUsername);
    if (user == null) {
      throw const AppException('invalid_credentials');
    }

    final computedHash = SeedData.computePasswordHash(
      password,
      user.passwordSalt,
    );

    if (computedHash != user.passwordHash) {
      throw const AppException('invalid_credentials');
    }

    _currentUser = user;
    return user;
  }

  String _generateNextUserId() {
    var maxNum = 0;
    for (final user in _userRepository.getAll()) {
      final raw = user.id.toUpperCase().replaceFirst('U', '');
      final parsed = int.tryParse(raw);
      if (parsed != null && parsed > maxNum) {
        maxNum = parsed;
      }
    }
    final nextNum = maxNum + 1;
    return 'U${nextNum.toString().padLeft(3, '0')}';
  }

  User registerReader({
    required String fullName,
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    final normalizedFullName = fullName.trim();
    final normalizedUsername = username.trim();

    if (normalizedFullName.isEmpty ||
        normalizedUsername.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      throw const AppException('required_field');
    }

    if (isUsernameTaken(normalizedUsername)) {
      throw const AppException('username_exists');
    }

    if (password.length < 6) {
      throw const AppException('password_too_short');
    }

    if (password != confirmPassword) {
      throw const AppException('password_mismatch');
    }

    final nextId = _generateNextUserId();
    final salt = 'salt_${nextId.toLowerCase()}';
    final passwordHash = SeedData.computePasswordHash(
      password,
      salt,
    );

    final newUser = User(
      id: nextId,
      fullName: normalizedFullName,
      username: normalizedUsername,
      passwordHash: passwordHash,
      passwordSalt: salt,
      role: UserRole.reader,
    );

    _userRepository.save(newUser);
    return newUser;
  }

  Future<User> registerReaderAsync({
    required String fullName,
    required String username,
    required String password,
    required String confirmPassword,
  }) {
    return _userRepository.runExclusiveWrite(
      () => registerReader(
        fullName: fullName,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      ),
    );
  }

  void logout() {
    _currentUser = null;
  }
}
