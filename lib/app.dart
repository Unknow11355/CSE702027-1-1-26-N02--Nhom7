import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'data/library_data_store.dart';
import 'data/repositories/user_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/auth/auth_viewmodel.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/auth/screens/register_screen.dart';
//import 'presentation/common/welcome_screen.dart';
import 'services/auth_service.dart';

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LibraryDataStore>(
          create: (_) => LibraryDataStore(),
          lazy: false,
        ),
        ProxyProvider<LibraryDataStore, UserRepository>(
          update: (_, store, _) => UserRepository(store),
        ),
        ProxyProvider<UserRepository, AuthService>(
          update: (_, userRepo, previous) => previous ?? AuthService(userRepo),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthViewModel>(
          create: (context) => AuthViewModel(context.read<AuthService>()),
          update: (_, authService, previous) =>
              previous ?? AuthViewModel(authService),
        ),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      theme: AppTheme.light,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        // Màn hình tạm: LoginScreen điều hướng tới 2 route này sau khi đăng nhập.
        AppRoutes.readerHome: (_) => const _HomePlaceholder(),
        AppRoutes.librarianHome: (_) => const _HomePlaceholder(),
      },
    );
  }
}

class _HomePlaceholder extends StatelessWidget {
  const _HomePlaceholder();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<AuthViewModel>().currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(user?.fullName ?? '')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${user?.username ?? ''} · ${user?.role.name ?? ''}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                context.read<AuthViewModel>().logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
              child: Text(l10n.logoutButton),
            ),
          ],
        ),
      ),
    );
  }
}
