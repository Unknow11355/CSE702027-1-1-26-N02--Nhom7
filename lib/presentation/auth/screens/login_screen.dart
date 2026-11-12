import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_routes.dart';
import '../../../core/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../models/user_role.dart';
import '../../../services/loan_service.dart';
import '../auth_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController();
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthViewModel>().resetLoginState();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    final authViewModel = context.read<AuthViewModel>();
    final user = await authViewModel.login(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    if (user == null) return;

    await context.read<LoanService>().cancelExpiredPickupsAsync();
    if (!mounted) return;

    final targetRoute = user.role == UserRole.librarian
        ? AppRoutes.librarianHome
        : AppRoutes.readerHome;

    Navigator.pushNamedAndRemoveUntil(
      context,
      targetRoute,
      (route) => false,
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _openRegisterScreen() {
    Navigator.pushNamed(
      context,
      AppRoutes.register,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          key: const Key('login-back-button'),
          tooltip: l10n.backTooltip,
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(l10n.loginTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _LoginFormSection(
              formKey: _formKey,
              usernameController: _usernameController,
              passwordController: _passwordController,
              showPassword: _showPassword,
              onTogglePassword: _togglePasswordVisibility,
              onSubmit: _handleLogin,
              onOpenRegister: _openRegisterScreen,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormSection extends StatelessWidget {
  const _LoginFormSection({
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.showPassword,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onOpenRegister,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool showPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onOpenRegister;

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final hasError = authViewModel.hasLoginError;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LoginIntroHeader(hasError: hasError),
          if (hasError) ...[
            const SizedBox(height: 16),
            const _LoginErrorBanner(),
          ],
          const SizedBox(height: 24),
          _LoginFieldsGroup(
            usernameController: usernameController,
            passwordController: passwordController,
            showPassword: showPassword,
            onTogglePassword: onTogglePassword,
          ),
          const SizedBox(height: 24),
          _LoginActionButtons(
            hasError: hasError,
            isSubmitting: authViewModel.isSubmitting,
            onSubmit: onSubmit,
            onOpenRegister: onOpenRegister,
          ),
        ],
      ),
    );
  }
}

class _LoginIntroHeader extends StatelessWidget {
  const _LoginIntroHeader({required this.hasError});

  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!hasError) ...[
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.menu_book,
              size: 40,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          l10n.welcomeBackTitle,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.ink,
          ),
        ),
        if (!hasError) ...[
          const SizedBox(height: 12),
          Text(
            l10n.loginSubtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.muted,
            ),
          ),
        ],
      ],
    );
  }
}

class _LoginErrorBanner extends StatelessWidget {
  const _LoginErrorBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      key: const Key('login-error-banner'),
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
                  l10n.loginErrorTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.danger,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.loginErrorMessage,
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

class _LoginFieldsGroup extends StatelessWidget {
  const _LoginFieldsGroup({
    required this.usernameController,
    required this.passwordController,
    required this.showPassword,
    required this.onTogglePassword,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool showPassword;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('login-username-field'),
          controller: usernameController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.usernameLabel,
            hintText: l10n.usernameHint,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.errorRequiredField;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          key: const Key('login-password-field'),
          controller: passwordController,
          obscureText: !showPassword,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: l10n.passwordLabel,
            hintText: l10n.passwordHint,
            suffixIcon: IconButton(
              key: const Key('login-toggle-password-button'),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.errorRequiredField;
            }
            return null;
          },
        ),
      ],
    );
  }
}

class _LoginActionButtons extends StatelessWidget {
  const _LoginActionButtons({
    required this.hasError,
    required this.isSubmitting,
    required this.onSubmit,
    required this.onOpenRegister,
  });

  final bool hasError;
  final bool isSubmitting;
  final VoidCallback onSubmit;
  final VoidCallback onOpenRegister;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          key: const Key('login-submit-button'),
          onPressed: isSubmitting ? null : onSubmit,
          child: Text(
            hasError ? l10n.retryButton : l10n.loginButton,
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          key: const Key('login-open-register-button'),
          onPressed: isSubmitting ? null : onOpenRegister,
          child: Text(
            hasError
                ? l10n.createAccountShortButton
                : l10n.noAccountRegisterPrompt,
          ),
        ),
      ],
    );
  }
}
