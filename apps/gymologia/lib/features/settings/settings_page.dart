import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_config.dart';
import '../auth/auth_controller.dart';
import '../diagnostics/diagnostics_screen.dart';
import '../shell/app_mode.dart';
import 'edit_profile_page.dart';
import 'support_page.dart';

/// Settings, and the switch between member and owner/staff mode.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final modeController = context.watch<AppModeController>();
    final user = auth.user;
    final theme = Theme.of(context);
    final isStaff = modeController.isStaff;

    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 40),
      children: [
        // ── Profile ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  (user?.name.isNotEmpty ?? false)
                      ? user!.name.characters.first.toUpperCase()
                      : '?',
                  style: theme.textTheme.titleLarge?.copyWith(
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
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(user?.phone ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                    if (user?.email != null)
                      Text(user!.email!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Mode switch ──────────────────────────────────────────
        // The headline setting, so it goes first rather than buried.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(isStaff ? Icons.badge_outlined : Icons.person_outline,
                          size: 20),
                      const SizedBox(width: 10),
                      Text(
                        isStaff ? 'Owner / staff mode' : 'Member mode',
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isStaff
                        ? 'You are managing gyms. Switch back to use Gymologia as a member.'
                        : 'Opening a gym, or working at one? Switch to run your gym’s CRM — '
                            'members, staff, attendance and leave.',
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => modeController.toggle(),
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: Text(
                      isStaff ? 'Switch to member mode' : 'Switch to owner / staff',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // ── Referral nudge ───────────────────────────────────────
        // The second of the two default messages the spec asks for.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            child: ListTile(
              leading: const Icon(Icons.card_giftcard_outlined),
              title: const Text('Earn by referring gyms'),
              subtitle: const Text(
                  'Share a code, and earn when a gym owner subscribes. The referral app is not out yet.'),
              isThreeLine: true,
            ),
          ),
        ),

        const SizedBox(height: 12),
        const _SectionLabel('Account'),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('Phone number'),
          subtitle: Text(user?.phone ?? '—'),
          trailing: const Icon(Icons.lock_outline, size: 16),
          onTap: () => _toast(context,
              'Your number is how you sign in, so it cannot be changed here yet.'),
        ),
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: const Text('Name'),
          subtitle: Text(user?.name ?? '—'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: const Text('Email'),
          subtitle: Text(user?.email ?? 'Not set'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EditProfilePage()),
          ),
        ),

        const _SectionLabel('Support'),
        ListTile(
          leading: const Icon(Icons.support_agent_outlined),
          title: const Text('Get help'),
          subtitle: const Text('Send us a message and we will call you back'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SupportPage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dns_outlined),
          title: const Text('Connection'),
          subtitle: Text(AppConfig.displayHost),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DiagnosticsScreen()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Terms & Privacy Policy'),
          onTap: () => _toast(context, 'Not written yet.'),
        ),

        const _SectionLabel('Session'),
        ListTile(
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text('Sign out', style: TextStyle(color: theme.colorScheme.error)),
          onTap: () => _confirmSignOut(context, auth),
        ),

        const SizedBox(height: 24),
        Center(
          child: Text('Gymologia · member and staff',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)),
        ),
      ],
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmSignOut(BuildContext context, AuthController auth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need your phone to sign back in.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true) await auth.signOut();
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 6),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 0.9,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
