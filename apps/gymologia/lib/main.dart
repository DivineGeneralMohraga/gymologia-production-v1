import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/phone_screen.dart';
import 'features/shell/app_mode.dart';
import 'features/shell/app_shell.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: MaterialApp(
        title: 'Gymologia',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const _Root(),
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
