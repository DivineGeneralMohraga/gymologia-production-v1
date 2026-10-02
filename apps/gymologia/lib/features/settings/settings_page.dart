import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_controller.dart';
import '../diagnostics/diagnostics_screen.dart';
import '../shell/app_mode.dart';
import 'edit_profile_page.dart';
import 'support_page.dart';
import '../safety/blocked_accounts_page.dart';
import 'delete_account_page.dart';
import 'data_export_page.dart';
import 'legal_page.dart';
import 'language_page.dart';
import 'locale_controller.dart';
import 'theme_controller.dart';
import '../../theme.dart';
import '../../ui/kit.dart';
import '../../l10n/app_localizations.dart';

/// Settings, and the switch between member and owner/staff mode.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
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
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: HeroPanel(
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: volt,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (user?.name.isNotEmpty ?? false)
                        ? user!.name.characters.first.toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontFamily: displayFont,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: ink,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (user?.name ?? '—').toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: displayFont,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.phone ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFF5F5F2)
                              .withValues(alpha: 0.75),
                        ),
                      ),
                      if (user?.email != null)
                        Text(
                          user!.email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFFF5F5F2)
                                .withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Mode switch ──────────────────────────────────────────
        // The headline setting, so it goes first rather than buried.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isStaff ? Icons.badge_rounded : Icons.person_rounded,
                        size: 20,
                        color: context.gym.accentText,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        (isStaff ? t.ownerStaffMode : t.memberMode)
                            .toUpperCase(),
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isStaff ? t.managingGymsNote : t.openingAGymNote,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: () => modeController.toggle(),
                    icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                    label: Text((isStaff ? t.switchToMember : t.switchToStaff)
                        .toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        _SectionLabel(t.account),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: Text(t.phoneNumber),
          subtitle: Text(user?.phone ?? '—'),
          trailing: const Icon(Icons.lock_outline, size: 16),
          onTap: () => _toast(context, t.numberIsHowYouSignIn),
        ),
        ListTile(
          leading: const Icon(Icons.badge_outlined),
          title: Text(t.name),
          subtitle: Text(user?.name ?? '—'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const EditProfilePage())),
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: Text(t.email),
          subtitle: Text(user?.email ?? t.notSet),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const EditProfilePage())),
        ),

        _SectionLabel(t.safetyAndPrivacy),
        // Reachable from Settings because a block is made silently, in the
        // middle of something, and never announced -- so there is no other
        // screen it can be found on afterwards, and without this one it
        // would be permanent in practice.
        ListTile(
          leading: const Icon(Icons.shield_outlined),
          title: Text(t.blockedAccounts),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const BlockedAccountsPage()),
          ),
        ),

        _SectionLabel(t.support),
        ListTile(
          leading: const Icon(Icons.support_agent_outlined),
          title: Text(t.getHelp),
          subtitle: Text(t.getHelpSubtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const SupportPage())),
        ),
        ListTile(
          leading: const Icon(Icons.dns_outlined),
          title: Text(t.connection),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const DiagnosticsScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(AppLocalizations.of(context).language),
          subtitle: Text(
            context.watch<LocaleController>().locale == null
                ? t.followingYourDevice
                : LanguagePage.nameFor(
                    context.watch<LocaleController>().locale!.languageCode,
                  ),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LanguagePage())),
        ),
        ListTile(
          leading: const Icon(Icons.contrast_rounded),
          title: Text(t.appearance),
          subtitle: Text(
            switch (context.watch<ThemeController>().mode) {
              ThemeMode.dark => t.themeDark,
              ThemeMode.light => t.themeLight,
              ThemeMode.system => t.followingYourDevice,
            },
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _pickAppearance(context),
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(t.termsAndPrivacy),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LegalPage())),
        ),

        ListTile(
          leading: const Icon(Icons.download_outlined),
          title: Text(t.downloadMyData),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const DataExportPage())),
        ),

        _SectionLabel(t.session),
        ListTile(
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text(
            t.signOut,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          onTap: () => _confirmSignOut(context, auth),
        ),
        // Below sign-out, because it is the rarer and heavier of the two and
        // nobody should reach for it by mistake -- but present, and findable,
        // because Play requires deletion to be available in the app and a
        // person who wants out should not have to email anybody.
        ListTile(
          leading: Icon(
            Icons.person_remove_outlined,
            color: theme.colorScheme.error,
          ),
          title: Text(
            t.deleteAccount,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const DeleteAccountPage())),
        ),

        const SizedBox(height: 24),
        Center(
          child: Text(
            t.appTagline,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickAppearance(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final themes = context.read<ThemeController>();
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionLabel(t.appearance),
              for (final (mode, label, icon) in [
                (ThemeMode.system, t.followingYourDevice,
                    Icons.phone_android_rounded),
                (ThemeMode.dark, t.themeDark, Icons.dark_mode_rounded),
                (ThemeMode.light, t.themeLight, Icons.light_mode_rounded),
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ActionTile(
                    icon: icon,
                    title: label,
                    accent: themes.mode == mode,
                    trailing: themes.mode == mode
                        ? Icon(Icons.check_circle_rounded,
                            color: ctx.gym.accentText)
                        : const SizedBox.shrink(),
                    onTap: () {
                      themes.set(mode);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    AuthController auth,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).signOutQuestion),
        content: Text(AppLocalizations.of(ctx).signOutWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(ctx).signOut),
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
    return SectionLabel(
      label,
      padding: const EdgeInsets.fromLTRB(18, 26, 18, 6),
    );
  }
}
