import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../auth/auth_controller.dart';

/// A gym as a prospective member sees it: photos, description, perks, and
/// a way to get in touch. Exactly what the spec lists, and nothing that
/// would only matter to someone who already trains there.
class GymProfilePage extends StatefulWidget {
  const GymProfilePage({super.key, required this.gymId});

  final String gymId;

  @override
  State<GymProfilePage> createState() => _GymProfilePageState();
}

class _GymProfilePageState extends State<GymProfilePage> {
  Map<String, dynamic>? _gym;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final api = GymApi(context.read<AuthController>().client);
      final gym = await api.publicGym(widget.gymId);
      if (mounted) setState(() => _gym = gym);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  Future<void> _contact(String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$phone copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gym = _gym;

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(28),
          child: Text(_error!, textAlign: TextAlign.center),
        )),
      );
    }

    if (gym == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final images = ((gym['images'] as List?) ?? const []).cast<String>();
    final perks = ((gym['perks'] as List?) ?? const []).cast<String>();
    final rating = (gym['rating'] as num?)?.toDouble() ?? 0;
    final ratingCount = (gym['ratingCount'] as int?) ?? 0;
    final phone = gym['contactPhone'] as String?;

    return Scaffold(
      appBar: AppBar(title: Text(gym['name'] as String? ?? 'Gym')),
      body: ListView(
        children: [
          if (images.isNotEmpty)
            SizedBox(
              height: 220,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (_, i) => Image.network(
                  images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(gym['displayName'] as String? ?? '',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      ratingCount > 0
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      ratingCount > 0
                          ? '${rating.toStringAsFixed(1)} · $ratingCount rating${ratingCount == 1 ? '' : 's'}'
                          : 'No ratings yet',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                if ((gym['description'] as String?)?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 20),
                  Text(gym['description'] as String,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
                ],
                if (perks.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(AppLocalizations.of(context).whatYouGet.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 0.9,
                        color: theme.colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final perk in perks)
                        Chip(
                          label: Text(perk),
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 28),
                if (phone != null)
                  FilledButton.icon(
                    onPressed: () => _contact(phone),
                    icon: const Icon(Icons.phone_outlined),
                    label: Text(AppLocalizations.of(context).contactWithPhone(phone)),
                  ),
                const SizedBox(height: 12),
                Text(
                  'To join, contact the gym directly. They will add you as a member '
                  'and it will appear here automatically.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
