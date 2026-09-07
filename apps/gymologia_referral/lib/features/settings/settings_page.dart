import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../../core/config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_controller.dart';
import 'language_page.dart';
import 'legal_page.dart';
import 'support_page.dart';

/// Profile, language, the legal documents, support, and the way out.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = context.watch<AuthController>();

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: Text(auth.name.isEmpty ? t.profileTitle : auth.name),
          subtitle: Text([
            auth.phone,
            if (auth.email != null && auth.email!.isNotEmpty) auth.email!,
          ].join('  ·  ')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const _ProfilePage()),
          ),
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(t.languageTitle),
          subtitle: Text(LanguagePage.nameFor(
              Localizations.localeOf(context).languageCode)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LanguagePage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.gavel_outlined),
          title: Text(t.legalTitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LegalPage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.support_agent_outlined),
          title: Text(t.supportTitle),
          subtitle: Text(AppConfig.supportEmail),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SupportPage()),
          ),
        ),
        const Divider(height: 1),
        ListTile(
          leading: Icon(Icons.logout, color: theme.colorScheme.error),
          title: Text(t.signOut, style: TextStyle(color: theme.colorScheme.error)),
          onTap: () => _signOut(context),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${t.aboutTitle}  ·  ${AppConfig.displayHost}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final t = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(t.signOutConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(t.cancel)),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(t.signOut)),
        ],
      ),
    );
    if (confirmed == true) await auth.signOut();
  }
}

/// Name and email. The phone number is shown and cannot be edited here —
/// it is the login, and changing it is a re-verification, not a text field.
class _ProfilePage extends StatefulWidget {
  const _ProfilePage();

  @override
  State<_ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<_ProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthController>();
    _name = TextEditingController(text: auth.name);
    _email = TextEditingController(text: auth.email ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = t.nameRequired);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthController>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await auth.api.updateProfile(name: name, email: _email.text.trim());
      auth.updateLocalProfile(name: name, email: _email.text.trim());
      messenger.showSnackBar(SnackBar(content: Text(t.saved)));
      navigator.pop();
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text(t.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _name,
            enabled: !_busy,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                labelText: t.nameLabel, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _email,
            enabled: !_busy,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: t.emailLabel, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 14),
          TextField(
            enabled: false,
            controller: TextEditingController(text: auth.phone),
            decoration: InputDecoration(
                labelText: t.phoneLabel, border: const OutlineInputBorder()),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _busy ? null : _save,
            child: Text(t.save),
          ),
        ],
      ),
    );
  }
}
