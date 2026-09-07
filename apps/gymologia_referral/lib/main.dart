import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/api/api_client.dart';
import 'core/config/app_config.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/login_page.dart';
import 'features/referral/referral_controller.dart';
import 'features/settings/locale_controller.dart';
import 'features/shell/app_shell.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Month names for every locale the app ships. Without this, DateFormat
  // only knows English and throws for the rest -- which the earnings list
  // would hit the moment somebody switched language.
  await initializeDateFormatting();
  runApp(const GymologiaReferralApp());
}

/// Gymologia Referral.
///
/// One job: hand somebody a code, and account for what the code earns.
/// Everything else this account can do lives in the other app.
class GymologiaReferralApp extends StatelessWidget {
  const GymologiaReferralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()..restore()),
        ChangeNotifierProvider(create: (_) => LocaleController()..restore()),
        // Built from the auth controller's client so it shares the session
        // and the token refresh, rather than opening a second one.
        ChangeNotifierProxyProvider<AuthController, ReferralController>(
          create: (context) =>
              ReferralController(context.read<AuthController>().api),
          update: (_, auth, previous) {
            final referral = previous ?? ReferralController(auth.api);
            // The same controller instance survives a sign-out, because it
            // is held above the screen that swaps. Clearing it here is what
            // stops the next person to sign in on this handset seeing the
            // last one's code and balance for a frame.
            if (auth.status == AuthStatus.signedOut) referral.forget();
            return referral;
          },
        ),
      ],
      child: Consumer<LocaleController>(
        builder: (context, locales, _) => MaterialApp(
          title: 'Gymologia Referral',
          debugShowCheckedModeBanner: false,
          theme: _theme(Brightness.light),
          darkTheme: _theme(Brightness.dark),
          locale: locales.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            final client = context.read<AuthController>().client;
            final t = AppLocalizations.of(context);
            // Only known here: the picker may say "follow the device", and
            // this is where the device's answer is available. The server
            // builds the share sentence from this same code, so it decides
            // what language gets forwarded to a gym owner.
            client.localeCode = Localizations.localeOf(context).languageCode;
            client.strings = ApiStrings(
              sessionExpired: t.sessionExpiredSignIn,
              somethingWentWrong: t.genericError,
              tookTooLong: t.serverTookTooLong,
              unreachable: t.couldNotReachServer(AppConfig.displayHost),
              badCertificate: t.certificateNotVerified,
              networkError: t.networkErrorTryAgain,
            );
            return child ?? const SizedBox.shrink();
          },
          home: const _Root(),
        ),
      ),
    );
  }

  static ThemeData _theme(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: brightness,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
        ),
      );
}

/// Signed in or not, and nothing in between.
///
/// Restoring is a third state on purpose: without it the app shows the
/// phone field for a frame to somebody who is already signed in.
class _Root extends StatelessWidget {
  const _Root();

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthController>().status;
    return switch (status) {
      AuthStatus.unknown =>
        const Scaffold(body: Center(child: CircularProgressIndicator())),
      AuthStatus.signedOut => const LoginPage(),
      AuthStatus.signedIn => const AppShell(),
    };
  }
}
