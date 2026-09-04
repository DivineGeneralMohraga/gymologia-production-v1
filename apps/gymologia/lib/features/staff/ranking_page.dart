import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_client.dart';
import '../../core/api/gym_api.dart';
import '../../core/api/models.dart';
import '../auth/auth_controller.dart';

/// Where this gym sits in Gymologia search.
///
/// The position comes from the same ordering the search endpoint sorts by,
/// so what an owner reads here is what a member browsing would actually see.
class RankingPage extends StatefulWidget {
  const RankingPage({super.key, required this.gym});

  final GymDetail gym;

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  Map<String, dynamic>? _data;
  String? _error;

  GymApi get _api => GymApi(context.read<AuthController>().client);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final data = await _api.ranking(widget.gym.id);
      if (mounted) setState(() => _data = data);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _data;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).searchRanking)),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 18),
                    FilledButton.tonal(
                        onPressed: _load, child: Text(AppLocalizations.of(context).tryAgain)),
                  ],
                ),
              ),
            )
          : data == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    children: [
                      if (data['listed'] != true)
                        _NotListed(reason: data['reason'] as String? ?? '')
                      else ...[
                        _RatingCard(
                          rating: (data['rating'] as num?)?.toDouble() ?? 0,
                          ratingCount: data['ratingCount'] as int? ?? 0,
                          advice: data['advice'] as String?,
                        ),
                        const SizedBox(height: 8),
                        for (final scope in _scopes(data))
                          _ScopeCard(scope: scope),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context).rankingExplainer,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  List<Map<String, dynamic>> _scopes(Map<String, dynamic> data) {
    final raw = data['scopes'];
    return raw is List ? raw.cast<Map<String, dynamic>>() : const [];
  }
}

/// A gym that is not in search is told which of the three reasons it is,
/// because "you are not ranked" on its own leaves nothing to act on.
class _NotListed extends StatelessWidget {
  const _NotListed({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search_off,
                    color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Text(AppLocalizations.of(context).notInSearch,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            Text(reason, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.rating,
    required this.ratingCount,
    this.advice,
  });

  final double rating;
  final int ratingCount;
  final String? advice;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(rating.toStringAsFixed(1),
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    ratingCount == 1
                        ? 'from 1 rating'
                        : 'from $ratingCount ratings',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            if (advice != null) ...[
              const SizedBox(height: 10),
              Text(advice!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _ScopeCard extends StatelessWidget {
  const _ScopeCard({required this.scope});

  final Map<String, dynamic> scope;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final position = scope['position'] as int? ?? 0;
    final outOf = scope['outOf'] as int? ?? 0;
    final label = scope['label'] as String? ?? '';
    final top = position == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    outOf == 1 ? 'The only Pro gym here' : 'of $outOf Pro gyms',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '#$position',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: top ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
