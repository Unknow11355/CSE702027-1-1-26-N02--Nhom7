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
    final normalized = username.trim();
    if (normalized.isEmpty) {
      return false;
    }
    return _userRepository.findByUsername(normalized) != null;
  }

  User login({required String username, required String password}) {
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

    final nextIndex = _userRepository.getAll().length + 1;
    final nextId = 'U${nextIndex.toString().padLeft(3, '0')}';
    final salt = 'salt_${nextId.toLowerCase()}';
    final passwordHash = SeedData.computePasswordHash(password, salt);

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

  void logout() {
    _currentUser = null;
  }
}
