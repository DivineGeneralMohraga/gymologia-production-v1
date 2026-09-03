import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'features/settings/locale_controller.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/phone_screen.dart';
import 'features/shell/app_mode.dart';
import 'features/shell/app_shell.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Month and weekday names for every locale the app ships. Without this,
  // DateFormat only knows English and throws for the rest.
  await initializeDateFormatting();
  runApp(const GymologiaApp());
}

class GymologiaApp extends StatelessWidget {
  const GymologiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()..restoreSession()),
        ChangeNotifierProvider(create: (_) => AppModeController()..restore()),
        ChangeNotifierProvider(create: (_) => LocaleController()..restore()),
      ],
      // Watching the controller here rebuilds the whole app on a language
      // change, which is what makes the picker take effect immediately
      // instead of on next launch.
      child: Consumer<LocaleController>(
        builder: (context, locales, _) => MaterialApp(
          title: 'Gymologia',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          locale: locales.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Set once the locale is actually resolved, which is inside
          // MaterialApp -- the picker may say "follow the device", and only
          // here is it known what the device settled on.
          builder: (context, child) {
            context.read<AuthController>().client.localeCode =
                Localizations.localeOf(context).languageCode;
            return child ?? const SizedBox.shrink();
          },
          home: const _Root(),
        ),
      ),
    );
  }
}

/// Swaps between login and home on session state. Keeping this in one
/// place means no screen has to push or pop on sign-in or sign-out — they
/// just change the state and the tree follows.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthController>().status;

    return switch (status) {
      AuthStatus.unknown => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      AuthStatus.signedOut => const PhoneScreen(),
      AuthStatus.signedIn => const AppShell(),
    };
  }
}
