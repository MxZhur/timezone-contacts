import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:timezone_contacts/data/app_cache.dart';

import 'package:timezone_contacts/data/app_state_manager.dart';
import 'package:timezone_contacts/data/repositories/repository.dart';
import 'package:timezone_contacts/data/repositories/sqlite_repository.dart';
import 'package:timezone_contacts/misc/constants.dart';
import 'package:timezone_contacts/ui/screens/home_screen.dart';
import 'package:timezone_contacts/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateManager = AppStateManager();
  await appStateManager.initializeApp();

  final repository = SqliteRepository();
  await repository.init();

  runApp(
    TimezoneContactsApp(
      appStateManager: appStateManager,
      repository: repository,
    ),
  );
}

class TimezoneContactsApp extends StatefulWidget {
  final AppStateManager appStateManager;
  final Repository repository;

  const TimezoneContactsApp({
    super.key,
    required this.appStateManager,
    required this.repository,
  });

  @override
  State<TimezoneContactsApp> createState() => _TimezoneContactsAppState();
}

class _TimezoneContactsAppState extends State<TimezoneContactsApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => widget.appStateManager,
        ),
        Provider<Repository>(
          lazy: false,
          create: (_) => widget.repository,
          dispose: (_, Repository repository) => repository.close(),
        ),
      ],
      child: Consumer<AppStateManager>(
        builder: (context, appStateManager, child) {
          ThemeData theme;
          switch (appStateManager.darkMode) {
            case DarkMode.on:
              theme = AppTheme.dark();
              break;
            case DarkMode.off:
              theme = AppTheme.light();
              break;
            case DarkMode.system:
              var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;;
              if (brightness == Brightness.dark) {
                theme = AppTheme.dark();
              } else {
                theme = AppTheme.light();
              }
              break;
            default:
              theme = AppTheme.light();
              break;
          }

          return MaterialApp(
            theme: theme,
            title: appName,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
