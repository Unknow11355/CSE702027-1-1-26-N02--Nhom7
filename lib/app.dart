import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'data/library_data_store.dart';
import 'data/repositories/book_repository.dart';
import 'data/repositories/favorite_repository.dart';
import 'data/repositories/loan_repository.dart';
import 'data/repositories/user_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/auth/auth_viewmodel.dart';
import 'presentation/auth/screens/login_screen.dart';
import 'presentation/auth/screens/register_screen.dart';
import 'presentation/common/locale_viewmodel.dart';
import 'presentation/common/settings_screen.dart';
import 'presentation/common/team_info_screen.dart';
import 'presentation/common/welcome_screen.dart';
import 'presentation/librarian/librarian_viewmodel.dart';
import 'presentation/librarian/screens/librarian_home_screen.dart';
import 'presentation/reader/reader_viewmodel.dart';
import 'presentation/reader/screens/book_list_screen.dart';
import 'services/auth_service.dart';
import 'services/book_service.dart';
import 'services/loan_service.dart';

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
        ProxyProvider<LibraryDataStore, BookRepository>(
          update: (_, store, _) => BookRepository(store),
        ),
        ProxyProvider<LibraryDataStore, LoanRepository>(
          update: (_, store, _) => LoanRepository(store),
        ),
        ProxyProvider<LibraryDataStore, FavoriteRepository>(
          update: (_, store, _) => FavoriteRepository(store),
        ),
        ProxyProvider<UserRepository, AuthService>(
          update: (_, userRepo, previous) =>
              previous ?? AuthService(userRepo),
        ),
        ProxyProvider3<
          BookRepository,
          LoanRepository,
          FavoriteRepository,
          BookService
        >(
          update: (_, bookRepo, loanRepo, favRepo, _) =>
              BookService(
                bookRepo,
                loanRepo,
                favRepo,
              ),
        ),
        ProxyProvider4<
          LoanRepository,
          BookRepository,
          UserRepository,
          BookService,
          LoanService
        >(
          update:
              (
                _,
                loanRepo,
                bookRepo,
                userRepo,
                bookService,
                _,
              ) => LoanService(
                loanRepo,
                bookRepo,
                userRepo,
                bookService,
              ),
        ),
        ChangeNotifierProxyProvider<AuthService, AuthViewModel>(
          create: (context) => AuthViewModel(
            context.read<AuthService>(),
          ),
          update: (_, authService, previous) =>
              previous ?? AuthViewModel(authService),
        ),
        ChangeNotifierProxyProvider<
          LibraryDataStore,
          ReaderViewModel
        >(
          create: (context) => ReaderViewModel(
            context.read<BookService>(),
            context.read<LoanService>(),
            context.read<AuthService>(),
            context.read<UserRepository>(),
          ),
          update: (context, _, previous) {
            final vm =
                previous ??
                ReaderViewModel(
                  context.read<BookService>(),
                  context.read<LoanService>(),
                  context.read<AuthService>(),
                  context.read<UserRepository>(),
                );
            vm.onDataStoreUpdated();
            return vm;
          },
        ),
        ChangeNotifierProxyProvider<
          LibraryDataStore,
          LibrarianViewModel
        >(
          create: (context) => LibrarianViewModel(
            context.read<BookService>(),
            context.read<LoanService>(),
            context.read<AuthService>(),
            context.read<UserRepository>(),
          ),
          update: (context, _, previous) {
            final vm =
                previous ??
                LibrarianViewModel(
                  context.read<BookService>(),
                  context.read<LoanService>(),
                  context.read<AuthService>(),
                  context.read<UserRepository>(),
                );
            vm.onDataStoreUpdated();
            return vm;
          },
        ),
        ChangeNotifierProvider<LocaleViewModel>(
          create: (_) => LocaleViewModel(),
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
    final locale = context.watch<LocaleViewModel>().locale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.welcome: (_) => const WelcomeScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.readerHome: (_) => const BookListScreen(),
        AppRoutes.librarianHome: (_) => const LibrarianHomeScreen(),
        AppRoutes.language: (_) => const LanguageScreen(),
        AppRoutes.teamInfo: (_) => const TeamInfoScreen(),
      },
    );
  }
}
