import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_controller.dart';
import '../diagnostics/diagnostics_screen.dart';

/// Placeholder home.
///
/// Its job right now is to prove the round trip: OTP sent, code verified,
/// session stored, and /auth/me answering with the signed-in user. The
/// real member surfaces — gym browser, progress, events — land on top of
/// this once their backend modules exist.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gymologia'),
        actions: [
          IconButton(
            tooltip: 'Connection',
            icon: const Icon(Icons.dns_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    (user?.name.isNotEmpty ?? false)
                        ? user!.name.characters.first.toUpperCase()
                        : '?',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? '—',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      Text(user?.phone ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text('Signed in',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'OTP verified, session stored, and /auth/me confirmed '
                      'it against the server. The auth round trip works end '
                      'to end.',
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    if (user?.email != null) ...[
                      const SizedBox(height: 12),
                      Text('Email: ${user!.email}',
                          style: theme.textTheme.bodySmall),
                    ],
                    if (user?.age != null) ...[
                      const SizedBox(height: 4),
                      Text('Age: ${user!.age}',
                          style: theme.textTheme.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Not built yet',
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...const [
              'Gym browser and search',
              'Membership, progress and the exercise directory',
              'Events',
              'Chat',
              'Owner / staff CRM mode',
            ].map(
              (s) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.circle_outlined, size: 16),
                title: Text(s, style: theme.textTheme.bodyMedium),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.read<AuthController>().signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
