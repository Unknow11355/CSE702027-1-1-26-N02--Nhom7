import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController =
      TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthViewModel>().resetRegisterState();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    _formKey.currentState?.validate();

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.register(
      fullName: _fullNameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;
    if (!success) return;

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.registerSuccessMessage),
      ),
    );

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  void _openLoginScreen() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          key: const Key('register-back-button'),
          tooltip: l10n.backTooltip,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.registerTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _RegisterFormSection(
              formKey: _formKey,
              fullNameController: _fullNameController,
              usernameController: _usernameController,
              passwordController: _passwordController,
              confirmPasswordController: _confirmPasswordController,
              showPassword: _showPassword,
              showConfirmPassword: _showConfirmPassword,
              onTogglePassword: _togglePasswordVisibility,
              onToggleConfirmPassword:
                  _toggleConfirmPasswordVisibility,
              onSubmit: _handleRegister,
              onOpenLogin: _openLoginScreen,
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterFormSection extends StatelessWidget {
  const _RegisterFormSection({
    required this.formKey,
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onSubmit,
    required this.onOpenLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final bool showConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onSubmit;
  final VoidCallback onOpenLogin;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authViewModel = context.watch<AuthViewModel>();
    final hasError = authViewModel.hasRegisterError;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _RegisterHeaderSection(hasError: hasError),
          const SizedBox(height: 20),
          _RegisterFieldsGroup(
            fullNameController: fullNameController,
            usernameController: usernameController,
            passwordController: passwordController,
            confirmPasswordController: confirmPasswordController,
            showPassword: showPassword,
            showConfirmPassword: showConfirmPassword,
            onTogglePassword: onTogglePassword,
            onToggleConfirmPassword: onToggleConfirmPassword,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            key: const Key('register-submit-button'),
            onPressed: authViewModel.isSubmitting ? null : onSubmit,
            child: Text(l10n.registerButton),
          ),
          if (!hasError) ...[
            const SizedBox(height: 16),
            TextButton(
              key: const Key('register-open-login-button'),
              onPressed:
                  authViewModel.isSubmitting ? null : onOpenLogin,
              child: Text(l10n.alreadyHaveAccountLoginPrompt),
            ),
          ],
        ],
      ),
    );
  }
}

class _RegisterHeaderSection extends StatelessWidget {
  const _RegisterHeaderSection({required this.hasError});

  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasError) ...[
          Text(
            l10n.registerHeadline,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.registerSubtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.muted,
            ),
          ),
        ] else
          const _RegisterErrorBanner(),
      ],
    );
  }
}

class _RegisterErrorBanner extends StatelessWidget {
  const _RegisterErrorBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const Key('register-error-banner'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dangerSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber,
            size: 24,
            color: AppTheme.danger,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.registerErrorBannerTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.danger,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.registerErrorBannerMessage,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterFieldsGroup extends StatelessWidget {
  const _RegisterFieldsGroup({
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.showPassword,
    required this.showConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool showPassword;
  final bool showConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  String? _translateError(
    AppLocalizations l10n,
    String? code,
  ) {
    if (code == null) return null;
    if (code == 'username_exists') {
      return l10n.errorUsernameExists;
    }
    if (code == 'password_too_short') {
      return l10n.errorPasswordTooShort;
    }
    if (code == 'password_mismatch') {
      return l10n.errorPasswordMismatch;
    }
    return l10n.errorRequiredField;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authViewModel = context.watch<AuthViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('register-fullname-field'),
          controller: fullNameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.fullNameLabel,
            hintText: l10n.fullNameHint,
            errorText: _translateError(
              l10n,
              authViewModel.fullNameErrorCode,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('register-username-field'),
          controller: usernameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.usernameLabel,
            hintText: l10n.usernameHint,
            errorText: _translateError(
              l10n,
              authViewModel.usernameErrorCode,
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('register-password-field'),
          controller: passwordController,
          obscureText: !showPassword,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            hintText: l10n.passwordHint,
            errorText: _translateError(
              l10n,
              authViewModel.passwordErrorCode,
            ),
            suffixIcon: IconButton(
              key: const Key('register-toggle-password-button'),
              tooltip: l10n.togglePasswordTooltip,
              onPressed: onTogglePassword,
              icon: Icon(
                showPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppTheme.muted,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('register-confirm-password-field'),
          controller: confirmPasswordController,
          obscureText: !showConfirmPassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.confirmPasswordLabel,
            hintText: l10n.confirmPasswordHint,
            errorText: _translateError(
              l10n,
              authViewModel.confirmPasswordErrorCode,
            ),
            suffixIcon: IconButton(
              key: const Key(
                'register-toggle-confirm-password-button',
              ),
              tooltip: l10n.toggleConfirmPasswordTooltip,
              onPressed: onToggleConfirmPassword,
              icon: Icon(
                showConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppTheme.muted,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
