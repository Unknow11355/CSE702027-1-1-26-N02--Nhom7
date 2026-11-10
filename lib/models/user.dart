import 'user_role.dart';

class User {
  const User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.passwordHash,
    required this.passwordSalt,
    required this.role,
  });

  final String id;
  final String fullName;
  final String username;
  final String passwordHash;
  final String passwordSalt;
  final UserRole role;
}
