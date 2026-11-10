import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'data/library_data_store.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/common/locale_viewmodel.dart';
import 'presentation/common/welcome_screen.dart';

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
      },
    );
  }
}
