import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_controller.dart';
import 'features/auth/login_page.dart';
import 'features/shell/app_shell.dart';

void main() {
  runApp(const GymologiaAdminApp());
}

/// Gymologia HQ.
///
/// The console for the people who run the platform: verification review,
/// support, announcements, internal staff and the logs. Every endpoint it
/// calls was built and tested before this app existed — what was missing
/// was a screen in front of them.
class GymologiaAdminApp extends StatelessWidget {
  const GymologiaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthController()..restore(),
      child: MaterialApp(
        title: 'Gymologia HQ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1B5E20),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const _Gate(),
      ),
    );
  }
}

/// Signed in or not, and nothing in between.
class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    // Restoring a session is not the same as being signed out. Without this
    // the console flashes the login screen on every launch before deciding
    // the operator was already signed in.
    if (auth.isRestoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isSignedIn ? const AppShell() : const LoginPage();
  }
}
