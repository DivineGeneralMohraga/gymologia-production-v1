import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_client.dart';
import '../auth/auth_controller.dart';

/// What the platform looks like today.
///
/// The numbers come straight from /admin/dashboard, which counts them in
/// the database rather than fetching rows and measuring the array — that
/// was fixed once here and once again in the per-gym analytics, which is
/// why this screen can afford to load them all at once.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final d = await context.read<AuthController>().api.dashboard();
      if (mounted) setState(() => _data = d);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _Retry(message: _error!, onRetry: _load);
    }
    if (_data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Field names taken from what /admin/dashboard actually returns, not
    // from what seemed natural while writing this screen. The first draft
    // read `engagement` (the server sends `members`) and treated `installs`
    // as a map (it is a list of rows), so three panels would have rendered
    // em-dashes against a perfectly healthy response.
    final people = _map(_data!['people']);
    final gyms = _map(_data!['gyms']);
    final members = _map(_data!['members']);
    final support = _map(_data!['support']);
    final installs = _data!['installs'];

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section('People', [
            _Stat('Accounts', people['total']),
            _Stat('New in 30 days', people['newInLast30Days']),
            _Stat('Gym owners', people['gymOwners']),
            _Stat('Staff records', people['gymStaffRecords'],
                note: 'records, not people — one person can work at several gyms'),
          ]),
          _Section('Gyms', [
            _Stat('Active', gyms['active']),
            _Stat('Draft', gyms['draft']),
            _Stat('Suspended', gyms['suspended']),
          ]),
          _Section('Members', [
            _Stat('Active memberships', members['active']),
            _Stat('Trained in 30 days', members['engaged']),
            _Stat('Engagement', members['engagementRate'], suffix: '%'),
          ]),
          _Section('Support', [
            _Stat('Open tickets', support['open']),
            _Stat('Urgent', support['urgent']),
          ]),
          _Section(
            'Installs',
            [
              if (installs is List && installs.isNotEmpty)
                for (final row in installs.cast<Map<String, dynamic>>())
                  _Stat('${row['appClient']} · ${row['platform']}',
                      row['installs']),
            ],
            // An empty list here is not "zero installs", it is "nothing has
            // reported any". Those are different facts and the screen says
            // which one it is holding.
            note: (installs is List && installs.isNotEmpty)
                ? null
                : 'No install figures have been reported. The table exists and '
                    'nothing writes to it yet, so this is missing data rather '
                    'than a measured zero.',
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _map(Object? v) =>
      v is Map<String, dynamic> ? v : const {};
}

class _Section extends StatelessWidget {
  const _Section(this.title, this.stats, {this.note});
  final String title;
  final List<Widget> stats;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(spacing: 24, runSpacing: 14, children: stats),
            if (note != null) ...[
              const SizedBox(height: 12),
              Text(note!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, {this.suffix = '', this.note});
  final String label;
  final Object? value;
  final String suffix;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${value ?? '—'}$suffix',
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: theme.textTheme.bodyMedium),
          if (note != null)
            Text(note!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _Retry extends StatelessWidget {
  const _Retry({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
}
