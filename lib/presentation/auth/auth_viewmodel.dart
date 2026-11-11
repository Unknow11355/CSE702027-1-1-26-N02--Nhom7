import 'package:flutter/foundation.dart';

import '../../core/app_exception.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._authService);

  final AuthService _authService;

  bool _isSubmitting = false;
  bool _hasLoginError = false;
  bool _hasRegisterError = false;
  String? _fullNameErrorCode;
  String? _usernameErrorCode;
  String? _passwordErrorCode;
  String? _confirmPasswordErrorCode;

  User? get currentUser => _authService.currentUser;

  bool get isSubmitting => _isSubmitting;

  bool get hasLoginError => _hasLoginError;

  bool get hasRegisterError => _hasRegisterError;

  String? get fullNameErrorCode => _fullNameErrorCode;

  String? get usernameErrorCode => _usernameErrorCode;

  String? get passwordErrorCode => _passwordErrorCode;

  String? get confirmPasswordErrorCode => _confirmPasswordErrorCode;

  void resetLoginState() {
    _hasLoginError = false;
    _isSubmitting = false;
    notifyListeners();
  }

  void resetRegisterState() {
    _hasRegisterError = false;
    _fullNameErrorCode = null;
    _usernameErrorCode = null;
    _passwordErrorCode = null;
    _confirmPasswordErrorCode = null;
    _isSubmitting = false;
    notifyListeners();
  }

  Future<User?> login({
    required String username,
    required String password,
  }) async {
    if (_isSubmitting) {
      return null;
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      final user = _authService.login(username: username, password: password);
      _hasLoginError = false;
      _isSubmitting = false;
      notifyListeners();
      return user;
    } on AppException {
      _hasLoginError = true;
      _isSubmitting = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> register({
    required String fullName,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    if (_isSubmitting) {
      return false;
    }

    _isSubmitting = true;
    _fullNameErrorCode = null;
    _usernameErrorCode = null;
    _passwordErrorCode = null;
    _confirmPasswordErrorCode = null;
    notifyListeners();

    final trimmedName = fullName.trim();
    final trimmedUsername = username.trim();

    if (trimmedName.isEmpty) {
      _fullNameErrorCode = 'required_field';
    }

    if (trimmedUsername.isEmpty) {
      _usernameErrorCode = 'required_field';
    } else if (_authService.isUsernameTaken(trimmedUsername)) {
      _usernameErrorCode = 'username_exists';
    }

    if (password.isEmpty) {
      _passwordErrorCode = 'required_field';
    } else if (password.length < 6) {
      _passwordErrorCode = 'password_too_short';
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordErrorCode = 'required_field';
    } else if (password != confirmPassword) {
      _confirmPasswordErrorCode = 'password_mismatch';
    }

    final hasFieldErrors =
        _fullNameErrorCode != null ||
        _usernameErrorCode != null ||
        _passwordErrorCode != null ||
        _confirmPasswordErrorCode != null;

    if (hasFieldErrors) {
      _hasRegisterError = true;
      _isSubmitting = false;
      notifyListeners();
      return false;
    }

    try {
      _authService.registerReader(
        fullName: trimmedName,
        username: trimmedUsername,
        password: password,
        confirmPassword: confirmPassword,
      );
      _hasRegisterError = false;
      _isSubmitting = false;
      notifyListeners();
      return true;
    } on AppException catch (error) {
      if (error.code == 'username_exists') {
        _usernameErrorCode = 'username_exists';
      } else if (error.code == 'password_too_short') {
        _passwordErrorCode = 'password_too_short';
      } else if (error.code == 'password_mismatch') {
        _confirmPasswordErrorCode = 'password_mismatch';
      } else {
        _fullNameErrorCode = 'required_field';
      }
      _hasRegisterError = true;
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _authService.logout();
    _hasLoginError = false;
    notifyListeners();
  }
}
